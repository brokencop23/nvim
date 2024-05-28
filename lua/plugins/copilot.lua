return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                  accept = "<C-j>",
                  accept_word = false,
                  accept_line = false,
                  next = "<M-Right>",
                  prev = "<M-Left>",
                  dismiss = "<M-x>",
                },
          },
        })
    end
}
