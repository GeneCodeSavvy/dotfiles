return {
	"nvim-neorg/neorg",
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "*", -- Pin Neorg to the latest stable release
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.export"] = {},
				["core.export.markdown"] = { config = { extensions = "all" } },
				["core.dirman"] = {
					config = {
						workspaces = {
							cs_maths = "~/notes/cs_maths",
							cs_theory = "~/notes/cs_theory",
							projects = "~/notes/projects",
							machine_learning = "~/notes/machine_learning",
							backend = "~/notes/backend",
							philosophy = "~/notes/philosophy",
							biology = "~/notes/biology",
							life = "~/notes/life",
							development = "~/notes/development",
						},
						default_workspace = "development",
					},
				},
				["core.itero"] = {},
				["core.summary"] = {},
				["core.completion"] = { config = { engine = "nvim-cmp" } },
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
