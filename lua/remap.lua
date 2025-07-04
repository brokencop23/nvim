-- Set leader key
vim.g.mapleader = ' '

local keymap = vim.keymap

-- Key mappings telescope
keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fh', ':Telescope harpoon marks<CR>', { noremap = true, silent = true })

keymap.set('n', '<leader>q', ':Neotree float<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>bb', ':BufferLinePick<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>bc', ':bd<CR>', {noremap=true, silent=true})


-- Keymaps for harpoon
keymap.set('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>hm', ':lua require("harpoon.mark").add_file()<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<CR>', {noremap=true, silent=true})


-- Keymaps for debugging
keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<CR>", { noremap = true, silent = true })
keymap.set('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true } )
keymap.set('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true } )
keymap.set('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true } )
