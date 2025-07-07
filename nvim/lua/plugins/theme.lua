return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = "mocha", -- or use "auto" and it will detect your terminal background
      background = {
        light = "latte",
        dark = "mocha",
      },
      -- ... other configurations
    })
    vim.cmd.colorscheme "catppuccin-mocha"
  end,
}
