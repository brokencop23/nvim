return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "vimdoc", "query",
                "lua", "rust", "bash", "python",
                "dockerfile", "json", "yaml",
                "markdown", "markdown_inline",
                "templ", -- custom below
            },
            sync_install = false,
            auto_install = false,

            highlight = {
                enable = true,
                -- Prefer native markdown parsers over regex fallback:
                additional_vim_regex_highlighting = { "markdown" },
                disable = function(lang, buf)
                    -- Example: keep html enabled unless you really need it off
                    -- if lang == "html" then return true end
                    if lang == "markdown" or lang == "markdown_inline" then
                        return true
                    end
                    local ok_name, name = pcall(vim.api.nvim_buf_get_name, buf)
                    if not ok_name or name == "" then return false end

                    local max = 100 * 1024 -- 100KB
                    local ok, stat = pcall(vim.uv.fs_stat, name)
                    if ok and stat and stat.size > max then
                        if not vim.b[buf].__ts_disabled_notified then
                            vim.b[buf].__ts_disabled_notified = true
                            vim.notify(
                                "Treesitter disabled for performance (>100KB)",
                                vim.log.levels.WARN,
                                { title = "nvim-treesitter" }
                            )
                        end
                        return true
                    end
                    return false
                end,
            },

            indent = { enable = true },

            -- Quality of life:
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<BS>",
                    scope_incremental = "<S-CR>",
                },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aP"] = "@parameter.outer",
                        ["iP"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = { ["<leader>sp"] = "@parameter.inner" },
                    swap_previous = { ["<leader>sP"] = "@parameter.inner" },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            -- Recognize .templ files
            vim.filetype.add({
                extension = { templ = "templ" },
            })
            vim.treesitter.language.register("templ", "templ")
        end,
        dependencies = {
             {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "master",
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            enable = true,
            multiwindow = false,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = "outer",
            mode = "cursor",
            separator = "─",
            zindex = 20,
            on_attach = nil,
        },
        keys = {
            { "<leader>uc", function() require("treesitter-context").toggle() end, desc = "Toggle TS Context" },
        },
    },
}
