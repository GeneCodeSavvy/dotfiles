return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    config = function()
        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_prev()
        end, { desc = "Previous todo comment" })

        -- You can also specify a list of valid jump keywords

        -- vim.keymap.set("n", "]t", function()
        --     require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
        -- end, { desc = "Next error/warning todo comment" })
    end,
}
