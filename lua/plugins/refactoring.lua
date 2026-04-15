return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    keys = {
        { "<leader>re", mode = "x",          function() require("refactoring").refactor("Extract Function") end,         desc = "Extract function" },
        { "<leader>rf", mode = "x",          function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract function to file" },
        { "<leader>rv", mode = "x",          function() require("refactoring").refactor("Extract Variable") end,         desc = "Extract variable" },
        { "<leader>ri", mode = "n",          function() require("refactoring").refactor("Inline Variable") end,          desc = "Inline variable" },
        { "<leader>rI", mode = "n",          function() require("refactoring").refactor("Inline Function") end,          desc = "Inline function" },
        { "<leader>rb", mode = "n",          function() require("refactoring").refactor("Extract Block") end,            desc = "Extract block" },
        { "<leader>rB", mode = "n",          function() require("refactoring").refactor("Extract Block To File") end,    desc = "Extract block to file" },
        { "<leader>rr", mode = { "n", "x" }, function() require("refactoring").select_refactor() end,                    desc = "Select refactor" },
    },
}
