-- ~/.config/nvim/lua/plugins/java.lua
return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" }, -- Carga el plugin solo para archivos Java
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
	},
	config = function()
		-- Asegúrate de que jdtls esté instalado
		local mason_registry = require("mason-registry")
		local jdtls_pkg = mason_registry.get_package("jdtls")
		if not jdtls_pkg:is_installed() then
			print("JDTLS no está instalado. Por favor, ejecute :MasonInstall jdtls")
			return
		end

		local jdtls_path = jdtls_pkg:get_install_path()
		local jdtls_launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

		-- Define la configuración del servidor
		local config = {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1.JavaLanguageServerImpl",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xms1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				jdtls_launcher,
				"-configuration",
				jdtls_path .. "/config_linux", -- O 'config_mac', 'config_win'
				"-data",
				vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
			},
			root_dir = require("lspconfig.util").root_pattern(".git", "mvnw", "gradlew", "pom.xml"),
			on_attach = function(client, bufnr)
				-- Tus atajos de teclado aquí
				local map = vim.keymap.set
				local opts = { buffer = bufnr }
				map("n", "gd", vim.lsp.buf.definition, opts)
				map("n", "K", vim.lsp.buf.hover, opts)
			end,
		}

		-- Inicia el servidor
		require("lspconfig").jdtls.setup(config)
	end,
}
