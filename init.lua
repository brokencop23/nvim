require('vars')
require('opts')
require('keys')
require('plug')

lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}

vim.wo.number = true

-- Set the tab size
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.wo.number = true -- Shows the line number
vim.wo.relativenumber = true -- Shows the relative line numbers

-- Set auto indentation
vim.bo.autoindent = true
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
vim.keymap.set('n', '<leader>q', '<Cmd>Neotree float<CR>')
vim.keymap.set('n', '<leader>w', '<Cmd>w<CR>')
vim.api.nvim_set_keymap('n', '<Space>bc', ':bd<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<Space>tf', ':ToggleTerm direction=float<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>bb', ':BufferLinePick<CR>', {noremap=true, silent=true})
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })



vim.opt.termguicolors = true
require("bufferline").setup{}

require('todo-comments').setup {}
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


local luasnip = require('luasnip')
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

require("startup").setup({theme = "evil"})
require('dap-python').setup('~/.venvs/debugpy/bin/python')
require("obsidian").setup({
	workspaces = {
		{ name="personal", path="~/vaults/personal" }
	}
})

local dap = require("dap")
local dap = require('dap')

-- Start or continue debugging
vim.api.nvim_set_keymap('n', '<Leader>dc', '<Cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })

-- Step over an instruction
vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })

-- Step into an instruction
vim.api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })

-- Step out of an instruction
vim.api.nvim_set_keymap('n', '<F12>', '<Cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })

-- Toggle breakpoint
vim.api.nvim_set_keymap('n', '<F9>', '<Cmd>lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })

-- Set a conditional breakpoint
vim.api.nvim_set_keymap('n', '<F8>', '<Cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { noremap = true, silent = true })

-- View variables
vim.api.nvim_set_keymap('n', '<Leader>v', '<Cmd>lua require"dap.ui.widgets".sidebar(require"dap.ui.widgets".scopes).open()<CR>', { noremap = true, silent = true })

-- Evaluate expression
vim.api.nvim_set_keymap('n', '<Leader>e', '<Cmd>lua require"dap.ui.widgets".hover()<CR>', { noremap = true, silent = true })

-- Repl
vim.api.nvim_set_keymap('n', '<Leader>r', '<Cmd>lua require"dap".repl.open()<CR>', { noremap = true, silent = true })

