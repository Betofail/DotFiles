-- ~/.config/nvim/lua/plugins/formatter.lua
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- Se ejecuta antes de guardar un archivo
  cmd = { "ConformInfo" },
  opts = {
    -- Define qué formateador usar para cada tipo de archivo
    formatters_by_ft = {
      java = { "jdtls" }, -- jdtls también puede formatear
      lua = { "stylua" },
      html = { "prettierd" },
      yaml = { "prettierd" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      python = { "isort", "black" }, -- Se ejecutan en orden
    },

    -- Opción para formatear al guardar
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true, -- Si no hay formateador, intenta usar el LSP
    },
  },
}
