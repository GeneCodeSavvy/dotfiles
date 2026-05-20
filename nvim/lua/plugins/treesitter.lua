vim.treesitter.language.register("jinja", { "njk" })

local treesitter_languages = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"query",
	"vim",
	"vimdoc",
	"css",
	"typescript",
	"jinja",
}

return { -- Highlight, edit, and navigate code
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local treesitter = require("nvim-treesitter")

			treesitter.setup()
			treesitter.install(treesitter_languages)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = treesitter_languages,
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		"nvim-treesitter/nvim-treesitter-context",
		opts = {},
	},
}
