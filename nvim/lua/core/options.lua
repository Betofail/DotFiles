
local opt = vim.opt

-- Apariencia
opt.termguicolors = true -- Habilitar colores verdaderos
opt.number = true        -- Mostrar números de línea
opt.relativenumber = true  -- Números de línea relativos para facilitar el movimiento
opt.signcolumn = "yes"   -- Siempre mostrar la columna de signos (para git, lsp, etc.)
opt.wrap = false         -- No envolver líneas largas

-- Comportamiento
opt.ignorecase = true    -- Ignorar mayúsculas/minúsculas al buscar
opt.smartcase = true     -- ... a menos que se use una mayúscula
opt.hlsearch = true      -- Resaltar resultados de búsqueda
opt.incsearch = true     -- Búsqueda incremental
opt.mouse = "a"          -- Habilitar el uso del ratón en todos los modos

-- Indentación
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Historial de cambios
opt.undofile = true

local undodir_path = vim.fn.stdpath("data") .. "/undodir"

opt.undodir = undodir_path

if vim.fn.isdirectory(undodir_path) == 0 then
  vim.fn.mkdir(undodir_path, "p")
end
