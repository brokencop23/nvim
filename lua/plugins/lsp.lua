return {
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"RRethy/vim-illuminate",
            "hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Set up Mason before anything else
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
                    "ruff_lsp",
                    "pyright"
				},
				automatic_installation = true,
			})

			-- Neodev setup before LSP config
			require("neodev").setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Setup lspconfig for ruff_lsp
            local lspconfig = require("lspconfig")

            local on_attach = function(client, bufnr)
                if client.name == 'ruff_lsp' then
                    client.server_capabilities.hoverProvider = true
                end
                if client.name == 'pyright' then
                    -- Mappings.
                    local opts = { noremap=true, silent=true }
                    local buf_map = vim.api.nvim_buf_set_keymap
                    
                    -- Keybindings for Pyright
                    buf_map(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                    buf_map(bufnr, 'n', '<leader>sd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
                end
            end

            -- Pyright setup
            lspconfig.pyright.setup{
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        }
                    }
                }
            }

            -- Ruff LSP setup
            lspconfig.ruff_lsp.setup{
              on_attach = on_attach,
              capabilities = capabilities,
              init_options = {
                settings = {
                  args = {
                      "--line-length=80",
                      "--fix-only",
                      "--preview",
                      "--force-exclude",
                      "--select=E,W,F"
                  },
                  python = {
                      analysis = {
                          autoSearchPaths = true,
                          useLibraryCodeForTypes = true,
                      }
                  }
                },
              },
            }

		end
}
