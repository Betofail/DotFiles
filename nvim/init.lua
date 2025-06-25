---@diagnostic disable: undefined-global
-- Configuración principal de Neovim
-- Autor: Betofail
-- Fecha: 2025-06-24
-- Descripción: Configuración de Neovim optimizada para desarrollo y soporte para Copilot

-- Carga opciones básicas y atajos
require("core.options")
require("core.keymaps")

-- Carga y configura plugins
require("core.plugins")

-- Carga configuración de plugins específicos
require("plugins.lsp")
require("plugins.treesitter")
require("plugins.telescope")
