return {
    { "hrsh7th/cmp-nvim-lsp" },
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "black",
                "stylelua",
                "prettierd",
                "lua_ls",
                'eslint-lsp',
                "pyright",
                "tailwindcss-language-server",
                "typescript-language-server",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = function()
            local lsp_defaults = require("lspconfig").util.default_config

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            lsp_defaults.capabilities =
                vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    -- All keymaps now use direct Lua function calls
                    vim.keymap.set("n", "<leader>K", function()
                        vim.lsp.buf.hover()
                    end, opts)

                    vim.keymap.set("n", "<leader>gd", function()
                        vim.lsp.buf.definition()
                    end, opts)

                    vim.keymap.set("n", "<leader>gD", function()
                        vim.lsp.buf.declaration()
                    end, opts)

                    vim.keymap.set("n", "<leader>gi", function()
                        vim.lsp.buf.implementation()
                    end, opts)

                    vim.keymap.set("n", "<leader>go", function()
                        vim.lsp.buf.type_definition()
                    end, opts)

                    vim.keymap.set("n", "<leader>gr", function()
                        vim.lsp.buf.references()
                    end, opts)

                    vim.keymap.set("n", "<leader>gs", function()
                        vim.lsp.buf.signature_help()
                    end, opts)

                    vim.keymap.set("n", "<leader>rn", function()
                        vim.lsp.buf.rename()
                    end, opts)

                    vim.keymap.set("n", "<leader>gf", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)

                    vim.keymap.set("n", "<leader>ca", function()
                        vim.lsp.buf.code_action()
                    end, opts)
                end,
            })
            require'lspconfig'.pyright.setup{}

        --     require("mason-lspconfig").setup({
        --         ensure_installed = {
        --             "lua_ls",
        --             "pyright",
        --             "typescript-language-server",
        --             "tailwindcss-language-server",
        --             "eslint-lsp",
        --             "black",
        --             "stylelua",
        --             "prettierd",
        --         },
        --         handlers = {
        --             -- this first function is the "default handler"
        --             -- it applies to every language server without a "custom handler"
        --             function(server_name)
        --                 require("lspconfig")[server_name].setup({})
        --             end,
        --         },
        --     })
        end,
    },
}
