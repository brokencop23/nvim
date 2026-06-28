return {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local crates = require("crates")
        crates.setup({
            completion = {
                cmp = { enabled = true },
                crates = { enabled = true }, -- search crates.io
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        })

        vim.api.nvim_create_autocmd("BufRead", {
            pattern = "Cargo.toml",
            callback = function(ev)
                local function map(keys, fn, desc)
                    vim.keymap.set("n", keys, fn, { buffer = ev.buf, silent = true, desc = desc })
                end
                map("<leader>Ct", crates.toggle,         "Crates: Toggle")
                map("<leader>Cr", crates.reload,         "Crates: Reload")
                map("<leader>Cv", crates.show_versions_popup, "Crates: Show versions")
                map("<leader>Cf", crates.show_features_popup, "Crates: Show features")
                map("<leader>Cd", crates.show_dependencies_popup, "Crates: Show dependencies")
                map("<leader>Cu", crates.update_crate,   "Crates: Update crate")
                map("<leader>Ca", crates.update_all_crates, "Crates: Update all")
                map("<leader>CU", crates.upgrade_crate,  "Crates: Upgrade crate")
                map("<leader>CA", crates.upgrade_all_crates, "Crates: Upgrade all")
                map("<leader>CH", crates.open_homepage,  "Crates: Open homepage")
                map("<leader>CR", crates.open_repository,"Crates: Open repository")
                map("<leader>CD", crates.open_documentation, "Crates: Open docs.rs")
            end,
        })
    end,
}
