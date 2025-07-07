-- ~/.config/nvim/lua/plugins/harpoon.lua
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- Atajos para Harpoon
    local map = vim.keymap.set
    map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Añadir archivo" })
    map("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon: Mostrar menú" })

    -- Salto rápido a archivos marcados
    map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Ir a archivo 1" })
    map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Ir a archivo 2" })
    map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Ir a archivo 3" })
    map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Ir a archivo 4" })
    map("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon: Ir a archivo 5" })
    map("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "Harpoon: Ir a archivo 6" })
  end,
}
