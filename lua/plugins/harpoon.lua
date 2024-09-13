return {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require("harpoon").setup({ })

        require("telescope").load_extension("harpoon")
    end 
}
