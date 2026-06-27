return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })

            vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle("diagnostics") end, { desc = "Diagnostics (Trouble)" })
            vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("diagnostics") end, { desc = "Workspace diagnostics" })
            vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end, { desc = "Document diagnostics" })
            vim.keymap.set("n", "<leader>xs", function() require("trouble").toggle("symbols") end, { desc = "Document symbols" })
            vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end, { desc = "Location list" })
            vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("qflist") end, { desc = "Quickfix list" })

        end
    },
}
