return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = { "AerialToggle", "AerialOpen", "AerialClose" },
    keys = {
        { "<leader>a", ":AerialToggle<CR>", desc = "Aerial (Code Outline)" },
    },
    opts = {
        on_attach = function(bufnr)
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Previous symbol" })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
        end,
        layout = {
            min_width = 30,
        },
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },
    },
}
