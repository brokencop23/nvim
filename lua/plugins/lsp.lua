local root_files = {
    '.luarc.json', '.luarc.jsonc', '.luacheckrc',
    '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git',
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "j-hui/fidget.nvim",
        -- recommended / optional:
        "folke/trouble.nvim", -- you mapped keys to it
        -- "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua    = { "stylua" },
                python = { "ruff_format" }, -- fast; pair with ruff_lsp for linting
                rust   = { "rustfmt" },
                go     = { "gofmt", "goimports" },
                json   = { "jq" },
                yaml   = { "yamlfmt" },
            },
            format_on_save = function(bufnr)
                -- Disable for very large files
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                if ok and stats and stats.size > 512 * 1024 then return nil end
                return { timeout_ms = 800, lsp_fallback = true }
            end,
        })

        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities(),
            { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
        )

        require("fidget").setup({})
        require("mason").setup()

        -- ── Uniform rounded borders for LSP floats ────────────────────────────────
        local _border = "rounded"
        require("lspconfig.ui.windows").default_options.border = _border
        vim.lsp.handlers["textDocument/hover"] =
            vim.lsp.with(vim.lsp.handlers.hover, { border = _border })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = _border })

        -- ── Diagnostics look & feel ───────────────────────────────────────────────
        vim.diagnostic.config({
            virtual_text = { spacing = 2, prefix = "●" },
            float = { border = _border, source = "always" },
            severity_sort = true,
        })

        -- ── Mason LSP setup with per-server opts ──────────────────────────────────
        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "ruff",
                "basedpyright", -- type checker to complement Ruff
                "gopls",
            },
            handlers = {
                -- default
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor,
                    })
                end,

                -- lua
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        root_dir = util.root_pattern(unpack(root_files)),
                        settings = {
                            Lua = {
                                completion = { callSnippet = "Replace" },
                                diagnostics = { globals = { "vim" } },
                                format = { enable = false }, -- Conform handles formatting
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME,
                                        "${3rd}/luv/library",
                                        "${3rd}/busted/library",
                                    },
                                },
                                telemetry = { enable = false },
                            },
                        },
                    })
                end,

                -- python (ruff + basedpyright)
                ["ruff"] = function()
                    lspconfig.ruff.setup({
                        capabilities = capabilities,
                        init_options = {
                            settings = {
                                -- Add any specific ruff settings here
                            }
                        }
                    })
                end,
                ["basedpyright"] = function()
                    lspconfig.basedpyright.setup({
                        capabilities = capabilities,
                        root_dir = util.root_pattern('pyproject.toml', '.git'),
                        settings = {
                            basedpyright = {
                                analysis = {
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = 'basic',
                                    diagnosticMode = 'workspace',
                                    autoSearchPath = true,
                                    inlayHints = {
                                        callArgumentNames = true,
                                    },
                                    extraPaths = {
                                        '...',
                                        '...',
                                    },
                                },
                                plugins = {
                                    { name = "pyright-pandas" }
                                },
                                diagnosticSeverityOverrides = {
                                    reportUnknownMemberType = "information",
                                    reportUnknownVariableType = "none",
                                    reportUnknownArgumentType = "none",
                                    reportMissingTypeStubs = "none",
                                    reportPrivateImportUsage = "none"
                                }
                            },
                        },
                    })
                end,

                -- go
                ["gopls"] = function()
                    lspconfig.gopls.setup({
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                usePlaceholders = true,
                                analyses = { unusedparams = true, nilness = true, shadow = true },
                            },
                        },
                    })
                end,

                -- rust
                ["rust_analyzer"] = function()
                    lspconfig.rust_analyzer.setup({
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                cargo = { allFeatures = true },
                                check = { command = "clippy" },
                                inlayHints = { lifetimeElisionHints = { enable = true, useParameterNames = true } },
                            },
                        },
                    })
                end,
            },
        })

        -- ── Inlay hints auto-enable & toggle ──────────────────────────────────────
        local ih_enabled = true
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.server_capabilities.inlayHintProvider then
                    pcall(vim.lsp.inlay_hint, args.buf, ih_enabled)
                end
            end,
        })
        vim.keymap.set("n", "<leader>uh", function()
            ih_enabled = not ih_enabled
            local buf = vim.api.nvim_get_current_buf()
            pcall(vim.lsp.inlay_hint, buf, ih_enabled)
        end, { desc = "Toggle inlay hints" })

        -- ── LSP keymaps (plus a few extras) ───────────────────────────────────────
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                local opts = { buffer = event.buf, silent = true, noremap = true, desc = "" }

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                -- If Trouble installed:
                vim.keymap.set("n", "gr", require("trouble").toggle, opts)
                vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, opts)
                -- Otherwise, use:
                -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", function() require("conform").format({ async = false }) end,
                    { buffer = event.buf, desc = "Format buffer" })
            end
        })
    end,
}
