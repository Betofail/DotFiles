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
  -- Uso de win en lugar de window (obsoleto)
  win = {
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

-- Registrar grupos de teclas con el nuevo formato recomendado
wk.register({
  { "<leader>f", group = "Archivo/Buscar" },
  { "<leader>g", group = "Git" },
  { "<leader>h", group = "Harpoon" },
  { "<leader>l", group = "LSP" },
  { "<leader>t", group = "Terminal/Pestañas" },
  { "<leader>y", group = "Yazi" },
})
