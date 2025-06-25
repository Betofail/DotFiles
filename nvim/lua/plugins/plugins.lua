return {
  -- Harpoon2 para navegación rápida entre archivos
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Sin config, se configurará manualmente después
  },
  
  -- Which-key para visualizar atajos de teclado
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- Sin config, se configurará manualmente después
  },
  
  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    -- Sin config, se configurará manualmente después
  },
  
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    -- Sin config, se configurará manualmente después
  },

  -- Telescope (buscador)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },
  
  -- Treesitter para mejor resaltado de sintaxis
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
  },
  
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  
  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  
  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  
  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
  },
  
  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
  },
  
  -- Comment
  {
    'numToStr/Comment.nvim',
  },
}
