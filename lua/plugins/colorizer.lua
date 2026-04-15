return {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
        filetypes = { "css", "scss", "html", "javascript", "typescript", "lua", "templ" },
        user_default_options = {
            RGB = true,
            RRGGBB = true,
            names = false,
            RRGGBBAA = true,
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
            mode = "background",
            tailwind = true,
        },
    },
}
