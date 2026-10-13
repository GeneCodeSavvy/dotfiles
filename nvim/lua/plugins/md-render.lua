return {
	"delphinus/md-render.nvim",
	version = "*",
	ft = "markdown",
	cmd = "MdRender",
	init = function()
		-- Default wrap cap is 80 columns; the float is sized from wrapped
		-- content, so that also keeps the window small. 160 lets previews use
		-- more of a wide terminal (the float is still capped at 80% of the editor).
		vim.g.md_render_max_width = 160
	end,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	keys = {
		{ "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
		{ "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
		{ "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
	},
}
