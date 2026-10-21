-- ----------------------------
-- Basic Settings
-- ----------------------------

vim.o.background = "dark"
vim.o.number = true          -- Line numbers
vim.o.relativenumber = false -- Relative line numbers
vim.o.cursorline = true      -- Highlight current line
vim.o.scrolloff = 10         -- Keep 10 lines above/below cursor
vim.o.sidescrolloff = 8      -- Keep 8 columns left/right of cursor
vim.o.wrap = false           -- Don't wrap lines
vim.o.cmdheight = 1          -- Command line height

-- ----------------------------
-- Tabbing / Indentation
-- ----------------------------

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.showmode = false
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.grepprg = 'rg --vimgrep'   -- Use ripgrep if available
vim.o.grepformat = '%f:%l:%c:%m' -- filename, line number, column, content

-- ----------------------------
-- Search Settings
-- ----------------------------

vim.o.ignorecase = true -- Case-insensitive search
vim.o.smartcase = true  -- Case-sensitive if uppercase in search
vim.o.hlsearch = false  -- Don't highlight search results
vim.o.incsearch = true  -- Show matches as you type

-- ----------------------------
-- Visual Settings
-- ----------------------------
vim.o.wrap = true
vim.o.linebreak = true
vim.o.list = false
vim.o.termguicolors = true
vim.o.signcolumn = 'yes'                        -- Always show sign column
vim.o.showmatch = true                          -- Highlight matching brackets
vim.o.matchtime = 2                             -- How long to show matching bracket
vim.o.completeopt = 'menuone,noinsert,noselect' -- Completion options
vim.o.showmode = false                          -- Don't show mode in command line
vim.o.pumheight = 10                            -- Popup menu height
vim.o.pumblend = 10                             -- Popup menu transparency
vim.o.winblend = 0                              -- Floating window transparency
vim.o.conceallevel = 0                          -- Don't hide markup
vim.o.concealcursor = ''                        -- Show markup even on cursor line
vim.o.lazyredraw = false                        -- redraw while executing macros (butter UX)
vim.o.redrawtime = 10000                        -- Timeout for syntax highlighting redraw
vim.o.maxmempattern = 20000                     -- Max memory for pattern matching
vim.o.synmaxcol = 300                           -- Syntax highlighting column limit

-- ----------------------------
-- Cursor Settings
-- ----------------------------

vim.opt.guicursor = {
	"n-v-c:block",                                         -- Normal, Visual, Command-line
	'i-ci-ve:ver25',                                       -- Insert, Command-line Insert, Visual-exclusive (line cursor)
	"r-cr:hor20",                                          -- Replace, Command-line Replace
	"o:hor50",                                             -- Operator-pending
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- All modes: blinking & highlight groups
	"sm:block-blinkwait175-blinkoff150-blinkon175",        -- Showmatch mode
}

-- ----------------------------
-- File Handling
-- ----------------------------

vim.o.backup = false
vim.o.writebackup = false -- Don't backup before overwriting
vim.o.undofile = true     -- Persistent undo
vim.o.autoread = true     -- Auto-reload file if changed outside
vim.opt.autowrite = false -- Don't auto-save on some events
vim.o.swapfile = false
vim.o.updatetime = 50
vim.o.mousescroll = "ver:10,hor:6"
vim.o.clipboard = "unnamedplus"
vim.o.encoding = 'UTF-8'                      -- Use UTF-8 encoding

local undodir = '~/.local/share/nvim/undodir' -- Undo directory path
vim.opt.undodir = vim.fn.expand(undodir)      -- Expand to full path
local undodir_path = vim.fn.expand(undodir)
if vim.fn.isdirectory(undodir_path) == 0 then
	vim.fn.mkdir(undodir_path, 'p') -- Create if not exists
end

-- ----------------------------
-- Keymaps
-- ----------------------------
vim.g.mapleader = " "
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

vim.keymap.set('n', '<leader>bn', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<Cmd>bprevious<CR>', { desc = 'Previous buffer' })

vim.keymap.set("n", "<leader>v", "<C-w>v", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>w", "<C-w>w", { desc = "move buffer focus" })
vim.keymap.set("n", "<leader>c", "<C-w>c", { desc = "close buffer" })

vim.keymap.set('n', '<C-Up>', '<Cmd>resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-h>', '<C-W>H', { desc = 'Move window to far left', noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-W>L', { desc = 'Move window to far right', noremap = true, silent = true })

vim.keymap.set('v', '<', '<gv', { noremap = true, desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { noremap = true, desc = 'Indent right and reselect' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true })
vim.keymap.set("x", "p", [["_dP]])
vim.keymap.set('n', 's', '"_cl')
vim.keymap.set('v', 's', '"_c')
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])



-- ----------------------------
-- custom keybindings
-- ----------------------------

require("build")
require("curly_braces").setup()

vim.keymap.set('n', '<leader>rc', '<Cmd>e ~/.config/nvim/init.lua<CR>', { desc = 'Edit config' })

vim.keymap.set("n", "<leader>t", function()
	local ok, tp = pcall(require, "template_picker")
	if ok and tp.pick_template then tp.pick_template() end
end, { desc = "Insert template for filetype" })

vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>e", function()
	local Snacks = require("snacks")
	local explorer = Snacks.picker.get({ source = "explorer" })[1]
	if explorer then
		explorer:close()
	else
		Snacks.explorer()
	end
end, { desc = "Toggle Snacks File Explorer" })

vim.keymap.set('n', '<leader>gd', '<Cmd>DiffviewOpen<CR>', { desc = 'Open Diffview' })

function SearchClasses()
	require('telescope.builtin').lsp_dynamic_workspace_symbols({
		symbols = { "Class" },
		prompt_title = "Search Classes"
	})
end

function SearchFunctions()
	require('telescope.builtin').lsp_dynamic_workspace_symbols({
		symbols = { "Function", "Method" },
		prompt_title = "Search Functions"
	})
end

function SearchVariables()
	require('telescope.builtin').lsp_dynamic_workspace_symbols({
		symbols = { "Variable", "Constant" },
		prompt_title = "Search Variables"
	})
end

vim.keymap.set('n', '<leader><space>', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, {})
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, {})
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, {})
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, {})
vim.keymap.set('n', '<leader>sf', SearchFunctions, {})
vim.keymap.set('n', '<leader>sw', function() require('telescope.builtin').grep_string() end,
	{ desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics() end,
	{ desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end, {})


-- ----------------------------
-- autocmds
-- ----------------------------
-- Highlight the deleted text
local highlight_delete_group = vim.api.nvim_create_augroup('HighlightDelete', {})
vim.keymap.set('n', 'dd', function()
	-- highlight current line range
	vim.hl.range(
		0,
		highlight_delete_group,
		'IncSearch',
		{ vim.fn.line('.') - 1, 0 },
		{ vim.fn.line('.') - 1, -1 },
		{ timeout = 300 }
	)

	vim.defer_fn(function()
		vim.cmd('normal! dd')
	end, 50)
end, { noremap = true, silent = true })

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})


-- ----------------------------
-- themes
-- ----------------------------
local transparent_groups = {
	"Normal",
	"NormalFloat",
	"FloatBorder",
	"Pmenu",
	"Terminal",
	"EndOfBuffer",
	"FoldColumn",
	"Folded",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"NormalNC",
	"WhichKeyFloat",
	"TelescopeBorder",
	"TelescopeNormal",
	"TelescopePromptBorder",
	"TelescopePromptTitle",
	"NvimTreeNormal",
	"NvimTreeVertSplit",
	"NvimTreeEndOfBuffer",
	"NotifyINFOBody",
	"NotifyERRORBody",
	"NotifyWARNBody",
	"NotifyTRACEBody",
	"NotifyDEBUGBody",
	"NotifyINFOTitle",
	"NotifyERRORTitle",
	"NotifyWARNTitle",
	"NotifyTRACETitle",
	"NotifyDEBUGTitle",
	"NotifyINFOBorder",
	"NotifyERRORBorder",
	"NotifyWARNBorder",
	"NotifyTRACEBorder",
	"NotifyDEBUGBorder",
}

local function enable_transparency()
	for _, name in ipairs(transparent_groups) do
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
		if ok then
			hl.bg = nil
			vim.api.nvim_set_hl(0, name, hl)
		end
	end
end

local function apply_omarchy_theme()
	local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

	if vim.fn.filereadable(theme_file) == 0 then
		pcall(vim.pack.add, { { src = "https://github.com/catppuccin/nvim.git", name = "catppuccin" } })
		pcall(vim.cmd.colorscheme, "catppuccin")
		enable_transparency()
		return
	end

	local chunk = loadfile(theme_file)
	if not chunk then
		return
	end
	local ok, spec = pcall(chunk)
	if not ok or type(spec) ~= "table" then
		return
	end

	local repo, colorscheme
	for _, item in ipairs(spec) do
		if type(item) == "table" then
			if item[1] == "LazyVim/LazyVim" then
				colorscheme = item.opts and item.opts.colorscheme
			elseif not repo and type(item[1]) == "string" then
				repo = item[1]
			end
		end
	end

	if repo then
		if not repo:match("^https?://") then
			repo = "https://github.com/" .. repo .. ".git"
		end
		pcall(vim.pack.add, { { src = repo } })
	end

	if colorscheme then
		pcall(vim.cmd.colorscheme, colorscheme)
	end

	enable_transparency()
end

apply_omarchy_theme()

vim.api.nvim_create_autocmd("User", {
	pattern = "OmarchyThemeChanged",
	callback = apply_omarchy_theme,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.schedule(enable_transparency)
	end,
})
vim.api.nvim_create_autocmd("VimEnter", {
	callback = enable_transparency,
})

-- ----------------------------
-- lsp, autocomplete stuff
-- ----------------------------
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "basedpyright", "rust_analyzer", "emmet_ls", "eslint", "ts_ls", "tailwindcss", "clangd" },
})

-- ----------------------------
-- lspsaga
-- ----------------------------
vim.pack.add({
	{ src = "https://github.com/glepnir/lspsaga.nvim.git" },
})

local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

saga.setup({
	scroll_preview = { scroll_down = "<C-k>", scroll_up = "<C-j>" },
	-- use enter to open a file with definition preview
	definition = {
		edit = "<CR>",
	},
	ui = {
		colors = {
			normal_bg = "#022746",
		},
	},
})

--vim.lsp.enable({ "lua_ls", "basedpyright", "rust_analyzer", "djlsp", "gdscript" })
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action({
			filter = function(action)
				return not action.disabled
			end,
		})
	end, opts)
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Show documentation for what is under cursor" }) -- show documentation for what is under cursor
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
	vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
end

vim.lsp.config("djlsp", { on_attach = on_attach })
vim.lsp.config("eslint", { on_attach = on_attach })
vim.lsp.config("ts_ls", { on_attach = on_attach })
vim.lsp.config("tailwindcss", { on_attach = on_attach })

vim.lsp.config("basedpyright", {
	on_attach = on_attach,
	root_dir = require("lspconfig.util").root_pattern(".git", "setup.py", "pyproject.toml", "requirements.txt"),
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				typeCheckingMode = 'basic'
			},
		},
	},
})

vim.lsp.config("emmet_ls", {
	on_attach = on_attach,
	filetypes = { "htmldjango", "djangohtml", "html" },
})

vim.lsp.config("lua_ls", { on_attach = on_attach })
vim.lsp.config("rust_analyzer", { on_attach = on_attach })
vim.lsp.config("clangd", { on_attach = on_attach })

local lsp_km_group = vim.api.nvim_create_augroup("LspKeymapsBackup", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_km_group,
	callback = function(args)
		local bufnr = args.buf
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
		vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Type Definition" })
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = bufnr, noremap = true, silent = true })

		vim.keymap.set("n", "<leader>la", function()
			vim.lsp.buf.code_action({ filter = function(a) return not a.disabled end })
		end, { buffer = bufnr, noremap = true, silent = true })

		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>",
			{ buffer = bufnr, desc = "Show documentation for what is under cursor" }) -- show documentation for what is under cursor

		vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end,
			{ buffer = bufnr, noremap = true, silent = true })
	end,
})

vim.pack.add({
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({
	virtual_text = false,
	signs = false,
	jump = { float = true },
})

-- ----------------------------
-- nvim-cmp
-- ----------------------------
vim.pack.add({
	{ src = "https://github.com/hrsh7th/nvim-cmp.git" },
	{ src = "https://github.com/hrsh7th/cmp-buffer.git" },
	{ src = "https://github.com/L3MON4D3/LuaSnip.git" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip.git" },
	{ src = "https://github.com/rafamadriz/friendly-snippets.git" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp.git" },
	{ src = "https://github.com/onsails/lspkind.nvim.git" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" }, -- icons for lualine
})

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
	return
end

vim.opt.completeopt = "menu,menuone"

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(),       -- prev suggestion
		["<C-j>"] = cmp.mapping.select_next_item(),       -- next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4),          -- scroll docs
		["<C-f>"] = cmp.mapping.scroll_docs(4),           -- scroll docs
		["<C-Space>"] = cmp.mapping.complete(),           -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(),                  -- close completion suggestions
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- show completion suggestions
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- lsp
		{ name = "luasnip" }, --snippets
		{ name = "buffer" }, -- text within current buffer
		{ name = "path" },   -- file system paths
	}),
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
})

vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})


-- ----------------------------
-- plugins
-- ----------------------------

-- sleuth
vim.pack.add({
	{ src = "https://github.com/tpope/vim-sleuth" },
})


-- nvim-notify
vim.pack.add({
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
})
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	cmdline = { enabled = false }, -- restore the native bottom cmdline
	messages = { enabled = false }, -- required: ext_messages hides the native cmdline
	presets = {
		bottom_search = true,        -- use a classic bottom cmdline for search
		command_palette = false,     -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,          -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false,      -- add a border to hover docs and signature help
	},
})


-- treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").install({
	"bash", "c", "cpp", "css", "gdscript", "gdshader", "godot_resource",
	"htmldjango", "html", "javascript", "json", "lua", "markdown", "markdown_inline",
	"python", "query", "typescript", "vim", "vimdoc",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})


-- gitsigns
vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim.git" },
})

local gitsigns_setup, gitsigns = pcall(require, "gitsigns")
if not gitsigns_setup then
	return
end

gitsigns.setup()


-- todo-comments
vim.pack.add({
	{ src = "https://github.com/travisvroman/todo-comments.nvim.git" },
})

local todocomments_status, todocomments = pcall(require, "todo-comments")
if not todocomments_status then
	return
end

local setup_config = {
	keywords = {
		TODO = { color = "#e62937" },
		NOTE = { color = "#008000" },
		LEFTOFF = { color = "#ffff99" },
		FIX = { color = "#f06292" },
	},
	highlight = {
		pattern = {
			[[(NOCHECKIN|nocheckin)\s*]],
			[[(KEYWORDS|keywords)\s*(\([^\)]*\))?:]],
		},
		keyword = "fg",
		comments_only = true,
	},
	merge_keywords = true,
}

todocomments.setup(setup_config)


-- nvim-tree
vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({
	hijack_directories = {
		enable = false,
	},
	view = {
		adaptive_size = true,
	},
	update_focused_file = {
		enable = true,
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
})


-- telescope
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
})

require('telescope').setup({
	pickers = {
		buffers = {
			initial_mode = "normal",
		},
	},
})


-- conform
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	--	format_on_save = {
	--		timeout_ms = 500,
	--		lsp_fallback = true,
	--	},
	formatters_by_ft = {
		rust = { "rustfmt" },
		python = { "black" },
		htmldjango = { "djlint" },
		javascript = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		lua = { "stylua" },
	},
})


-- lualine
vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require('lualine').setup({
	options = {
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { { 'mode', color = { gui = 'bold' } } },
		lualine_b = {
			{ 'branch' },
			'diff'
		},
		lualine_c = {
			{
				'filename',
				path = 0,
				file_status = true,
			}
		},
		lualine_x = { 'diagnostics', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { { 'location', color = { gui = 'bold' } } }
	},
	inactive_sections = {
		lualine_c = { { 'filename', path = 1, file_status = true } },
	},
	extensions = {}
})


-- snacks
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})
require("snacks").setup({
	explorer = {},
	picker = {
		sources = {
			explorer = {
				win = {
					list = {
						keys = {
							["d"] = { "explorer_del", mode = { "n" } },
							["A"] = { "explorer_add", mode = { "n" } },
							["r"] = { "explorer_rename", mode = { "n" } },
						},
					},
				},
			},
		},
	},
})


-- diffview
vim.pack.add({
	{ src = "https://github.com/sindrets/diffview.nvim" },
})
