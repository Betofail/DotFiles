-- Keybinds para integrar Vim con Yazi
local function setup_yazi_integration()
  -- Abrir Yazi en el directorio actual
  vim.keymap.set("n", "<leader>e", function()
    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.expand("%:p:h")
    vim.cmd("silent !yazi " .. vim.fn.shellescape(current_dir))
  end, { desc = "Abrir Yazi en el directorio actual" })

  -- Abrir Yazi en el directorio raíz del proyecto
  vim.keymap.set("n", "<leader>yr", function()
    local root_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
      root_dir = vim.fn.getcwd()
    end
    vim.cmd("silent !yazi " .. vim.fn.shellescape(root_dir))
  end, { desc = "Abrir Yazi en la raíz del proyecto" })

  -- Abrir archivo en Neovim desde Yazi (añadir esto a tu configuración de Yazi)
  -- En tu archivo ~/.config/yazi/keymap.toml, agrega:
  -- e = ["shell", "nvim \"$YAZI_CURRENT_FILE\""]
end

return {
  setup = setup_yazi_integration,
}
