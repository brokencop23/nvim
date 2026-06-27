return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "marilari88/neotest-vitest",
            "nvim-neotest/neotest-python",
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
                    require("neotest-plenary"),
                }
            })

            vim.keymap.set("n", "<leader>tt", function()
                require("neotest").run.run()
            end, { desc = "Test: Run nearest" })

            vim.keymap.set("n", "<leader>tr", function()
                require("neotest").run.run_last()
            end, { desc = "Test: Run last" })

            vim.keymap.set("n", "<leader>tn", function()
                require("neotest").summary.refresh()
            end, { desc = "Test: Refresh summary" })

            vim.keymap.set("n", "<leader>tv", function()
                require("neotest").summary.toggle()
            end, { desc = "Test: Toggle summary" })

            vim.keymap.set("n", "<leader>ts", function()
                require("neotest").run.run({ suite = true })
            end, { desc = "Test: Run suite" })

            vim.keymap.set("n", "<leader>td", function()
                require("dap-python")
                require("neotest").run.run({ strategy = "dap" })
            end, { desc = "Test: Debug nearest" })

            vim.keymap.set("n", "<leader>to", function()
                require("neotest").output.open()
            end, { desc = "Test: Open output" })

            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").run.run(vim.fn.getcwd())
            end, { desc = "Test: Run all in cwd" })

        end,
    },
}
