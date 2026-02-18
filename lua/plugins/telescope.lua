return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
        { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
        { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
        { "<leader>fm", function() require("telescope.builtin").harpoon_marks() end, desc = "Harpoon Marks" },
        { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Find Git Files" },
        { "<leader>pws", function()
            local word = vim.fn.expand("<cword>")
            require("telescope.builtin").grep_string({ search = word })
        end, desc = "Grep Word" },
        { "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            require("telescope.builtin").grep_string({ search = word })
        end, desc = "Grep WORD" },
        { "<leader>ps", function()
            require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end, desc = "Grep String" },
        { "<leader>vh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
        { "<leader>ds", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols" },
        { "<leader>ws", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "node_modules", ".git/", "%.lock" },
                mappings = {
                    i = {
                        ["<C-j>"] = require("telescope.actions").move_selection_next,
                        ["<C-k>"] = require("telescope.actions").move_selection_previous,
                    },
                },
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        preview_width = 0.55,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
        })

        -- Load fzf extension for better performance
        pcall(require("telescope").load_extension, "fzf")
    end
}
