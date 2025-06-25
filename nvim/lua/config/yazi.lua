-- Opciones de configuración para yazi.nvim
local options = {
  -- Binario a ejecutar
  executable = "yazi",
  
  -- Configuración de UI
  floating = true,          -- usar ventana flotante en vez de pantalla completa
  height_ratio = 0.8,       -- altura de la ventana flotante (porcentaje)
  width_ratio = 0.8,        -- ancho de la ventana flotante (porcentaje)
  
  -- Detectores de raíz del proyecto
  project_root_markers = {
    ".git",
    "Cargo.toml",
    "package.json",
    "Makefile",
  },
}

-- Carga el módulo y configura
local yazi = require("yazi")
yazi.setup(options)

-- Función para configurar keybindings
local function setup_keybindings()
  -- Abrir Yazi en el directorio actual
  vim.keymap.set("n", "<leader>e", function()
    yazi.yazi()
  end, { desc = "Abrir Yazi en el directorio actual" })
  
  -- Abrir Yazi en la raíz del proyecto
  vim.keymap.set("n", "<leader>yr", function()
    yazi.yazi_from_project_root()
  end, { desc = "Abrir Yazi en la raíz del proyecto" })
  
  -- Abrir Yazi y seleccionar el archivo actual
  vim.keymap.set("n", "<leader>yf", function()
    local file = vim.fn.expand("%:p")
    yazi.yazi_containing_file(file)
  end, { desc = "Abrir Yazi y seleccionar archivo actual" })
end

-- Exportar funciones
local M = {}

-- Inicializar todo
function M.setup()
  setup_keybindings()
end

return M
