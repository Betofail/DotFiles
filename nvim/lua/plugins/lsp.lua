-- Archivo: lua/plugins/lsp.lua
-- Configuración LSP actualizada con ts_ls en lugar de tsserver

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Configuración manual de servidores LSP
      -- Lua
      if pcall(function() return require("lspconfig.configs").lua_ls end) then
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        })
      end
      
      -- TypeScript/JavaScript - Usando ts_ls en lugar de tsserver
      if pcall(function() return require("lspconfig.configs").ts_ls end) then
        lspconfig.ts_ls.setup({})
      end
      
      -- Python
      if pcall(function() return require("lspconfig.configs").pyright end) then
        lspconfig.pyright.setup({})
      end
      
      -- Bash
      if pcall(function() return require("lspconfig.configs").bashls end) then
        lspconfig.bashls.setup({})
      end
      
      -- Keymaps globales para LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          
          -- Navegación
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          
          -- Ayuda y documentación
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          
          -- Acciones de código
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          
          -- Formateo
          vim.keymap.set("n", "<leader>f", function() 
            vim.lsp.buf.format({ async = true }) 
          end, opts)
        end,
      })
    end,
  }
}
