return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Configuración de diagnósticos
			vim.diagnostic.config({
				virtual_text = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			-- Función que se ejecuta cuando un servidor se adjunta a un buffer
			local on_attach = function(client, bufnr)
				local map = vim.keymap.set
				local opts = { buffer = bufnr, noremap = true, silent = true }

				map("n", "gd", vim.lsp.buf.definition, opts)
				map("n", "gD", vim.lsp.buf.declaration, opts)
				map("n", "gr", vim.lsp.buf.references, opts)
				map("n", "gi", vim.lsp.buf.implementation, opts)
				map("n", "K", vim.lsp.buf.hover, opts)
			end

			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			mason_lspconfig.setup({
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							on_attach = on_attach,
							capabilities = capabilities,
						})
					end,
				},
			})
		end,
	},
}
