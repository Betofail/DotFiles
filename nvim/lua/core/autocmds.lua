-- nvim/lua/core/autocmds.lua

-- Función para formatear al guardar
local function format_on_save()
	-- Obtiene los clientes LSP activos para el buffer actual
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })

	-- Si no hay clientes, no hace nada
	if #clients == 0 then
		return
	end

	-- Busca un cliente que soporte formateo
	local found_formatter = false
	for _, client in ipairs(clients) do
		if client.server_capabilities.documentFormattingProvider then
			found_formatter = true
			break
		end
	end

	-- Si no se encuentra un formateador, no hace nada
	if not found_formatter then
		return
	end

	-- Ejecuta el formateo
	vim.lsp.buf.format({ async = true, bufnr = 0 })
end

-- Grupo para el autocomando de formateo al guardar
local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

-- Autocomando que se ejecuta antes de guardar un archivo
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_on_save_group,
	pattern = "*",
	callback = format_on_save,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(args)
		require("jdtls.jdtls_setup").setup()
	end,
})
