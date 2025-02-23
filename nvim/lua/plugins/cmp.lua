return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    "hrsh7th/nvim-cmp",
    config = function()
        local cmp = require("cmp")
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
                { name = "buffer" },
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-m>"] = cmp.mapping.complete(), -- Trigger the completion menu
                ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
                ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
                ["<C-e>"] = cmp.mapping.abort(), -- Abort completion
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = false }) -- Confirm the current selection
                    else
                        fallback()    -- Insert a newline if no completion is active
                    end
                end, { "i", "c" }),   -- Insert and command modes

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item() -- Move to the next suggestion
                    else
                        fallback() -- Fall back to default Tab behavior
                    end
                end, { "i", "s" }), -- Insert and snippet modes

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item() -- Move to the previous suggestion
                    else
                        fallback() -- Fall back to default Shift+Tab behavior
                    end
                end, { "i", "s" }), -- Insert and snippet modes

                ["<C-o>"] = cmp.mapping(function(fallback)
                    local entry = cmp.get_selected_entry() -- Get the selected item
                    if entry and cmp.visible() then
                        cmp.mapping.scroll_docs(0)(fallback) -- Show docs for the selected entry
                    else
                        fallback()          -- Use default behavior if no entry is selected
                    end
                end, { "i", "c" }),         -- Insert and command modes
            }),
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
        })
    end,
}
