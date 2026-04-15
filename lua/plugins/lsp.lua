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
                json   = { "jq" },
                yaml   = { "yamlfmt" },
            },
            format_on_save = function(bufnr)
                -- Disable for very large files
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
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

        -- Work around Neovim 0.12 treesitter markdown conceal crash in float windows.
        -- The built-in markdown ftplugin calls vim.treesitter.start() directly,
        -- bypassing nvim-treesitter's highlight.disable. The conceal_line decoration
        -- provider then crashes on nil injection nodes. Autocmds cannot win this race
        -- because the decoration provider fires on the very first redraw.
        -- Fix: intercept vim.treesitter.start itself so it never activates on
        -- scratch markdown buffers (LSP hover/signature floats).
        local _orig_ts_start = vim.treesitter.start
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.treesitter.start = function(bufnr, lang, ...)
            bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
            if vim.bo[bufnr].buftype == "nofile" then
                local ft = lang or vim.bo[bufnr].filetype
                if ft == "markdown" or ft == "markdown_inline" then
                    return
                end
            end
            return _orig_ts_start(bufnr, lang, ...)
        end

        -- ── Diagnostics look & feel ───────────────────────────────────────────────
        vim.diagnostic.config({
            virtual_text = { spacing = 2, prefix = "●" },
            float = { border = _border, source = true },
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
                "pyright", -- type checker to complement Ruff
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
                ["pyright"] = function()
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        root_dir = util.root_pattern('pyproject.toml', '.git'),
                        settings = {
                            python = {
                                analysis = {
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = 'basic',
                                    diagnosticMode = 'workspace',
                                    autoSearchPaths = true,
                                    inlayHints = {
                                        callArgumentNames = true,
                                    },
                                    diagnosticSeverityOverrides = {
                                        reportUnknownMemberType = "information",
                                        reportUnknownVariableType = "none",
                                        reportUnknownArgumentType = "none",
                                        reportMissingTypeStubs = "none",
                                        reportPrivateImportUsage = "none",
                                    },
                                },
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
                    pcall(vim.lsp.inlay_hint.enable, ih_enabled, { bufnr = args.buf })
                end
            end,
        })
        vim.keymap.set("n", "<leader>uh", function()
            ih_enabled = not ih_enabled
            local buf = vim.api.nvim_get_current_buf()
            pcall(vim.lsp.inlay_hint.enable, ih_enabled, { bufnr = buf })
        end, { desc = "Toggle inlay hints" })

        -- ── LSP keymaps (plus a few extras) ───────────────────────────────────────
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                local function map(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, silent = true, noremap = true, desc = desc })
                end

                map("gd", vim.lsp.buf.definition, "Go to definition")
                map("gr", function() require("trouble").toggle("lsp_references") end, "References (Trouble)")
                map("gR", vim.lsp.buf.references, "References (quickfix)")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gi", vim.lsp.buf.implementation, "Go to implementation")
                map("<leader>h", function() vim.lsp.buf.hover({ border = _border }) end, "Hover documentation")
                map("<leader>H", function()
                    local params = vim.lsp.util.make_position_params()
                    vim.lsp.buf_request(event.buf, "textDocument/hover", params, function(err, result)
                        if err or not result or not result.contents then return end
                        local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                        if vim.tbl_isempty(lines) then return end
                        local buf = vim.api.nvim_create_buf(false, true)
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                        vim.bo[buf].modifiable = false
                        vim.bo[buf].filetype = "markdown"
                        vim.cmd("vsplit")
                        vim.api.nvim_win_set_buf(0, buf)
                        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
                    end)
                end, "Hover documentation (split)")
                map("<leader>ce", vim.diagnostic.open_float, "Line diagnostics")
                map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                map("<leader>cf", function() require("conform").format({ async = false }) end, "Format buffer")
            end
        })
    end,
}
