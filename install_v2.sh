#!/bin/bash

# Colores para una salida más clara
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# --- Variables de Configuración ---

# Directorio donde se encuentra este script (la raíz de tu repo de DotFiles)
# Esto hace que el script se pueda ejecutar desde cualquier lugar.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Directorio de origen de la configuración de Neovim (dentro de tus DotFiles)
SOURCE_NVIM_DIR="$DOTFILES_DIR/nvim"

# Directorio de destino estándar para la configuración de Neovim
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# --- Lógica del Script ---

echo -e "${BLUE}=== Configurando Neovim con Enlaces Simbólicos ===${NC}"

# 1. Verificar que la configuración de origen exista
if [ ! -d "$SOURCE_NVIM_DIR" ]; then
  echo -e "${RED}Error: El directorio de configuración de Neovim no se encontró en '$SOURCE_NVIM_DIR'${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Configuración de origen encontrada en: $SOURCE_NVIM_DIR${NC}"

# 2. Manejar la configuración existente en el destino
if [ -e "$NVIM_CONFIG_DIR" ]; then
  # Si ya es un enlace simbólico apuntando al lugar correcto, no hacer nada.
  if [ -L "$NVIM_CONFIG_DIR" ] && [ "$(readlink "$NVIM_CONFIG_DIR")" = "$SOURCE_NVIM_DIR" ]; then
    echo -e "${GREEN}✓ La configuración de Neovim ya está correctamente enlazada.${NC}"
    echo -e "${BLUE}¡No se necesita hacer nada! ✨${NC}"
    exit 0
  else
    # Si existe algo (un directorio o un enlace incorrecto), hacer una copia de seguridad.
    BACKUP_DIR="${NVIM_CONFIG_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}ℹ Se encontró una configuración de Neovim existente en '$NVIM_CONFIG_DIR'.${NC}"
    echo -e "${YELLOW}→ Se creará una copia de seguridad en: $BACKUP_DIR${NC}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}✓ Copia de seguridad creada con éxito.${NC}"
    else
      echo -e "${RED}Error: No se pudo crear la copia de seguridad. Abortando.${NC}"
      exit 1
    fi
  fi
fi

# 3. Crear el enlace simbólico
echo -e "${BLUE}→ Creando enlace simbólico desde '$SOURCE_NVIM_DIR' hacia '$NVIM_CONFIG_DIR'...${NC}"
# Asegurarse de que el directorio padre ~/.config exista
mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
ln -s "$SOURCE_NVIM_DIR" "$NVIM_CONFIG_DIR"

# 4. Verificación final
if [ -L "$NVIM_CONFIG_DIR" ] && [ "$(readlink "$NVIM_CONFIG_DIR")" = "$SOURCE_NVIM_DIR" ]; then
  echo -e "\n${GREEN}=====================================================${NC}"
  echo -e "${GREEN}✓ ¡Éxito! Tu configuración de Neovim ahora está gestionada por tus DotFiles.${NC}"
  echo -e "${GREEN}=====================================================${NC}"
  echo -e "Cualquier cambio en '$SOURCE_NVIM_DIR' se reflejará automáticamente."
else
  echo -e "\n${RED}Error: El enlace simbólico no se pudo crear correctamente. Por favor, revisa los permisos.${NC}"
  exit 1
fi
