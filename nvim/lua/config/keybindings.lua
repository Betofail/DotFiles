-- Archivo: nvim/lua/config/keybindings.lua
-- Autor: Betofail
-- Fecha: 2025-06-25 19:19:57

local M = {}

-- Función para configurar todos los keybindings
function M.setup()
  local keymap = vim.keymap.set
  
  -- Leader key
  vim.g.mapleader = " "
  
  -- GRUPO: Archivo/Buscar (f)
  keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar archivos" })
  keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Buscar texto" })
  keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Archivos recientes" })
  keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
  
  -- GRUPO: Git (g)
  keymap("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Status" })
  keymap("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Commit" })
  keymap("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Push" })
  
  -- GRUPO: Harpoon (h)
  keymap("n", "<leader>hm", function() 
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) 
  end, { desc = "Menu" })
  
  -- Harpoon teclas directas
  keymap("n", "<leader>a", function() 
    require("harpoon"):list():append() 
  end, { desc = "Harpoon: Añadir archivo" })
  
  keymap("n", "<leader>1", function() 
    require("harpoon"):list():select(1) 
  end, { desc = "Harpoon: Archivo 1" })
  
  keymap("n", "<leader>2", function() 
    require("harpoon"):list():select(2) 
  end, { desc = "Harpoon: Archivo 2" })
  
  keymap("n", "<leader>3", function() 
    require("harpoon"):list():select(3) 
  end, { desc = "Harpoon: Archivo 3" })
  
  keymap("n", "<leader>4", function() 
    require("harpoon"):list():select(4) 
  end, { desc = "Harpoon: Archivo 4" })
  
  -- GRUPO: LSP (l)
  keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Ir a definición" })
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Referencias" })
  keymap("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Renombrar" })
  keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Acción de código" })
  keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Formatear" })
  
  -- GRUPO: Terminal/Pestañas (t)
  keymap("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Abrir terminal" })
  keymap("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Nueva pestaña" })
  keymap("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Cerrar pestaña" })
  keymap("n", "<leader>th", "<cmd>tabprev<cr>", { desc = "Pestaña anterior" })
  keymap("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Pestaña siguiente" })
  
  -- GRUPO: Yazi (y)
  keymap("n", "<leader>yy", function() 
    require("yazi").yazi() 
  end, { desc = "Abrir Yazi en directorio actual" })
  
  keymap("n", "<leader>yr", function() 
    require("yazi").yazi_from_project_root() 
  end, { desc = "Abrir Yazi en raíz del proyecto" })
  
  keymap("n", "<leader>yf", function() 
    local file = vim.fn.expand("%:p")
    require("yazi").yazi_containing_file(file) 
  end, { desc = "Abrir Yazi y seleccionar archivo actual" })
  
  -- GRUPO: Copilot (c)
  keymap("n", "<leader>cp", "<cmd>Copilot panel<cr>", { desc = "Abrir panel" })
  keymap("n", "<leader>ce", "<cmd>Copilot enable<cr>", { desc = "Habilitar" })
  keymap("n", "<leader>cd", "<cmd>Copilot disable<cr>", { desc = "Deshabilitar" })
  
  -- Botón de ayuda
  keymap("n", "<leader>?", function() 
    require("which-key").show_command({mode = "n", prefix = "<leader>"}) 
  end, { desc = "Mostrar ayuda de which-key" })
end

return M
