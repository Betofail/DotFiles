-- ~/.config/nvim/init.lua

-- Cargar configuración básica
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Bootstrap lazy.nvim (gestor de plugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_set_option("clipboard", "unnamed")
-- Cargar plugins
require("lazy").setup("plugins")
