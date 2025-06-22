return {
	{ "folke/ts-comments.nvim", event = "VeryLazy" },
	{ "folke/which-key.nvim", lazy = true },
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
	{ "nvim-lua/plenary.nvim" },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}
