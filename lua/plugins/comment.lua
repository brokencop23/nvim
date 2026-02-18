return {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end,
    keys = {
        { "gcc", mode = "n", function() require("Comment.api").toggle.linewise.current() end, desc = "Toggle Comment" },
        { "gc", mode = "v", function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, desc = "Toggle Comment" },
    }
}