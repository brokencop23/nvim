return {
    -- core git UX
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim", opts = { current_line_blame = true } },
    { "sindrets/diffview.nvim" }, -- beautiful, multi-file diffs
    -- optional: git TUI inside nvim (super handy)
    { "kdheepak/lazygit.nvim" },
}
