-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_user_command("InsertDate", function()
	local date = os.date("%Y-%m-%d")
	vim.api.nvim_put({ date }, "l", true, true)
end, {})

vim.api.nvim_create_user_command("InsertTime", function()
	local time = os.date("%H:%M:%S")
	vim.api.nvim_put({ time }, "l", true, true)
end, {})

vim.filetype.add({
	extension = {
		njk = "jinja",
		jinja = "jinja",
	},
})
