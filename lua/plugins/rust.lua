return {
    {
        "mrcjkb/rustaceanvim",
        version = "^9",
        lazy = false, -- plugin self-lazies on ft = rust
        ft = { "rust" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            local codelldb_root = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
            local codelldb_path = codelldb_root .. "/extension/adapter/codelldb"
            local liblldb_path  = codelldb_root .. "/extension/lldb/lib/liblldb.dylib"
            local codelldb_ok   = vim.fn.executable(codelldb_path) == 1

            vim.g.rustaceanvim = {
                tools = {
                    float_win_config = { border = "rounded" },
                },
                server = {
                    capabilities = capabilities,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            check = { command = "clippy" },
                            inlayHints = {
                                lifetimeElisionHints = { enable = true, useParameterNames = true },
                            },
                            procMacro = { enable = true },
                        },
                    },
                    on_attach = function(_, bufnr)
                        local function map(keys, cmd, desc)
                            vim.keymap.set("n", keys, cmd, { buffer = bufnr, silent = true, desc = desc })
                        end
                        map("<leader>Ra", function() vim.cmd.RustLsp("codeAction") end, "Rust: Code action")
                        map("<leader>Re", function() vim.cmd.RustLsp("explainError") end, "Rust: Explain error")
                        map("<leader>Rm", function() vim.cmd.RustLsp("expandMacro") end, "Rust: Expand macro")
                        map("<leader>Rp", function() vim.cmd.RustLsp("parentModule") end, "Rust: Parent module")
                        map("<leader>Rc", function() vim.cmd.RustLsp("openCargo") end, "Rust: Open Cargo.toml")
                        map("<leader>Rd", function() vim.cmd.RustLsp("openDocs") end, "Rust: Open docs.rs")
                        map("<leader>Rr", function() vim.cmd.RustLsp("runnables") end, "Rust: Runnables")
                        map("<leader>RD", function() vim.cmd.RustLsp("debuggables") end, "Rust: Debuggables")
                        map("<leader>Rh", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Rust: Hover actions")
                        map("<leader>RH", function() vim.cmd.RustLsp("viewHir") end, "Rust: View HIR")
                        map("<leader>RM", function() vim.cmd.RustLsp("viewMir") end, "Rust: View MIR")
                        map("<leader>Rj", function() vim.cmd.RustLsp("joinLines") end, "Rust: Join lines")
                    end,
                },
                dap = codelldb_ok and {
                    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
                } or nil,
            }
        end,
    },
}
