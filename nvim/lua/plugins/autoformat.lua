return {
	{
		"stevearc/conform.nvim",
		init = function()
			vim.g.disable_autoformat = true -- Disable autoformat by default
		end,
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,

			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt

				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,

			-- Custom Commands to enable/disable autoformat
			vim.api.nvim_create_user_command("FormatToggle", function(args)
				local scope = args.bang and "b" or "g"
				local current = vim[scope].disable_autoformat
				vim[scope].disable_autoformat = not current

				local status = vim[scope].disable_autoformat and "disabled" or "enabled"
				print("Autoformat " .. status .. " for " .. (scope == "b" and "buffer" or "global"))
			end, {
				desc = "Toggle autoformat-on-save (use ! for buffer-local)",
				bang = true,
			}),

			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = { "ruff_format" },
				xml = { "xmlformatter" },
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "biome", "biome-organize-imports" },
				-- javascriptreact = { "biome", "biome-organize-imports" },
				-- typescript = { "biome", "biome-organize-imports" },
				-- typescriptreact = { "biome", "biome-organize-imports" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "biome" },
				html = { "htmlbeautifier" },
				jinja = { "djlint" },
			},

			formatters = {
				-- You can also define your own formatters
				ruff_format = {
					append_args = {
						"--config",
						"format.quote-style = 'single'",
						"--config",
						"line-length=119",
					},
				},
			},
		},
	},
}
