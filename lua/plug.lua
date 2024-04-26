return require('packer').startup(
  function(use)
      use 'wbthomason/packer.nvim'
      use 'neovim/nvim-lspconfig'
      use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
      }
      use {
	'nvim-lualine/lualine.nvim',
	requires = { 'nvim-tree/nvim-web-devicons', opt = true }
      }
      use 'jiangmiao/auto-pairs'
      use 'scrooloose/nerdcommenter'
      use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.6',
	  requires = { {'nvim-lua/plenary.nvim'} }
      }
      use 'MunifTanjim/nui.nvim'
      use {
	"folke/todo-comments.nvim",      
	  requires = {{ "nvim-lua/plenary.nvim" }},
      }
      use {
	  "folke/which-key.nvim",
	  config = function()
	    vim.o.timeout = true
	    vim.o.timeoutlen = 300
	    require("which-key").setup {
	      -- your configuration comes here
	      -- or leave it empty to use the default settings
	      -- refer to the configuration section below
	    }
	  end
	}
	use 'rcarriga/nvim-notify'
	use { "ellisonleao/gruvbox.nvim" }
	use {
	  "nvim-neo-tree/neo-tree.nvim",
	    branch = "v3.x",
	    requires = { 
	      "nvim-lua/plenary.nvim",
	      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	      "MunifTanjim/nui.nvim",
	      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	    }
	  }
	use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
    use 'akinsho/toggleterm.nvim'
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugink
    use {
	  "startup-nvim/startup.nvim",
	  requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
	  config = function()
	    require"startup".setup()
	  end
	}
	use 'mfussenegger/nvim-dap'
	use 'mfussenegger/nvim-dap-python'
	use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
	use 'folke/neodev.nvim'
	use({
	  "epwalsh/obsidian.nvim",
	  tag = "*",  -- recommended, use latest release instead of latest commit
	  requires = {
	    -- Required.
	    "nvim-lua/plenary.nvim",

	    -- see below for full list of optional dependencies 👇
	  },
	  config = function()
	    require("obsidian").setup({
	      workspaces = {
		{
		  name = "personal",
		  path = "~/vaults/personal",
		},
	      },
	    })
	  end,
	})

  end
)
