local harpoon = require("harpoon")

-- Configuración básica
harpoon:setup()

-- Comandos y atajos
vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon: Añadir archivo" })
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle menu" })

-- Navegación entre archivos marcados
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Archivo 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Archivo 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Archivo 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Archivo 4" })

-- Navegación en ciclo
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon: Anterior" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon: Siguiente" })
