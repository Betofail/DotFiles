-- ~/.config/nvim/lua/plugins/navigation-core.lua
return {
	-- Buscador difuso (esencial para navegar archivos)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Navegación transparente entre paneles de Neovim y Zellij/Tmux
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- Desactivar si el panel está en pantalla completa
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
				},
			})
		end,
	},
}

