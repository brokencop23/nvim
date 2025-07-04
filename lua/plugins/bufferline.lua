return {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy=false,
    config = function()
        require("bufferline").setup()
    end
}

