-- ~/.config/nvim/lua/plugins/theme.lua
return {
  "folke/tokyonight.nvim",
  lazy = false, -- Cargar al inicio
  priority = 1000,
  config = function()
    -- Cargar el tema
    vim.cmd.colorscheme("tokyonight-storm")
  end,
}