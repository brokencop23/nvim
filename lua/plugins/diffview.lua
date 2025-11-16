return {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>gv", ":DiffviewOpen<CR>",          desc = "Open Diffview" },
        { "<leader>gc", ":DiffviewClose<CR>",         desc = "Close Diffview" },
        { "<leader>gh", ":DiffviewFileHistory %<CR>", desc = "File History" },
    },
}
