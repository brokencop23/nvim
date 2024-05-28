return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "folke/neodev.nvim"
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true }
        })

        require("dap-python").setup('.venv/bin/python')

        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end

    end
}
