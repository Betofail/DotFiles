-- ~/.config/nvim/lua/plugins/mason.lua
return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- Java / Spring Boot
				"jdtls",
				"vscode-spring-boot-tools",

				-- Lua
				"lua-language-server",
				"stylua", -- Formateador para Lua

				-- Web (HTML, JS, TS, YAML)
				"html-lsp",
				"yaml-language-server",
				"typescript-language-server",
				"prettierd", -- Formateador para web (más rápido que prettier)

				-- Python
				"pyright",
				"black", -- Formateador para Python
				"isort", -- Organizador de imports para Python
			},
			ui = {
				icons = {
					package_installed = "",
					package_pending = "󰄰",
					package_uninstalled = "",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_enable = { exclude = { "jdtls" } },
		},
	},
}
