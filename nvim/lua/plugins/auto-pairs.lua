return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")

        npairs.setup({
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            enable_check_bracket_line = true, -- Don't add pairs if it already has a close pair in the same line
            check_ts = true,         -- Use treesitter if available
            ts_config = {
                lua = { "string" },
                javascript = { "template_string" },
                python = { "string", "f_string" }, -- Disable in both regular and f-strings
                ruby = { "string_content" }, -- Ruby's string node name
                rust = { "string_literal" }, -- Rust's string node name
                typescript = { "template_string" }, -- Same as JavaScript
                latex = { "math_environment" }, -- Disable in math environments
            },
            fast_wrap = {
                map = "<M-e>", -- Alt+e like original auto-pairs
                chars = { "{", "[", "(", '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment",
            },
            -- Disable autopairs for specific syntax nodes
            disable_in_visualblock = false,
            disable_in_macro = false,
            disable_in_replace_mode = true,
            ignored_next_char = [=[[%w%%%'%[%"%.]]=],

            enable_moveright = true,
            enable_afterquote = true, -- add bracket pairs after quote
            -- Use treesitter to check for matching pairs
            enable_bracket_in_quote = true,
            -- Map <CR> to check for pairs
            map_cr = true,
        })

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done({
                map_char = {
                    tex = "",
                },
            })
        )

        -- Add tex-specific rules with treesitter awareness
        npairs.add_rules({
            Rule("$", "$", "tex"):with_pair(function(opts)
                -- Use treesitter to check if we're in a math environment
                local node = ts_utils.get_node_at_cursor()
                if node and node:type() == "math_environment" then
                    return true
                end
                return false
            end),
        })
    end,
}
