-- Curly brace completion with block auto indentation.
--
--   * typing `{` inserts `{}` and keeps the cursor between the braces
--   * pressing <CR> between a pair of braces expands them into an indented block
--   * typing `}` on an otherwise blank line re-indents it to match its opening brace
--
-- Only curly braces are handled, brackets and quotes are left untouched.
--
-- Key presses are noticed with |vim.on_key()|, but the buffer is only touched
-- once the editor went idle again.  Doing it right away would place the text
-- at the wrong spot when several keys arrive in one go (fast typing), and
-- swallowing the key instead would leave a stray byte in the buffer.

local M = {}

local logfile = vim.env.CB_DEBUG and io.open(vim.env.CB_DEBUG, "a") or nil

---@param msg string
local function log(msg)
	if not logfile then
		return
	end
	logfile:write(msg .. "\n")
	logfile:flush()
end

local defaults = {
	enabled = true, -- master switch
	auto_indent = true, -- expand braces over several lines when pressing <CR>
	dedent_closing = true, -- re-indent a typed `}` to match its opening `{`
	exclude_filetypes = {}, -- filetypes where the plugin stays inert
}

local opts = vim.deepcopy(defaults)

-- work collected from key presses, applied once the editor is idle
local pending = { open = false, close = false, enter = false }
local pending_buf = nil
local scheduled = false
local ns_id = nil

-- ---------------------------------------------------------------------------
-- comment markers, used by the fallback scanner when treesitter/syntax are
-- not available for the current buffer
-- ---------------------------------------------------------------------------

local hash_filetypes = {
	python = true, python3 = true, sh = true, bash = true, zsh = true, fish = true,
	ruby = true, yaml = true, toml = true, perl = true, r = true, make = true,
	dockerfile = true, gitcommit = true, conf = true, nim = true, crystal = true,
	elixir = true, terraform = true, hcl = true, awk = true, sed = true,
}

local slash_filetypes = {
	c = true, cpp = true, java = true, javascript = true, javascriptreact = true,
	typescript = true, typescriptreact = true, tsx = true, go = true, rust = true,
	php = true, css = true, scss = true, sass = true, less = true, swift = true,
	kotlin = true, scala = true, dart = true, zig = true, jsonc = true, json5 = true,
	proto = true, cs = true,
}

local dash_filetypes = {
	lua = true, sql = true, haskell = true, elm = true, ada = true,
}

---@param ft string
---@return string[]
local function comment_markers(ft)
	if hash_filetypes[ft] then
		return { "#" }
	elseif slash_filetypes[ft] then
		return { "//" }
	elseif dash_filetypes[ft] then
		return { "--" }
	end
	return {}
end

-- ---------------------------------------------------------------------------
-- context detection
-- ---------------------------------------------------------------------------

---Checks the treesitter node at the given position for string/comment content.
---@param bufnr integer
---@param row integer zero based row
---@param col integer zero based byte column
---@return boolean|nil nil when treesitter cannot tell
local function treesitter_is_text(bufnr, row, col)
	local ok, node = pcall(vim.treesitter.get_node, { bufnr, row, col })
	if not ok or not node then
		return nil
	end

	while node do
		local kind = node:type()
		if kind:find("comment", 1, true) or kind:find("string", 1, true) or kind == "char" or kind == "regex" then
			return true
		end
		node = node:parent()
	end

	return false
end

---Checks the syntax group at the given position for string/comment content.
---@param row integer zero based row
---@param col integer zero based byte column
---@return boolean|nil nil when there is no syntax information
local function syntax_is_text(row, col)
	local ok, id = pcall(vim.fn.synID, row + 1, col + 1, true)
	if not ok or not id or id == 0 then
		return nil
	end

	local name = (vim.fn.synIDattr(id, "name") or ""):lower()
	if name:find("comment", 1, true) or name:find("string", 1, true) then
		return true
	end

	return false
end

---Scans `text` up to `stop` and reports the brace depth, whether that position
---sits inside a string and whether it sits inside a comment.
---@param text string
---@param stop integer byte index to stop at
---@param markers string[]
---@return integer depth, boolean in_string, boolean in_comment
local function scan(text, stop, markers)
	local depth, quote, in_comment = 0, nil, false
	local i = 1
	stop = math.min(stop, #text)

	while i <= stop do
		local char = text:sub(i, i)

		if in_comment then
			-- comments run until the end of the line
		elseif quote then
			if char == "\\" then
				i = i + 1
			elseif char == quote then
				quote = nil
			end
		else
			local commented = false
			for _, marker in ipairs(markers) do
				if text:sub(i, i + #marker - 1) == marker then
					in_comment = true
					i = i + #marker - 1
					commented = true
					break
				end
			end

			if not commented then
				if char == '"' or char == "'" or char == "`" then
					quote = char
				elseif char == "{" then
					depth = depth + 1
				elseif char == "}" then
					depth = depth - 1
				end
			end
		end

		i = i + 1
	end

	return depth, quote ~= nil, in_comment
end

---Tells whether the given position holds string or comment content.
---@param bufnr integer
---@param row integer zero based row
---@param col integer zero based byte column
---@return boolean
local function in_text(bufnr, row, col)
	local ts = treesitter_is_text(bufnr, row, col)
	if ts ~= nil then
		return ts
	end

	local syn = syntax_is_text(row, col)
	if syn ~= nil then
		return syn
	end

	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
	local _, in_string, in_comment = scan(line, col, comment_markers(vim.bo[bufnr].filetype))
	return in_string or in_comment
end

-- ---------------------------------------------------------------------------
-- helpers
-- ---------------------------------------------------------------------------

---The string used for one level of indentation.
---@return string
local function indent_unit()
	local width = vim.fn.shiftwidth()
	if width == 0 then
		width = vim.bo.tabstop
	end
	if vim.bo.expandtab then
		return string.rep(" ", width)
	end
	return "\t"
end

---The indent of the line that holds the brace opening the block closed at the
---given spot.
---@param row integer zero based row
---@param col integer zero based column, the text before it is searched
---@return string|nil
local function matching_open_brace_indent(row, col)
	local lines = vim.api.nvim_buf_get_lines(0, 0, row + 1, false)
	local depth = 0

	for i = #lines, 1, -1 do
		local line = lines[i]
		local stop = (i == row + 1) and col or #line

		for j = stop, 1, -1 do
			local char = line:sub(j, j)
			if char == "}" then
				depth = depth + 1
			elseif char == "{" then
				if depth == 0 then
					return line:match("^(%s*)") or ""
				end
				depth = depth - 1
			end
		end
	end

	return nil
end

---Tells whether a completion menu is open, in which case <CR> belongs to it.
---@return boolean
local function completion_visible()
	local ok, cmp = pcall(require, "cmp")
	if ok and type(cmp) == "table" and type(cmp.visible) == "function" and cmp.visible() then
		return true
	end
	return vim.fn.pumvisible() == 1
end

---@param row integer one based row
---@return string
local function get_line(row)
	return vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
end

---@return integer row, integer col, string line
local function current_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	return row, col, get_line(row)
end

-- ---------------------------------------------------------------------------
-- the three actions
-- ---------------------------------------------------------------------------

---Closes the brace that was just opened.
local function open_brace()
	local row, col, line = current_line()
	log(string.format("  open_brace row=%d col=%d line=%s", row, col, vim.inspect(line)))
	if in_text(0, row - 1, col) then
		log("    in text")
		return
	end

	-- only pair up when the cursor sits inside a block
	local depth = scan(line, col, comment_markers(vim.bo.filetype))
	if depth <= 0 then
		return
	end

	-- the closing brace is already there, the cursor is in the right place
	if line:sub(col + 1, col + 1) == "}" then
		return
	end

	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "}" })
	vim.api.nvim_win_set_cursor(0, { row, col })
end

---Handles the closing brace that was just typed.
local function close_brace()
	local row, col, line = current_line()
	log(string.format("  close_brace row=%d col=%d line=%s", row, col, vim.inspect(line)))
	if in_text(0, row - 1, col) then
		return
	end

	-- the typed brace duplicates the one behind the cursor, drop it
	if line:sub(col, col) == "}" and line:sub(col + 1, col + 1) == "}" then
		vim.api.nvim_buf_set_text(0, row - 1, col - 1, row - 1, col, { "" })
		vim.api.nvim_win_set_cursor(0, { row, col })
		return
	end

	if not opts.dedent_closing then
		return
	end

	-- a lone `}` on a blank line moves to the indent of its opening brace
	local head = line:sub(1, col - 1)
	if not head:match("^%s*$") then
		return
	end

	local indent = matching_open_brace_indent(row - 1, col - 1)
	if not indent then
		return
	end

	vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, #head, { indent })
	vim.api.nvim_win_set_cursor(0, { row, #indent + 1 })
end

---Expands the braces around the cursor into an indented block.
local function enter()
	if not opts.auto_indent then
		return
	end

	local row, col, line = current_line()
	log(string.format("  enter row=%d col=%d line=%s", row, col, vim.inspect(line)))
	local after = line:sub(col + 1)

	-- the closing brace sits right behind the cursor
	if after:sub(1, 1) == "}" then
		local indent = matching_open_brace_indent(row - 1, col)
		if not indent then
			return
		end

		local head = line:sub(1, col)
		local content = indent .. indent_unit()
		vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, #line, {
			content .. head,
			indent .. after,
		})
		vim.api.nvim_win_set_cursor(0, { row, #content + #head })
		return
	end

	-- the closing brace already sits on its own line
	local below = get_line(row + 1)
	if not below then
		return
	end

	local spaces = below:match("^%s*")
	local rest = below:sub(#spaces + 1)
	if rest:sub(1, 1) ~= "}" then
		return
	end

	local own = line:match("^(%s*)") or ""
	if own ~= "" and line:sub(#own + 1) ~= "" then
		return
	end

	local indent = matching_open_brace_indent(row, #own)
	if not indent then
		return
	end

	local content = indent .. indent_unit()
	vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, #line, { content })
	vim.api.nvim_buf_set_text(0, row, 0, row, #below, { indent .. rest })
	vim.api.nvim_win_set_cursor(0, { row, #content })
end

-- ---------------------------------------------------------------------------
-- scheduling
-- ---------------------------------------------------------------------------

local function apply_pending()
	scheduled = false

	local open, close, retype = pending.open, pending.close, pending.enter
	pending.open, pending.close, pending.enter = false, false, false

	log(string.format("apply_pending open=%s close=%s enter=%s mode=%s", tostring(open), tostring(close), tostring(retype), vim.fn.mode()))
	if not (open or close or retype) then
		return
	end
	if vim.api.nvim_get_current_buf() ~= pending_buf then
		log("  wrong buffer")
		return
	end
	if vim.fn.mode():sub(1, 1) ~= "i" then
		log("  not insert mode")
		return
	end

	if open then
		open_brace()
	end
	if close then
		close_brace()
	end
	if retype then
		enter()
	end
end

local function schedule()
	if scheduled then
		return
	end
	scheduled = true
	vim.schedule(apply_pending)
end

-- ---------------------------------------------------------------------------
-- entry point
-- ---------------------------------------------------------------------------

---@param key string the key after mappings were applied
---@param typed string the key as it was typed
---@return string|nil
local function on_key(key, typed)
	if typed ~= "{" and typed ~= "}" and typed ~= "\r" then
		return nil
	end
	log(string.format("on_key typed=%q key=%q mode=%s", typed, key, vim.fn.mode()))
	if vim.fn.mode():sub(1, 1) ~= "i" then
		return nil
	end
	if not vim.bo.modifiable then
		return nil
	end
	if opts.exclude_filetypes[vim.bo.filetype] then
		return nil
	end

	if typed == "{" then
		pending.open = true
	elseif typed == "}" then
		pending.close = true
	else
		-- <CR> belongs to the completion menu while it is open
		if completion_visible() then
			return nil
		end
		pending.enter = true
	end

	pending_buf = vim.api.nvim_get_current_buf()
	schedule()
	return nil
end

---Sets the plugin up.
---@param user_opts table|nil
function M.setup(user_opts)
	opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), user_opts or {})

	if ns_id then
		pcall(vim.on_key, nil, ns_id)
		ns_id = nil
	end

	if not opts.enabled then
		return
	end

	ns_id = vim.on_key(on_key)
end

return M
