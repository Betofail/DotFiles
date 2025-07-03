# Guía de Atajos de Teclado de Neovim

Esta es una guía de referencia para todos los atajos de teclado configurados en este entorno de Neovim. La tecla `<leader>` está configurada como `Espacio`.

## 🗺️ Navegación Global

| Atajo               | Acción                                      |
| ------------------- | ------------------------------------------- |
| `<leader><leader>`  | Buscar archivos en el proyecto (Telescope)  |
| `<leader>fb`        | Buscar en los buffers abiertos (Telescope)  |
| `<leader>fg`        | Buscar texto en todo el proyecto (Grep)     |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Moverse entre ventanas y paneles de Tmux/Zellij |
| `<leader>sv`        | Dividir la ventana verticalmente            |
| `<leader>sh`        | Dividir la ventana horizontalmente          |
| `<leader>q`         | Cerrar el buffer actual                     |
| `<Esc>`             | Limpiar el resaltado de la última búsqueda  |

## ⚓ Harpoon (Marcadores de Archivos)

| Atajo         | Acción                                      |
| ------------- | ------------------------------------------- |
| `<leader>ha`  | Añadir el archivo actual a la lista Harpoon |
| `<leader>hm`  | Mostrar/ocultar el menú de Harpoon          |
| `<leader>1`   | Ir al archivo marcado como 1                |
| `<leader>2`   | Ir al archivo marcado como 2                |
| `<leader>3`   | Ir al archivo marcado como 3                |
| `<leader>4`   | Ir al archivo marcado como 4                |

## 🌳 Undotree (Historial de Cambios)

| Atajo       | Acción                          |
| ----------- | ------------------------------- |
| `<leader>u` | Abrir/Cerrar el árbol de cambios |

## 💻 LSP (Language Server Protocol)

Estos atajos funcionan cuando un servidor de lenguaje está activo para el tipo de archivo actual.

| Atajo          | Acción                                         |
| -------------- | ---------------------------------------------- |
| `gd`           | Ir a la **definición** de la variable/función  |
| `gD`           | Ir a la **declaración**                        |
| `gr`           | Mostrar todas las **referencias**              |
| `gi`           | Ir a la **implementación**                     |
| `K`            | Mostrar documentación (hover)                  |
| `<leader>ca`   | Mostrar **acciones de código** disponibles     |
| `<leader>rn`   | **Renombrar** la variable/función en todo el proyecto |
| `<leader>sd`   | Mostrar el **diagnóstico** (error/advertencia) de la línea |
| `]d`           | Ir al **siguiente diagnóstico** en el archivo  |
| `[d`           | Ir al **diagnóstico anterior** en el archivo   |

## 🚀 Autocompletado (nvim-cmp)

| Atajo       | Acción                                 |
| ----------- | -------------------------------------- |
| `<CR>`      | Confirmar la sugerencia seleccionada   |
| `<Tab>`     | Seleccionar la siguiente sugerencia    |
| `<S-Tab>`   | Seleccionar la sugerencia anterior     |
| `<C-Space>` | Activar el menú de autocompletado      |
| `<C-e>`     | Cerrar el menú de autocompletado       |
