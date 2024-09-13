-- Set leader key
vim.g.mapleader = ' '

-- Key mappings telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope harpoon marks<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>q', ':Neotree float<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bb', ':BufferLinePick<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>bc', ':bd<CR>', {noremap=true, silent=true})


-- Keymaps for harpoon
vim.api.nvim_set_keymap('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>hm', ':lua require("harpoon.mark").add_file()<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<CR>', {noremap=true, silent=true})


-- Keymaps for debugging
vim.api.nvim_set_keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true } )
