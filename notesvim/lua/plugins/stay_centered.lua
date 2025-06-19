return {
	"arnamak/stay-centered.nvim",
	lazy = false,
	name = "stay-centered",
	priority = 1000,
	keys = {
		{
			"<leader>st",
			function()
				require("stay-centered").toggle()
			end,
			desc = "Toggle stay-centered.nvim",
		},
	},
	opts = {
		enabled = true,
	},
}
