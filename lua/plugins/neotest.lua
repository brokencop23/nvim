return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "marilari88/neotest-vitest",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-plenary",
            "rouge8/neotest-rust",
        },
        config = function()
            local neotest = require("neotest")
            neotest.setup({
                adapters = {
                    require("neotest-vitest"),
                    require("neotest-python")({
                        args = {"--log-level", "DEBUG"},
                        runner = "pytest",
                        python = ".venv/bin/python",
                    }),
                    require("neotest-rust"),
                    require("neotest-go"),
                    require("neotest-plenary"),
                }
            })

            vim.keymap.set("n", "<leader>tt", function()
                require("neotest").summary.refresh()
            end, { desc = "Debug: Refresh summary" })

            vim.keymap.set("n", "<leader>tr", function()
                require("neotest").run.run({
                    suite = false,
                    testify = true,
                })
            end, { desc = "Debug: Running Nearest Test" })

            vim.keymap.set("n", "<leader>tv", function()
                require("neotest").summary.toggle()
            end, { desc = "Debug: Summary Toggle" })

            vim.keymap.set("n", "<leader>ts", function()
                require("neotest").run.run({
                    suite = true,
                    testify = true,
                })
            end, { desc = "Debug: Running Test Suite" })

            vim.keymap.set("n", "<leader>td", function()
                require("dap-python")
                require("neotest").run.run({
                    suite = false,
                    --testify = true,
                    strategy = "dap",
                })
            end, { desc = "Debug: Debug Nearest Test" })

            vim.keymap.set("n", "<leader>to", function()
                require("neotest").output.open()
            end, { desc = "Debug: Open test output" })

            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").run.run(vim.fn.getcwd())
            end, { desc = "Debug: Open test output" })

        end,
    },
}
