-- Archivo: lua/plugins/init.lua
-- Configuración del gestor de plugins lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- última versión estable
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configuración de plugins
require("lazy").setup({
  -- Especificar los plugins aquí o importarlos desde otros archivos
  { import = "plugins.mason" }, -- Importa configuración de Mason
  { import = "plugins.lsp" },   -- Importa configuración de LSP
  -- Agrega otros imports según necesites
})
