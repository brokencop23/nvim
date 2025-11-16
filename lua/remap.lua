-- Set leader key
vim.g.mapleader = ' '

local keymap = vim.keymap

-- Save and quit
keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true, desc = 'Save file' })
keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = 'Save file' })
keymap.set('n', '<leader>qq', ':qa<CR>', { noremap = true, silent = true, desc = 'Quit all' })

-- Better window navigation
keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left window' })
keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to bottom window' })
keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to top window' })
keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right window' })

-- Resize windows
keymap.set('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true, desc = 'Increase window height' })
keymap.set('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true, desc = 'Decrease window height' })
keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = 'Decrease window width' })
keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = 'Increase window width' })

-- Navigate buffers
keymap.set('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
keymap.set('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
keymap.set('n', '<leader>bd', ':bdelete<CR>', { noremap = true, silent = true, desc = 'Delete buffer' })

-- Better indenting
keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'Indent left' })
keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indent right' })

-- Move text up and down
keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move text down' })
keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move text up' })

-- Clear search highlighting
keymap.set('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true, desc = 'Clear search highlighting' })

-- Better paste (doesn't replace clipboard)
keymap.set('x', '<leader>p', '"_dP', { noremap = true, silent = true, desc = 'Paste without yanking' })

-- System clipboard
keymap.set({'n', 'v'}, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to system clipboard' })
keymap.set('n', '<leader>Y', '"+Y', { noremap = true, silent = true, desc = 'Yank line to system clipboard' })

-- Keep cursor centered when scrolling
keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true, desc = 'Scroll down half page' })
keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true, desc = 'Scroll up half page' })

-- Keep search results centered
keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true, desc = 'Next search result' })
keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true, desc = 'Previous search result' })

-- Keymaps for harpoon
keymap.set('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {noremap=true, silent=true, desc = 'Harpoon menu'})
keymap.set('n', '<leader>hm', ':lua require("harpoon.mark").add_file()<CR>', {noremap=true, silent=true, desc = 'Mark file'})
keymap.set('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<CR>', {noremap=true, silent=true, desc = 'Next mark'})
keymap.set('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<CR>', {noremap=true, silent=true, desc = 'Previous mark'})
