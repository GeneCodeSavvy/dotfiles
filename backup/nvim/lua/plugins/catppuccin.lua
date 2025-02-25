return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "auto", -- Options: latte, frappe, macchiato, mocha

            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold

            styles = {
                comments = {"italic"},
                conditionals = {"italic"},
            },

            integrations = {
                cmp = true, -- nvim-cmp integration
                treesitter = true, -- Treesitter integration
                lsp_trouble = true, -- LSP Trouble (if you're using it)
                telescope = true, -- Telescope integration
                neotree = true, -- Enable integration with Neo-tree
                gitsigns = true, -- Gitsigns integration
                dap = true, -- nvim-dap integration
                indent_blankline = true, -- Indent-blankline integration
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
            },
        })
        -- Set the colorscheme
        vim.cmd.colorscheme("catppuccin")
    end,
}
