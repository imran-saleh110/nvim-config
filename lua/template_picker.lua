local M = {}

---@param path string
local function read_file(path)
  local lines = vim.fn.readfile(path)
  return lines
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

  -- Map files to Snacks items
  local items = {}
  for _, path in ipairs(templates) do
    table.insert(items, {
      text = vim.fn.fnamemodify(path, ":t"),
      file = path, -- 'file' key enables built-in preview logic easily
    })
  end

  -- Trigger the Snacks Picker
  Snacks.picker.pick({
    title = "Templates (" .. ft .. ")",
    items = items,
    format = "text",
    layout = "vertical", -- Optional: better for viewing code templates
    preview = "file",    -- Uses the built-in file previewer
    confirm = function(picker, item)
      picker:close()
      if not item then return end

      local content = read_file(item.file)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      -- Insert template content at current cursor position
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
