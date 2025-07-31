return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lspsaga").setup({})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"neovim/nvim-lspconfig",
			"nvimdev/lspsaga.nvim",
			"j-hui/fidget.nvim",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					lsp_doc_border = true,
				},
			})
			require("notify").setup({
				background_colour = "#000000",
			})
			vim.notify = require("noice").notify
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Necesario para los iconos
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto", -- Puedes cambiarlo por temas como 'onedark', 'tokyonight', etc.
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {},
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" }, -- Muestra el progreso del LSP (ej: indexado)
					lualine_z = { "location" },
				},
			})
		end,
	},
}
