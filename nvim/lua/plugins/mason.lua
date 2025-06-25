-- Archivo: lua/plugins/mason.lua
-- Configuración actualizada de Mason

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- Asegúrate de usar ts_ls en lugar de tsserver
        ensure_installed = {
          "lua_ls",
          "ts_ls",  -- En lugar de tsserver
          "pyright",
          "bashls",
        },
      })
    end
  },
  
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Linters
          "eslint_d",
          "shellcheck",
          
          -- Formatters
          "stylua",
          "prettier",
          "shfmt",
        },
        auto_update = true,
        run_on_start = true,
      })
    end
  }
}
