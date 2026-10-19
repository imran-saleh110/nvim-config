local is_windows = vim.fn.has("win32") == 1

if is_windows then
	vim.keymap.set("n", "<leader>b", "<C-w>s<cr>|<cmd>:term build.bat<cr>i", { desc = "[B]uild [D]ebug" })
	vim.keymap.set("n", "<leader>bd", "<C-w>s<cr>|<cmd>:term build-debug.bat<cr>i", { desc = "[B]uild [D]ebug" })
	vim.keymap.set("n", "<leader>br", "<C-w>s<cr>|<cmd>:term build-release.bat<cr>i", { desc = "[B]uild [R]elease" })
	vim.keymap.set("n", "<leader>bc", "<C-w>s<cr>|<cmd>:term clean.bat<cr>i", { desc = "[B]uild->[C]lean" })
else
	vim.keymap.set("n", "<leader>b", "<C-w>s<cr>|<cmd>:term ./build.sh<cr>i", { desc = "[B]uild [D]ebug" })
	vim.keymap.set("n", "<leader>bd", "<C-w>s<cr>|<cmd>:term ./build-debug.sh<cr>i", { desc = "[B]uild [D]ebug" })
	vim.keymap.set("n", "<leader>br", "<C-w>s<cr>|<cmd>:term ./build-release.sh<cr>i", { desc = "[B]uild [R]elease" })
	vim.keymap.set("n", "<leader>bc", "<C-w>s<cr>|<cmd>:term ./clean.sh<cr>i", { desc = "[B]uild->[C]lean" })
end

return { is_windows = is_windows }
