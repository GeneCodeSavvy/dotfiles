return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    dependencies = {
        "stevearc/dressing.nvim", -- Optional but recommended for better UI
    },

    config = function()
        local conform = require("conform")

        conform.setup({
            formatters = {
                -- Configure formatters
                stylua = {
                    cmd = "stylua",
                    filetypes = { "lua" },
                },
                prettierd = {
                    cmd = "prettierd",
                    filetypes = { "javascript", "typescript", "json", "markdown" },
                },
                black = {
                    cmd = "black",
                    filetypes = { "python" },
                },
            },

            -- Configure linters (diagnostics)
            linters = {
                eslint_lsp = {
                    cmd = "eslint-lsp",
                    filetypes = { "javascript", "typescript" },
                },
            },

            -- Format on save
            format_on_save = true,

            -- Optional: Format on change
            format_on_change = {
                enabled = false, -- Set to true if you want to format on every change
                delay = 100,      -- Debounce delay
            },

            -- Configure UI
            ui = {
                border = "rounded",
                max_width = 0.8,
                max_height = 0.8,
            },
        })

        -- Keymap for manual formatting
        vim.keymap.set("n", "<leader>fo", function()
            conform.format()
        end, { desc = "Format buffer" })
    end,
}
