-- ~/.config/nvim/lua/plugins/lsp/mason.lua
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- Habilitar la interfaz de Mason
    mason.setup()

    -- Lista de servidores de lenguaje que quieres tener instalados por defecto.
    -- Mason se asegurará de que siempre estén presentes.
    -- Ejemplos: "lua_ls", "tsserver", "gopls", "rust_analyzer", "pyright"
    local ensure_installed = {
      "lua_ls",
      "tsserver", -- Para TypeScript/JavaScript
      "gopls", -- Para Go
      "bashls", -- Para Shell scripts
    }

    mason_lspconfig.setup({
      ensure_installed = ensure_installed,
      -- Instalar LSPs automáticamente
      automatic_installation = true,
    })
  end,
}