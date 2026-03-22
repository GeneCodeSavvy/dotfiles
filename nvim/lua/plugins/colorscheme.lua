return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			compile = true, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true }, -- TRIGGERS RADON HANDWRITING
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- we will set the BG manually below
			dimInactive = true, -- dims inactive windows
			terminalColors = true, -- define vim.g.terminal_color_{0..15}
			overrides = function(colors)
				local theme = colors.theme
				return {
					-- 1. Match the exact "Cocoa" background of your Ghostty rice
					Normal = { bg = "#160C0A", fg = "#EAD8C0" },
					NormalFloat = { bg = "#1B100E" }, -- Slightly lighter for popups
					FloatBorder = { fg = "#8A9A5B", bg = "#1B100E" }, -- Sage border

					-- 2. Make comments look like handwritten notes (Sage Green)
					Comment = { fg = "#8A9A5B", italic = true },

					-- 3. Match the "Lotus Red" for control flow/keywords
					["@keyword"] = { fg = "#D1495B", italic = true },
					["@repeat"] = { fg = "#D1495B", italic = true },
					["@conditional"] = { fg = "#D1495B", italic = true },

					-- 4. Match "Saffron Gold" for functions and numbers
					["@function"] = { fg = "#E9C46A", bold = true },
					["@number"] = { fg = "#E9C46A" },

					-- 5. Telescope "Gallery Plaque" Look
					TelescopeTitle = { fg = "#E9C46A", bold = true },
					TelescopeBorder = { fg = "#1B100E", bg = "#160C0A" },
				}
			end,
			theme = "dragon", -- The "Dragon" variant is the warmest/darkest
		})

		-- Load the colorscheme
		vim.cmd("colorscheme kanagawa-dragon")
	end,
}
