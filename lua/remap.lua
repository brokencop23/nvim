-- Set leader key
vim.g.mapleader = ' '

local keymap = vim.keymap

-- Key mappings telescope
keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>fm', ':Telescope harpoon marks<CR>', { noremap = true, silent = true })

keymap.set('n', '<leader>q', ':Neotree filesystem reveal left<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })

--keymap.set('n', '<leader>bb', ':BufferLinePick<CR>', {noremap=true, silent=true})
--keymap.set('n', '<leader>bc', ':bd<CR>', {noremap=true, silent=true})


-- Keymaps for harpoon
keymap.set('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>hm', ':lua require("harpoon.mark").add_file()<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<CR>', {noremap=true, silent=true})
keymap.set('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<CR>', {noremap=true, silent=true})
