return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim"
    },
    keys = {
        { "<leader>q", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer (NeoTree)" },
    },
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
            width = 30,
            mappings = {
                ["<space>"] = "none",
            },
        },
        filesystem = {
            follow_current_file = {
                enabled = true,
            },
            hijack_netrw_behavior = "open_current",
            use_libuv_file_watcher = true,
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
            },
        },
    }
}
