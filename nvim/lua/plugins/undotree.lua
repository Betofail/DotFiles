-- ~/.config/nvim/lua/plugins/undotree.lua
return {
	"mbbill/undotree",
	config = function()
		-- Atajo para abrir/cerrar Undotree
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree: Alternar" })
	end,
}

