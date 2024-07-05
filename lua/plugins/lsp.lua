return {
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"RRethy/vim-illuminate",
            "hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",   -- Optional for snippet completions
            "L3MON4D3/LuaSnip",
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
            
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ['<C-e>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require('luasnip').expand_or_jumpable() then
                            require('luasnip').expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require('luasnip').jumpable(-1) then
                            require('luasnip').jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                })
            })

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

            lspconfig.clangd.setup{
                on_attach = on_attach,
                capabilities = capabilities,
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
