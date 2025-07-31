local opt = vim.opt

-- Apariencia
opt.termguicolors = true -- Habilitar colores verdaderos
opt.number = true -- Mostrar números de línea
opt.relativenumber = true -- Números de línea relativos para facilitar el movimiento
opt.signcolumn = "yes" -- Siempre mostrar la columna de signos (para git, lsp, etc.)
opt.wrap = false -- No envolver líneas largas

-- Comportamiento
opt.ignorecase = true -- Ignorar mayúsculas/minúsculas al buscar
opt.smartcase = true -- ... a menos que se use una mayúscula
opt.hlsearch = true -- Resaltar resultados de búsqueda
opt.incsearch = true -- Búsqueda incremental
opt.mouse = "a" -- Habilitar el uso del ratón en todos los modos

-- Indentación
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Historial de cambios
opt.undofile = true
-- ### Para una Mejor Experiencia Visual y de Navegación

-- Mantener 8 líneas de contexto arriba y abajo del cursor al hacer scroll
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Resaltar la línea donde se encuentra el cursor
opt.cursorline = true

-- Forzar que la barra de estado siempre sea visible
opt.laststatus = 3

-- Ocultar el mensaje de modo (-- INSERT --) ya que la barra de estado lo muestra
opt.showmode = false

-- ### Para Mejorar el Rendimiento y la Capacidad de Respuesta

-- Reducir el tiempo de espera para eventos (mejora la respuesta de plugins)
opt.updatetime = 250

-- Reducir el tiempo de espera para secuencias de atajos de teclado
opt.timeoutlen = 300

-- ### Para el Menú de Autocompletado

-- Configuración estándar para el comportamiento del menú de autocompletado
opt.completeopt = { "menu", "menuone", "noselect" }

-- ### Para la División de Ventanas

-- Hacer que las nuevas divisiones de ventana aparezcan a la derecha y abajo
opt.splitright = true
opt.splitbelow = true

local undodir_path = vim.fn.stdpath("data") .. "/undodir"

opt.undodir = undodir_path

if vim.fn.isdirectory(undodir_path) == 0 then
	vim.fn.mkdir(undodir_path, "p")
end
