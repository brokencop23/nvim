return {
    --"rebelot/kanagawa.nvim",
    "rose-pine/neovim",
    config = function()
        require("rose-pine").setup({
            variant = "moon", -- main, moon, dawn
        })
    end
}
