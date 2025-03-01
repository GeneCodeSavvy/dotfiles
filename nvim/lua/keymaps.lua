-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

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

-- Move lines up and down
vim.keymap.set({ "n", "v" }, "<A-j>", "<cmd>:m .+1<CR>==", { desc = "Move the current line down" })
vim.keymap.set({ "n", "v" }, "<A-k>", "<cmd>:m .-2<CR>==", { desc = "Move the current line up" })

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
