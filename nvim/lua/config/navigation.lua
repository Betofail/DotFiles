-- Archivo: nvim/lua/config/navigation.lua
-- Autor: Betofail
-- Fecha: 2025-06-25 19:57:43

local M = {}

function M.setup()
  -- Configurar opciones de pestañas y ventanas
  vim.opt.showtabline = 2  -- Siempre mostrar la barra de pestañas
  
  -- NAVEGACIÓN HORIZONTAL (PESTAÑAS) CON ALT+h/l
  -- Alt+h para ir a la pestaña anterior (izquierda)
  vim.keymap.set("n", "<A-h>", ":tabprevious<CR>", { silent = true, desc = "Pestaña anterior" })
  
  -- Alt+l para ir a la pestaña siguiente (derecha)
  vim.keymap.set("n", "<A-l>", ":tabnext<CR>", { silent = true, desc = "Pestaña siguiente" })
  
  -- NAVEGACIÓN VERTICAL (VENTANAS) CON ALT+j/k
  -- Alt+j para ir a la ventana de abajo
  vim.keymap.set("n", "<A-j>", "<C-w>j", { silent = true, desc = "Ventana abajo" })
  
  -- Alt+k para ir a la ventana de arriba
  vim.keymap.set("n", "<A-k>", "<C-w>k", { silent = true, desc = "Ventana arriba" })
  
  -- OPERACIONES PARA PESTAÑAS CON SHIFT+ALT
  -- Shift+Alt+k para crear nueva pestaña (arriba = nueva)
  vim.keymap.set("n", "<S-A-k>", ":tabnew<CR>", { silent = true, desc = "Nueva pestaña" })
  
  -- Shift+Alt+j para cerrar pestaña actual (abajo = cerrar)
  vim.keymap.set("n", "<S-A-j>", ":tabclose<CR>", { silent = true, desc = "Cerrar pestaña" })
  
  -- Shift+Alt+h/l para mover pestañas
  vim.keymap.set("n", "<S-A-h>", ":tabmove -1<CR>", { silent = true, desc = "Mover pestaña a la izquierda" })
  vim.keymap.set("n", "<S-A-l>", ":tabmove +1<CR>", { silent = true, desc = "Mover pestaña a la derecha" })
  
  -- OPERACIONES PARA VENTANAS CON CTRL+ALT
  -- Ctrl+Alt+j para dividir horizontalmente (abajo)
  vim.keymap.set("n", "<C-A-j>", ":split<CR>", { silent = true, desc = "Dividir horizontalmente" })
  
  -- Ctrl+Alt+k para dividir horizontalmente y mover a la nueva ventana
  vim.keymap.set("n", "<C-A-k>", ":split<CR><C-w>k", { silent = true, desc = "Dividir y mover arriba" })
  
  -- Ctrl+Alt+h para dividir verticalmente
  vim.keymap.set("n", "<C-A-h>", ":vsplit<CR><C-w>h", { silent = true, desc = "Dividir verticalmente y mover a la izquierda" })
  
  -- Ctrl+Alt+l para dividir verticalmente y mover a la nueva ventana
  vim.keymap.set("n", "<C-A-l>", ":vsplit<CR>", { silent = true, desc = "Dividir verticalmente" })
  
  -- REDIMENSIONAR VENTANAS CON SHIFT+ALT+CTRL
  vim.keymap.set("n", "<S-C-A-h>", ":vertical resize -5<CR>", { silent = true, desc = "Reducir ancho" })
  vim.keymap.set("n", "<S-C-A-l>", ":vertical resize +5<CR>", { silent = true, desc = "Aumentar ancho" })
  vim.keymap.set("n", "<S-C-A-j>", ":resize +5<CR>", { silent = true, desc = "Aumentar alto" })
  vim.keymap.set("n", "<S-C-A-k>", ":resize -5<CR>", { silent = true, desc = "Reducir alto" })
  
  -- Ir a pestañas específicas con Alt+número
  for i = 1, 9 do
    vim.keymap.set("n", string.format("<A-%d>", i), string.format(":%dtabnext<CR>", i), 
      { silent = true, desc = string.format("Ir a pestaña %d", i) })
  end
end

return M
