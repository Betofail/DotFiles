#!/bin/bash

# Ruta a la configuración de Hyprland
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
ACTIVE_WORKFLOW="$HOME/.config/hypr/active_workflow.conf"
WORKFLOW_DIR="$HOME/.config/hypr/workflows"

# Verificar argumentos
if [ $# -ne 1 ]; then
    echo "Uso: $0 <workflow>"
    echo "Workflows disponibles:"
    for file in "$WORKFLOW_DIR"/*.conf; do
        basename "$file" .conf
    done
    exit 1
fi

WORKFLOW="$1"
WORKFLOW_FILE="$WORKFLOW_DIR/$WORKFLOW.conf"

# Verificar que el archivo del workflow existe
if [ ! -f "$WORKFLOW_FILE" ]; then
    echo "El workflow '$WORKFLOW' no existe."
    exit 1
fi

# Crear enlace simbólico al workflow actual
ln -sf "$WORKFLOW_FILE" "$ACTIVE_WORKFLOW"

# Notificar al usuario
DESCRIPTION=$(grep 'WORKFLOW_DESCRIPTION' "$WORKFLOW_FILE" | cut -d '=' -f2- | tr -d '\n')
ICON=$(grep 'WORKFLOW_ICON' "$WORKFLOW_FILE" | cut -d '=' -f2- | tr -d '\n')

# Mostrar notificación si es posible
if command -v notify-send &> /dev/null; then
    notify-send "Workflow activado: $WORKFLOW" "$DESCRIPTION" -i "$ICON"
fi

# Recargar Hyprland para aplicar los cambios
hyprctl reload

echo "Workflow '$WORKFLOW' activado"
