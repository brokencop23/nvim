require("set")
require("remap")
require("lazy_init")

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local dir = vim.fn.expand("<afile>:p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

vim.g.python3_host_prog = vim.fn.expand("~/.venvs/neovim/bin/python")
