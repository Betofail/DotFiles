require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<Tab>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4,
    },
  },
  filetypes = {
    yaml = false,
    markdown = true,
    help = false,
    gitcommit = true,
    gitrebase = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version
  server_opts_overrides = {},
})

-- Keybindings
vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = "Copilot: Abrir panel" })
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = "Copilot: Habilitar" })
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = "Copilot: Deshabilitar" })
