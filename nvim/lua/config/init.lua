-- Este archivo carga todas las configuraciones de plugins y utilidades

-- Inicializar configuraciones que requieren setup
require("config.keybindings").setup()
require("config.yazi").setup()
require("config.navigation").setup()

-- Cargar configuraciones de plugins
require("config.harpoon")
require("config.which-key")
require("config.copilot")
require("config.catppuccin")


-- Aplicar tema después de cargar todas las configuraciones
vim.cmd.colorscheme("catppuccin")

-- Puedes agregar cualquier configuración adicional aquí
-- o comentar/descomentar módulos según necesites

-- Para nuevas configuraciones, simplemente agrega nuevas líneas aquí
-- require("config.nuevo_plugin")
