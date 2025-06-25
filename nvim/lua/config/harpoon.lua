local harpoon = require("harpoon")

-- Configuración básica
harpoon:setup()

-- Comandos y atajos
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Añadir archivo" })
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle menu" })

-- Navegación en ciclo
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon: Anterior" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon: Siguiente" })
