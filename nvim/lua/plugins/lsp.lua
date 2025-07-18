return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN]  = "",
          [vim.diagnostic.severity.HINT]  = "",
          [vim.diagnostic.severity.INFO]  = "",
        },
      },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded"
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded"
    })
    local on_attach = function(client, bufnr)
      local map = vim.keymap.set
      local opts = { buffer = bufnr, noremap = true, silent = true }

      map('n', 'gd', vim.lsp.buf.definition, opts)
      map('n', 'gD', vim.lsp.buf.declaration, opts)
      map('n', 'gr', vim.lsp.buf.references, opts)
      map('n', 'gi', vim.lsp.buf.implementation, opts)
      map('n', 'K', vim.lsp.buf.hover, opts)
    end

    local mason_lspconfig = require("mason-lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require("mason").setup()
    mason_lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "bashls",
        "biome",
        "cssls",
        "tsserver",
      },
      handlers = {
        -- Volvemos a la configuración estándar
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
      },
    })
  end,
}
