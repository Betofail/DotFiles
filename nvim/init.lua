--- @diagnostic disable: undefined-global
-- Configuración principal de Neovim
-- Autor: Betofail
-- Fecha: 2025-06-24
-- Descripción: Configuración de Neovim optimizada para desarrollo y soporte para Copilot
-- Archivo: init.lua
-- Archivo principal de configuración de Neovim

-- Configuraciones básicas
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Opciones generales de Neovim
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.updatetime = 300
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.clipboard = "unnamedplus"

-- Inicializar lazy.nvim para gestión de plugins
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

-- Cargar plugins desde el archivo de plugins
require("lazy").setup("plugins")

-- Cargar todas las configuraciones desde el módulo config
require("config")
