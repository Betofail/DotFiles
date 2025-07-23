-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set

-- Líder (la tecla más importante)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navegación básica
map("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Buscar Archivos" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buscar Buffers" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Buscar por Texto (Grep)" })

-- Movimiento entre ventanas divididas (splits)
map("n", "<C-h>", "<C-w>h", { desc = "Mover a ventana Izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Mover a ventana Abajo" })
map("n", "<C-k>", "<C-w>k", { desc = "Mover a ventana Arriba" })
map("n", "<C-l>", "<C-w>l", { desc = "Mover a ventana Derecha" })

-- Dividir ventanas
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Dividir Verticalmente" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Dividir Horizontalmente" })

-- Cerrar buffer
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Cerrar Buffer Actual" })

-- Limpiar búsqueda resaltada
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Explorador de Archivos
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Alternar Explorador de Archivos" })
