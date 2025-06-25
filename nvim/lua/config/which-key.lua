local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  vim.notify("which-key no está instalado", vim.log.levels.ERROR)
  return
end

-- Configuración básica
local setup = {
  plugins = {
    marks = true,        -- muestra marcas
    registers = true,    -- muestra registros
    spelling = {
      enabled = false,   -- habilitar sugerencias de corrección
      suggestions = 20,  -- número de sugerencias
    },
    -- Configuración de presets
    presets = {
      operators = true,     -- símbolos de operadores como d, y, etc.
      motions = true,       -- símbolos de movimientos como f, t, etc.
      text_objects = true,  -- símbolos de objetos de texto como ), }, etc.
      windows = true,       -- símbolos para ventanas como <c-w>s, etc.
      nav = true,           -- símbolos para navegación como [b, etc.
      z = true,             -- símbolos para comandos con z como zz, etc.
      g = true,             -- símbolos para comandos con g como gd, etc.
    },
  },
  -- Iconos y símbolos
  icons = {
    breadcrumb = "»",  -- símbolo para breadcrumb
    separator = "➜",   -- símbolo para separador
    group = "+",       -- símbolo para grupo
  },
  -- Estilo de ventana
  window = {
    border = "rounded",      -- none, single, double, shadow, rounded
    position = "bottom",     -- bottom, top
    margin = { 1, 0, 1, 0 }, -- margen extra [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- padding [top, right, bottom, left]
    winblend = 0,            -- transparencia (0-100)
  },
  -- Disposición
  layout = {
    height = { min = 4, max = 25 },   -- altura min/max
    width = { min = 20, max = 50 },   -- ancho min/max
    spacing = 3,                     -- espacio entre columnas
    align = "left",                  -- alineación (left, center, right)
  },
  -- Comportamiento
  show_help = true,         -- mostrar ayuda en popup
  show_keys = true,         -- mostrar las teclas presionadas
  triggers_blacklist = {    -- nunca mostrar en estos modos
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- Disable which-key for the following filetypes
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
}

-- Aplicar configuración básica
which_key.setup(setup)

-- Mappings para modo normal con <leader>
local opts = {
  mode = "n",        -- modo normal
  prefix = "<leader>", -- tecla líder
  buffer = nil,      -- buffer global
  silent = true,     -- no mostrar comando
  noremap = true,    -- no remapeo recursivo
  nowait = true,     -- no esperar a más teclas
}

-- Mappings principales
local mappings = {
  { "<leader><leader>", group = "Navegación", nowait = true, remap = false },
  { "<leader><leader>h", "<cmd>tabprevious<cr>", desc = "Pestaña anterior", nowait = true, remap = false },
  { "<leader><leader>j", "<C-w>j", desc = "Ventana abajo", nowait = true, remap = false },
  { "<leader><leader>k", "<C-w>k", desc = "Ventana arriba", nowait = true, remap = false },
  { "<leader><leader>l", "<cmd>tabnext<cr>", desc = "Pestaña siguiente", nowait = true, remap = false },
  { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Proyectos", nowait = true, remap = false },
  { "<leader>a", "<function 1>", desc = "Harpoon: Añadir archivo", nowait = true, remap = false },
  { "<leader>c", group = "Copilot", nowait = true, remap = false },
  { "<leader>cd", "<cmd>Copilot disable<cr>", desc = "Deshabilitar", nowait = true, remap = false },
  { "<leader>ce", "<cmd>Copilot enable<cr>", desc = "Habilitar", nowait = true, remap = false },
  { "<leader>cp", "<cmd>Copilot panel<cr>", desc = "Abrir panel", nowait = true, remap = false },
  { "<leader>f", group = "Archivo/Buscar", nowait = true, remap = false },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers", nowait = true, remap = false },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos", nowait = true, remap = false },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto", nowait = true, remap = false },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Ayuda", nowait = true, remap = false },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Archivos recientes", nowait = true, remap = false },
  { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Buscar palabra", nowait = true, remap = false },
  { "<leader>g", group = "Git", nowait = true, remap = false },
  { "<leader>gC", "<cmd>Telescope git_commits<cr>", desc = "Commits", nowait = true, remap = false },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Ramas", nowait = true, remap = false },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit", nowait = true, remap = false },
  { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff", nowait = true, remap = false },
  { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Siguiente cambio", nowait = true, remap = false },
  { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Anterior cambio", nowait = true, remap = false },
  { "<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame", nowait = true, remap = false },
  { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Estado", nowait = true, remap = false },
  { "<leader>gp", "<cmd>Git push<cr>", desc = "Push", nowait = true, remap = false },
  { "<leader>gs", "<cmd>Git<cr>", desc = "Status", nowait = true, remap = false },
  { "<leader>h", group = "Harpoon", nowait = true, remap = false },
  { "<leader>hm", "<function 1>", desc = "Menu", nowait = true, remap = false },
  { "<leader>l", group = "LSP", nowait = true, remap = false },
  { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Ir a declaración", nowait = true, remap = false },
  { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Info de instalación", nowait = true, remap = false },
  { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Renombrar", nowait = true, remap = false },
  { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Símbolos del workspace", nowait = true, remap = false },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Acción de código", nowait = true, remap = false },
  { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Ir a definición", nowait = true, remap = false },
  { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Formatear", nowait = true, remap = false },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
  { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Siguiente diagnóstico", nowait = true, remap = false },
  { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Anterior diagnóstico", nowait = true, remap = false },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens", nowait = true, remap = false },
  { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Lista de diagnósticos", nowait = true, remap = false },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Referencias", nowait = true, remap = false },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Símbolos del documento", nowait = true, remap = false },
  { "<leader>p", group = "Pestañas", nowait = true, remap = false },
  { "<leader>p1", "<cmd>1tabnext<cr>", desc = "Ir a pestaña 1", nowait = true, remap = false },
  { "<leader>p2", "<cmd>2tabnext<cr>", desc = "Ir a pestaña 2", nowait = true, remap = false },
  { "<leader>p3", "<cmd>3tabnext<cr>", desc = "Ir a pestaña 3", nowait = true, remap = false },
  { "<leader>p4", "<cmd>4tabnext<cr>", desc = "Ir a pestaña 4", nowait = true, remap = false },
  { "<leader>p5", "<cmd>5tabnext<cr>", desc = "Ir a pestaña 5", nowait = true, remap = false },
  { "<leader>pc", "<cmd>tabclose<cr>", desc = "Cerrar pestaña", nowait = true, remap = false },
  { "<leader>pd", "<cmd>tabnew %<cr>", desc = "Duplicar en nueva pestaña", nowait = true, remap = false },
  { "<leader>ph", "<cmd>tabmove -1<cr>", desc = "Mover pestaña izquierda", nowait = true, remap = false },
  { "<leader>pl", "<cmd>tabmove +1<cr>", desc = "Mover pestaña derecha", nowait = true, remap = false },
  { "<leader>pn", "<cmd>tabnew<cr>", desc = "Nueva pestaña", nowait = true, remap = false },
  { "<leader>pr", "<cmd>TabRename ", desc = "Renombrar pestaña", nowait = true, remap = false },
  { "<leader>q", "<cmd>q!<CR>", desc = "Salir", nowait = true, remap = false },
  { "<leader>t", group = "Terminal", nowait = true, remap = false },
  { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal flotante", nowait = true, remap = false },
  { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Terminal horizontal", nowait = true, remap = false },
  { "<leader>tt", "<cmd>terminal<cr>", desc = "Abrir terminal", nowait = true, remap = false },
  { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Terminal vertical", nowait = true, remap = false },
  { "<leader>w", group = "Ventanas", nowait = true, remap = false },
  { "<leader>w+", "<cmd>resize +5<cr>", desc = "Aumentar altura", nowait = true, remap = false },
  { "<leader>w-", "<cmd>resize -5<cr>", desc = "Reducir altura", nowait = true, remap = false },
  { "<leader>w<", "<cmd>vertical resize -5<cr>", desc = "Reducir ancho", nowait = true, remap = false },
  { "<leader>w=", "<C-w>=", desc = "Igualar tamaño de ventanas", nowait = true, remap = false },
  { "<leader>w>", "<cmd>vertical resize +5<cr>", desc = "Aumentar ancho", nowait = true, remap = false },
  { "<leader>wh", "<C-w>h", desc = "Ir a ventana izquierda", nowait = true, remap = false },
  { "<leader>wj", "<C-w>j", desc = "Ir a ventana abajo", nowait = true, remap = false },
  { "<leader>wk", "<C-w>k", desc = "Ir a ventana arriba", nowait = true, remap = false },
  { "<leader>wl", "<C-w>l", desc = "Ir a ventana derecha", nowait = true, remap = false },
  { "<leader>wo", "<cmd>only<cr>", desc = "Cerrar otras ventanas", nowait = true, remap = false },
  { "<leader>wq", "<cmd>q<cr>", desc = "Cerrar ventana actual", nowait = true, remap = false },
  { "<leader>ws", "<cmd>split<cr>", desc = "Dividir horizontalmente", nowait = true, remap = false },
  { "<leader>wv", "<cmd>vsplit<cr>", desc = "Dividir verticalmente", nowait = true, remap = false },
  { "<leader>y", group = "Yazi", nowait = true, remap = false },
  { "<leader>yf", "<function 1>", desc = "Abrir Yazi y seleccionar archivo actual", nowait = true, remap = false },
  { "<leader>yr", "<function 1>", desc = "Abrir Yazi en raíz del proyecto", nowait = true, remap = false },
  { "<leader>yy", "<function 1>", desc = "Abrir Yazi en directorio actual", nowait = true, remap = false },
}

-- Registrar mappings
which_key.register(mappings, opts)

-- Comando para mostrar which-key manualmente
vim.api.nvim_create_user_command("WhichKey", function()
  vim.cmd("WhichKey " .. vim.g.mapleader)
end, {})
