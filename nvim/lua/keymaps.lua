-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>tq", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local is_enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
	if is_enabled then
		vim.diagnostic.enable(false, { bufnr = bufnr })
	else
		vim.diagnostic.enable(true, { bufnr = bufnr })
	end
end, { desc = "Toggle Diagnostics" })

vim.keymap.set("n", "<leader>o", "<cmd>write<CR>", { desc = "Write open buffer" })
-- Navigate between buffers
-- See `:help buffer`
-- Use <Tab> and <S-Tab> to navigate between buffers
vim.keymap.set("n", "<Tab>", "<cmd>:b#<CR>", { desc = "Switch to [#] alternate buffer" })
-- Use <leader>! to delete the current buffer
vim.keymap.set("n", "<leader>!", "<cmd>:bd<CR>", { desc = "[D]elete the current buffer" })

-- Use <leader>1-5 to navigate to a specific buffer
vim.keymap.set("n", "<leader>1", "<cmd>:buffer 1<CR>", { desc = "Move to buffer 1" })
vim.keymap.set("n", "<leader>2", "<cmd>:buffer 2<CR>", { desc = "Move to buffer 2" })
vim.keymap.set("n", "<leader>3", "<cmd>:buffer 3<CR>", { desc = "Move to buffer 3" })
vim.keymap.set("n", "<leader>4", "<cmd>:buffer 4<CR>", { desc = "Move to buffer 4" })
vim.keymap.set("n", "<leader>5", "<cmd>:buffer 5<CR>", { desc = "Move to buffer 5" })

-- Keybinds to make split navigation easier.
--  Use <leader>+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<leader>mh", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<leader>ml", "<C-w>l", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<leader>mj", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<leader>mk", "<C-w>k", { desc = "Move focus to the upper window" })

-- Window management keymaps
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wq", "<C-w>q", { desc = "Close current window" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Make windows equal size" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Close all other windows" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Key Disabled"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Key Disabled"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Key Disabled"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Key Disabled"<CR>')
