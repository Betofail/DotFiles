-- ~/.config/nvim/lua/plugins/lsp/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Esta función se ejecutará cada vez que un servidor LSP se adjunte a un buffer
    local on_attach = function(client, bufnr)
      local map = vim.keymap.set
      local opts = { buffer = bufnr, noremap = true, silent = true }

      -- Mapeos clave para la funcionalidad del LSP
      map('n', 'gd', vim.lsp.buf.definition, opts)
      map('n', 'gD', vim.lsp.buf.declaration, opts)
      map('n', 'gr', vim.lsp.buf.references, opts)
      map('n', 'gi', vim.lsp.buf.implementation, opts)
      map('n', 'K', vim.lsp.buf.hover, opts)
      map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      map('n', '<leader>rn', vim.lsp.buf.rename, opts)
      map('n', '<leader>sd', vim.diagnostic.open_float, opts) -- Mostrar diagnóstico de línea

      -- Navegación entre diagnósticos
      map('n', ']d', vim.diagnostic.goto_next, opts)
      map('n', '[d', vim.diagnostic.goto_prev, opts)
    end

    -- Configuración para los iconos de diagnóstico
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Usar mason-lspconfig para configurar los servidores
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })
      end,
    })
  end,
}