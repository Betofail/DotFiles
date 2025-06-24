-- Configuración principal de Neovim
-- Autor: Betofail
-- Fecha: 2025-06-24
-- Descripción: Configuración de Neovim optimizada para desarrollo y soporte para Copilot

-----------------------
-- Opciones básicas ---
-----------------------
vim.g.mapleader = " " -- Establecer espacio como tecla líder
vim.g.maplocalleader = " "

local opt = vim.opt

-- UI
opt.number = true           -- Mostrar números de línea
opt.relativenumber = true   -- Números de línea relativos
opt.cursorline = true       -- Resaltar línea actual
opt.signcolumn = "yes"      -- Mostrar columna de signos
opt.scrolloff = 8           -- Mantener 8 líneas al desplazarse
opt.sidescrolloff = 8       -- Mantener 8 columnas al desplazarse horizontalmente
opt.wrap = false            -- No envolver líneas
opt.termguicolors = true    -- Soporte para colores
opt.background = "dark"     -- Tema oscuro
opt.showmode = false        -- No mostrar modo (lo muestra la línea de estado)
opt.cmdheight = 1           -- Altura de línea de comandos

-- Edición
opt.expandtab = true        -- Usar espacios en vez de tabulaciones
opt.tabstop = 2             -- Ancho de tabulación
opt.shiftwidth = 2          -- Ancho de indentación
opt.softtabstop = 2         -- Número de espacios por Tab
opt.smartindent = true      -- Autoindentación inteligente
opt.autoindent = true       -- Mantener indentación
opt.breakindent = true      -- Mantener indentación en líneas envueltas
opt.clipboard = "unnamedplus" -- Usar portapapeles del sistema

-- Búsqueda
opt.ignorecase = true       -- Ignorar mayúsculas/minúsculas
opt.smartcase = true        -- A menos que se incluya una mayúscula
opt.hlsearch = true         -- Resaltar coincidencias
opt.incsearch = true        -- Búsqueda incremental

-- Rendimiento
opt.updatetime = 250        -- Actualización más rápida
opt.timeoutlen = 300        -- Tiempo para combinaciones de teclas
opt.hidden = true           -- Permitir buffers ocultos

-- Archivos y directorios
opt.swapfile = false        -- Sin archivos swap
opt.backup = false          -- Sin archivos de backup
opt.undofile = true         -- Persistir historial de deshacer
opt.undodir = vim.fn.stdpath("data") .. "/undo" -- Directorio para archivos de deshacer

-- Otros
opt.mouse = "a"             -- Soporte para ratón
opt.completeopt = "menu,menuone,noselect" -- Opciones de completado

-----------------------
-- Lazy.nvim (gestor de plugins) --
-----------------------
-- Bootstrap Lazy.nvim si no está instalado
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- última versión estable
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Cargar plugins
require("lazy").setup({
  -- Tema
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        term_colors = true,
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
          which_key = true,
          notify = true,
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- Línea de estado
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- Bufferline (pestañas)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
        },
      })
    end,
  },

  -- Explorador de archivos
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Syntax highlighting con Treesitter
  {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", "c", "cpp", "css", "dockerfile", "go", "html", "javascript",
        "json", "lua", "markdown", "python", "rust", "typescript", "yaml",
      },
      sync_install = false,  -- Instalar parsers asincrónicamente
      auto_install = true,   -- Instalar parsers automáticamente
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<C-backspace>",
        },
      },
      modules = {},
    })
  end,
  },

  -- Telescope (buscador)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          layout_strategy = 'horizontal',
          layout_config = { width = 0.95, height = 0.85 },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  -- LSP y herramientas de desarrollo
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Para integración con completado
    },
  },

  -- Soporte para configuración de Neovim Lua
  {
    "folke/neodev.nvim",
    opts = {},
  },

  -- Mason (instalador de LSP, DAP, linters, formatters)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- Integración de Mason con LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "folke/neodev.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "html", "cssls", "jsonls", "yamlls",
          "bashls", "dockerls", "gopls", "rust_analyzer"
        },
        automatic_installation = true,
      })

      -- Configurar servidores LSP
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Configuración específica para lua_ls
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- LuaJIT en el caso de Neovim
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Obtener el diagnóstico reconociendo el ambiente de vim global
              globals = { 'vim' },
            },
            workspace = {
              -- Hacer que el servidor reconozca la biblioteca de runtime de Neovim
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- No enviar telemetría
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Configuración para otros servidores
      local servers = {
        "pyright", "html", "cssls", "jsonls", "yamlls",
        "bashls", "dockerls", "gopls", "rust_analyzer"
      }

      for _, server in ipairs(servers) do
        if lspconfig[server] then
          lspconfig[server].setup({
            capabilities = capabilities,
          })
        end
      end
    end,
  },

  -- Autocompletado
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Confirmar sin seleccionar
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            symbol_map = {
              Copilot = "",
            },
          }),
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
      })

      -- Configurar autocompletado para la línea de comandos
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      -- Configurar autocompletado para búsqueda
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Previous()', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Next()', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-\\>", 'copilot#Dismiss()', { silent = true, expr = true })
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navegación
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Acciones
          map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage selected hunk" })
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset selected hunk" })
          map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Blame line" })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
          map('n', '<leader>td', gs.toggle_deleted, { desc = "Toggle deleted" })
        end
      })
    end,
  },

  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Ayudas visuales
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- Comentarios
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },


-- Which-key para recordar atajos
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require("which-key").setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = false,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      -- La propiedad 'window' es obsoleta, usa 'win' en su lugar
      win = {
        -- 'position' no es una propiedad válida en 'win', quitémosla
        border = "single",
        padding = { 2, 2, 2, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = false,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
      show_help = true,
      triggers = "auto",
    })
    require("which-key").add({
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Copilot/Código" },
      { "<leader>d", group = "Docker" },
      { "<leader>f", group = "Archivos/Buscar" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Hunks (Git)" },
      { "<leader>r", group = "Refactorizar" },
      { "<leader>t", group = "Terminal" },
      { "<leader>x", group = "Diagnósticos" },
    })
  end,
},

  -- Terminal integrado
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      function _G.set_terminal_keymaps()
        local opts = {noremap = true}
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },

  -- Auto-pares
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end
  },

  -- Notificaciones
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- LSP diagnostics
  {
    "folke/trouble.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
      require("trouble").setup {}
    end
  },

  -- Formato y linting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        rust = { "rustfmt" },
        go = { "gofmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
})

-- Configuración del clipboard
vim.opt.clipboard = "unnamedplus"  -- Usar el clipboard del sistema

-- Configuración específica del clipboard provider
if vim.fn.has('wsl') == 1 then
  -- En WSL, usa clip.exe de Windows
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
elseif os.getenv("WAYLAND_DISPLAY") ~= nil then
  -- En Wayland
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 1,
  }
end

-----------------------
-- LSP configuración --
-----------------------
-- Keymaps globales para LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Keybindings disponibles cuando LSP está activo
    local function buf_set_keymap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end

    -- Helpers para acciones LSP comunes
    buf_set_keymap('n', 'gD', vim.lsp.buf.declaration, "Ir a declaración")
    buf_set_keymap('n', 'gd', vim.lsp.buf.definition, "Ir a definición")
    buf_set_keymap('n', 'K', vim.lsp.buf.hover, "Mostrar información")
    buf_set_keymap('n', 'gi', vim.lsp.buf.implementation, "Ir a implementación")
    buf_set_keymap('n', '<C-k>', vim.lsp.buf.signature_help, "Mostrar firma")
    buf_set_keymap('n', '<leader>D', vim.lsp.buf.type_definition, "Ir a definición de tipo")
    buf_set_keymap('n', '<leader>rn', vim.lsp.buf.rename, "Renombrar")
    buf_set_keymap('n', '<leader>ca', vim.lsp.buf.code_action, "Acciones de código")
    buf_set_keymap('n', 'gr', vim.lsp.buf.references, "Mostrar referencias")

    -- Diagnósticos
    buf_set_keymap('n', '[d', vim.diagnostic.goto_prev, "Ir al diagnóstico anterior")
    buf_set_keymap('n', ']d', vim.diagnostic.goto_next, "Ir al siguiente diagnóstico")
    buf_set_keymap('n', '<leader>e', vim.diagnostic.open_float, "Mostrar diagnóstico flotante")
    buf_set_keymap('n', '<leader>q', vim.diagnostic.setloclist, "Añadir diagnósticos a la lista")

    -- Formateo si el cliente lo soporta
    if client.server_capabilities.documentFormattingProvider then
      buf_set_keymap('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, "Formatear documento")
    end
  end
})

---------------------
-- Keymaps globales --
---------------------
-- Definir atajos de teclado globales
local map = vim.keymap.set

-- General
map('n', '<leader>w', '<CMD>write<CR>', { desc = "Guardar archivo" })
map('n', '<leader>q', '<CMD>quit<CR>', { desc = "Cerrar ventana" })
map('n', '<leader>Q', '<CMD>qa<CR>', { desc = "Salir de Neovim" })
map('n', '<leader>h', '<CMD>nohlsearch<CR>', { desc = "Quitar resaltado de búsqueda" })

-- Navegación entre ventanas
map('n', '<C-h>', '<C-w>h', { desc = "Ir a ventana izquierda" })
map('n', '<C-j>', '<C-w>j', { desc = "Ir a ventana inferior" })
map('n', '<C-k>', '<C-w>k', { desc = "Ir a ventana superior" })
map('n', '<C-l>', '<C-w>l', { desc = "Ir a ventana derecha" })

-- Redimensionar ventanas
map('n', '<C-Up>', '<CMD>resize -2<CR>', { desc = "Reducir altura" })
map('n', '<C-Down>', '<CMD>resize +2<CR>', { desc = "Aumentar altura" })
map('n', '<C-Left>', '<CMD>vertical resize -2<CR>', { desc = "Reducir anchura" })
map('n', '<C-Right>', '<CMD>vertical resize +2<CR>', { desc = "Aumentar anchura" })

-- Navegación entre buffers/pestañas
map('n', '<S-l>', '<CMD>bnext<CR>', { desc = "Buffer siguiente" })
map('n', '<S-h>', '<CMD>bprevious<CR>', { desc = "Buffer anterior" })
map('n', '<leader>bd', '<CMD>bdelete<CR>', { desc = "Cerrar buffer" })

-- Movimiento de líneas
map('n', '<A-j>', '<CMD>m .+1<CR>==', { desc = "Mover línea abajo" })
map('n', '<A-k>', '<CMD>m .-2<CR>==', { desc = "Mover línea arriba" })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo" })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba" })

-- Telescope
map('n', '<leader>ff', '<CMD>Telescope find_files<CR>', { desc = "Buscar archivos" })
map('n', '<leader>fg', '<CMD>Telescope live_grep<CR>', { desc = "Buscar texto en archivos" })
map('n', '<leader>fb', '<CMD>Telescope buffers<CR>', { desc = "Buscar buffers" })
map('n', '<leader>fh', '<CMD>Telescope help_tags<CR>', { desc = "Buscar ayuda" })
map('n', '<leader>fr', '<CMD>Telescope oldfiles<CR>', { desc = "Archivos recientes" })
map('n', '<leader>fd', '<CMD>Telescope diagnostics<CR>', { desc = "Diagnósticos" })

-- NvimTree
map('n', '<leader>e', '<CMD>NvimTreeToggle<CR>', { desc = "Explorador de archivos" })
map('n', '<leader>o', '<CMD>NvimTreeFocus<CR>', { desc = "Enfocar explorador" })

-- Git
map('n', '<leader>gg', '<CMD>LazyGit<CR>', { desc = "LazyGit" })
map('n', '<leader>gj', '<CMD>Gitsigns next_hunk<CR>', { desc = "Siguiente cambio" })
map('n', '<leader>gk', '<CMD>Gitsigns prev_hunk<CR>', { desc = "Cambio anterior" })
map('n', '<leader>gp', '<CMD>Gitsigns preview_hunk<CR>', { desc = "Ver cambio" })
map('n', '<leader>gr', '<CMD>Gitsigns reset_hunk<CR>', { desc = "Deshacer cambio" })
map('n', '<leader>gs', '<CMD>Gitsigns stage_hunk<CR>', { desc = "Añadir cambio" })

-- Terminal
map('n', '<leader>t', '<CMD>ToggleTerm<CR>', { desc = "Abrir/cerrar terminal" })
map('n', '<leader>tf', '<CMD>ToggleTerm direction=float<CR>', { desc = "Terminal flotante" })
map('n', '<leader>th', '<CMD>ToggleTerm direction=horizontal<CR>', { desc = "Terminal horizontal" })
map('n', '<leader>tv', '<CMD>ToggleTerm direction=vertical<CR>', { desc = "Terminal vertical" })

-- Comentarios
map('n', '<leader>/', function() require("Comment.api").toggle.linewise.current() end, { desc = "Comentar línea" })
map('v', '<leader>/', function()
  vim.api.nvim_input('<ESC>')
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Comentar selección" })

-- Copilot
map('n', '<leader>cc', '<CMD>Copilot panel<CR>', { desc = "Abrir panel de Copilot" })
map('n', '<leader>ce', '<CMD>Copilot enable<CR>', { desc = "Activar Copilot" })
map('n', '<leader>cd', '<CMD>Copilot disable<CR>', { desc = "Desactivar Copilot" })
map('n', '<leader>cs', '<CMD>Copilot status<CR>', { desc = "Estado de Copilot" })

-- Diagnósticos
map('n', '<leader>xx', '<CMD>TroubleToggle<CR>', { desc = "Alternar panel de problemas" })
map('n', '<leader>xw', '<CMD>TroubleToggle workspace_diagnostics<CR>', { desc = "Diagnósticos del workspace" })
map('n', '<leader>xd', '<CMD>TroubleToggle document_diagnostics<CR>', { desc = "Diagnósticos del documento" })

-----------------------
-- Autocomandos ------
-----------------------
-- Crear autocomandos
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Eliminar espacios en blanco al final de las líneas al guardar
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Resaltar texto copiado
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

print("Configuración de Neovim cargada correctamente")
