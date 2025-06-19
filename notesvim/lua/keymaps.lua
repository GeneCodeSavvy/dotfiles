-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navigate between buffers
-- See `:help buffer`
-- Use <Tab> and <S-Tab> to navigate between buffers
vim.keymap.set("n", "<Tab>", "<cmd>:bn!<CR>", { desc = "Move to [N]ext buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>:bp!<CR>", { desc = "Move to [P]revious buffer" })
-- Use <leader>! to delete the current buffer
vim.keymap.set("n", "<leader>!", "<cmd>:bd<CR>", { desc = "[D]elete the current buffer" })

-- Use <leader>1-5 to navigate to a specific buffer
vim.keymap.set("n", "<leader>1", "<cmd>:buffer 1<CR>", { desc = "Move to buffer 1" })
vim.keymap.set("n", "<leader>2", "<cmd>:buffer 2<CR>", { desc = "Move to buffer 2" })
vim.keymap.set("n", "<leader>3", "<cmd>:buffer 3<CR>", { desc = "Move to buffer 3" })
vim.keymap.set("n", "<leader>4", "<cmd>:buffer 4<CR>", { desc = "Move to buffer 4" })
vim.keymap.set("n", "<leader>5", "<cmd>:buffer 5<CR>", { desc = "Move to buffer 5" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Key Disabled"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Key Disabled"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Key Disabled"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Key Disabled"<CR>')

-- Neorg
vim.keymap.set("n", "<leader>i", "<cmd>Neorg inject-metadata<CR>", { desc = "Inject metadata to Neorg file" })
vim.keymap.set("n", "<leader>tj", function()
	vim.cmd("Neorg workspace life")
	vim.cmd("Neorg journal today")
    vim.cmd("Neorg inject-metadata")
end, { desc = "Open [T]oday's [J]ournal" })
vim.keymap.set("n", "<leader>wi", function()
	vim.cmd("Neorg index")
end, { desc = "Open [W]orkspace [I]ndex" })
vim.keymap.set("n", "<leader>ne", function()
  local name = vim.fn.expand("%:t:r") -- gets the file name without extension
  local cmd = "Neorg export to-file ~/Desktop/100xdevs/playground/ADevsJournal/src/blog/" .. name .. ".md markdown"
  vim.cmd(cmd)
end, { desc = "Export Neorg file to markdown", silent = true })
