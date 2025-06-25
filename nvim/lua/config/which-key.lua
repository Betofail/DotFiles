local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  window = {
    border = "single",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  show_help = true,
  show_keys = true,
})

-- Registrar grupos de teclas
wk.register({
  ["<leader>"] = {
    f = { name = "Archivo/Buscar" },
    g = { name = "Git" },
    h = { name = "Harpoon" },
    l = { name = "LSP" },
    t = { name = "Terminal/Pestañas" },
    y = { name = "Yazi" },
  },
})
