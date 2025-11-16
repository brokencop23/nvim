return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup({
            preset = "modern",
            delay = 500,
        })

        -- Register key groups
        wk.add({
            { "<leader>f", group = "Find (Telescope)" },
            { "<leader>g", group = "Git" },
            { "<leader>d", group = "Debug" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>x", group = "Trouble" },
            { "<leader>u", group = "UI Toggles" },
            { "<leader>c", group = "Code" },
            { "<leader>p", group = "Project" },
            { "<leader>b", group = "Buffer" },
            { "<leader>q", group = "Quit" },
        })
    end,
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps",
        },
    },
}
