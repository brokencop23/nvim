return {
    --"rebelot/kanagawa.nvim",
    -- "rose-pine/neovim",
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            term_color = false,
            transparent_background = false
        })
    end
}
