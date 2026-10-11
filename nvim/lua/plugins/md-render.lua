return {
	"delphinus/md-render.nvim",
	version = "*",
	ft = "markdown",
	cmd = "MdRender",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	keys = {
		{ "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
		{ "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
		{ "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
	},
}
