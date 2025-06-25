--- @diagnostic disable: undefined-global
-- Configuración principal de Neovim
-- Autor: Betofail
-- Fecha: 2025-06-24
-- Descripción: Configuración de Neovim optimizada para desarrollo y soporte para Copilot
-- Archivo: init.lua
-- Archivo principal de configuración de Neovim

-- Configuraciones básicas
vim.g.mapleader = " " -- Tecla líder
vim.g.maplocalleader = " "

-- Opciones globales
vim.opt.number = true         -- Números de línea
vim.opt.relativenumber = true -- Números de línea relativos
vim.opt.mouse = "a"           -- Soporte para mouse
vim.opt.clipboard = "unnamedplus" -- Sincronizar con clipboard del sistema
vim.opt.breakindent = true    -- Indentación de líneas envueltas
vim.opt.undofile = true       -- Guardar historial de deshacer
vim.opt.ignorecase = true     -- Buscar sin distinguir mayúsculas
vim.opt.smartcase = true      -- Pero respetar mayúsculas si se incluyen
vim.opt.signcolumn = "yes"    -- Mostrar columna de signos siempre
vim.opt.updatetime = 250      -- Actualización más rápida
vim.opt.timeoutlen = 300      -- Tiempo para combinaciones de teclas
vim.opt.splitright = true     -- Abrir ventanas a la derecha
vim.opt.splitbelow = true     -- Abrir ventanas abajo
vim.opt.termguicolors = true  -- Colores en terminal

-- Configuración de la sangría
vim.opt.expandtab = true      -- Usar espacios en lugar de tabs
vim.opt.tabstop = 2           -- Un tab equivale a 2 espacios
vim.opt.shiftwidth = 2        -- Sangría de 2 espacios
vim.opt.smartindent = true    -- Indentación inteligente

-- Cargar el gestor de plugins lazy.nvim
require("plugins")

-- Cargar otras configuracione
require("config.keymaps")
require("config.yazi")
-- require("config.autocmds")
-- etc.
