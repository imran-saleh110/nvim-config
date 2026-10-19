local M = {}

local AUTHOR = "Imran Saleh"

---@param path string
local function read_file(path)
  return vim.fn.readfile(path)
end

---@param lines string[]
---@return string[]
local function process_template(lines)
  local filename = vim.fn.expand("%:t")
  local date = os.date("%d-%m-%Y")

  local replacements = {
    ["{{FILENAME}}"] = filename,
    ["{{DATE}}"] = date,
    ["{{AUTHOR}}"] = AUTHOR,
  }

  local result = {}

  for _, line in ipairs(lines) do
    for placeholder, value in pairs(replacements) do
      line = line:gsub(placeholder, function()
        return value
      end)
    end

    table.insert(result, line)
  end

  return result
end

function M.pick_template()
  local ft = vim.bo.filetype

  if ft == "" then
    vim.notify("No filetype detected", vim.log.levels.WARN)
    return
  end

  local template_dir = vim.fn.stdpath("config") .. "/templates/" .. ft

  if vim.fn.isdirectory(template_dir) == 0 then
    vim.notify("No templates for filetype: " .. ft, vim.log.levels.INFO)
    return
  end

  local templates = vim.fn.globpath(template_dir, "*", false, true)

  if #templates == 0 then
    vim.notify("Template directory is empty", vim.log.levels.INFO)
    return
  end

  local items = {}

  for _, path in ipairs(templates) do
    table.insert(items, {
      text = vim.fn.fnamemodify(path, ":t"),
      file = path,
    })
  end

  Snacks.picker.pick({
    title = "Templates (" .. ft .. ")",
    items = items,
    format = "text",
    layout = "vertical",
    preview = "file",

    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end

      local content = process_template(read_file(item.file))
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      vim.api.nvim_buf_set_text(
        0,
        row - 1,
        col,
        row - 1,
        col,
        content
      )
    end,
  })
end

return M

