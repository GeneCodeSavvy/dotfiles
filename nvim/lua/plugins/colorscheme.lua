return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	config = function()
		require("onedarkpro").setup({
			styles = {
				types = "NONE",
				methods = "NONE",
				numbers = "NONE",
				strings = "NONE",
				comments = "italic",
				keywords = "italic",
				constants = "NONE",
				functions = "bold",
				operators = "NONE",
				variables = "NONE",
				parameters = "NONE",
				conditionals = "italic",
				virtual_text = "NONE",
			},
			options = {
				cursorline = true,
				transparency = false,
				terminal_colors = true,
				lualine_transparency = false,
				highlight_inactive_windows = true,
			},
		})

		vim.cmd("colorscheme onelight")
	end,
}
