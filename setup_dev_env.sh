#!/bin/bash
# ===================================================================================
#   Script de Instalación y Configuración de Entorno de Desarrollo para Arch Linux
#   Refactorizado por: Asistente de Programación
# ===================================================================================

# --- Configuración Inicial y Colores ---
# Salir inmediatamente si un comando falla
set -e

# Colores para una mejor legibilidad
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

# --- Funciones de Utilidad ---
log() {
  echo -e "\n${BLUE}>>> $1${NC}"
}

check_command() {
  command -v "$1" &>/dev/null
}

# --- Función Principal ---
main() {
  # Verificar que estamos en Arch Linux
  if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}Error: Este script está diseñado exclusivamente para Arch Linux.${NC}"
    exit 1
  fi

  # Determinar la ruta del repositorio de DotFiles
  local DOTFILES_DIR
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  log "Repositorio de DotFiles detectado en: $DOTFILES_DIR"

  # --- Orquestación de la Instalación ---
  install_packages
  setup_terminal_and_multiplexer "$DOTFILES_DIR"
  setup_symlinks "$DOTFILES_DIR"
  configure_shell
  setup_languages
  setup_neovim
  setup_docker

  log "${GREEN}¡Proceso completado con éxito!${NC}"
  echo -e "${YELLOW}IMPORTANTE: Reinicia tu terminal o cierra sesión y vuelve a iniciarla para aplicar todos los cambios.${NC}"
}

# --- Configuración de Terminal y Multiplexor ---

setup_terminal_and_multiplexer() {
  local dotfiles_repo_path="$1"
  log "Configurando Alacritty y Tmux..."

  # --- Alacritty ---
  local alacritty_config_source="$dotfiles_repo_path/.config/alacritty/alacritty.toml"
  local alacritty_config_target="$HOME/.config/alacritty/alacritty.toml"
  if [ -f "$alacritty_config_source" ]; then
    mkdir -p "$(dirname "$alacritty_config_target")"
    ln -sf "$alacritty_config_source" "$alacritty_config_target"
    echo -e "  ${GREEN}✓ Enlace simbólico para Alacritty creado.${NC}"
  else
    echo -e "  ${YELLOW}Advertencia: No se encontró alacritty.toml en tu repositorio. Omitiendo enlace.${NC}"
  fi

  # --- Tmux ---
  local tmux_config_source="$dotfiles_repo_path/.tmux.conf"
  local tmux_config_target="$HOME/.tmux.conf"
  if [ -f "$tmux_config_source" ]; then
    # Añadir la configuración de navegación con Neovim al archivo de tmux
    # Esto asegura que siempre esté presente, incluso si actualizas tu .tmux.conf
    local tmux_nav_config="\n# Habilitar navegación inteligente entre Neovim y tmux\nis_vim=\"ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\\\S+\\\\/)?g?(view|n?vim?x?)(diff)?$'\"\nbind-key -n 'C-h' if-shell \"\$is_vim\" 'send-keys C-h' 'select-pane -L'\nbind-key -n 'C-j' if-shell \"\$is_vim\" 'send-keys C-j' 'select-pane -D'\nbind-key -n 'C-k' if-shell \"\$is_vim\" 'send-keys C-k' 'select-pane -U'\nbind-key -n 'C-l' if-shell \"\$is_vim\" 'send-keys C-l' 'select-pane -R'"

    # Crear el enlace simbólico
    ln -sf "$tmux_config_source" "$tmux_config_target"

    # Añadir la configuración de navegación si no existe
    if ! grep -q "is_vim" "$tmux_config_target"; then
      echo -e "$tmux_nav_config" >>"$tmux_config_target"
      echo -e "  ${GREEN}✓ Configuración de navegación para Tmux añadida.${NC}"
    fi
    echo -e "  ${GREEN}✓ Enlace simbólico para Tmux creado.${NC}"
  else
    echo -e "  ${YELLOW}Advertencia: No se encontró .tmux.conf en tu repositorio. Omitiendo enlace.${NC}"
  fi
}

# --- Módulos de Instalación y Configuración ---

install_packages() {
  log "Actualizando sistema e instalando paquetes..."
  sudo pacman -Syu --noconfirm

  # Paquetes de los repositorios oficiales de Arch
  local pacman_packages=(
    git base-devel curl wget unzip neovim starship fzf ripgrep fd
    zoxide bat eza bottom lazygit tmux docker docker-compose rust
    man-db man-pages httpie jq htop pgcli mycli
    ffmpegthumbnailer unarchiver poppler
  )

  # Paquetes del AUR
  local aur_packages=(
    lazydocker ctop dive k9s go-yq yazi-fm
  )

  log "Instalando paquetes de Pacman..."
  sudo pacman -S --needed --noconfirm "${pacman_packages[@]}"

  # Instalar yay (AUR Helper) si no existe
  if ! check_command yay; then
    log "Instalando yay (gestor de AUR)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi

  log "Instalando paquetes de AUR con yay..."
  yay -S --needed --noconfirm "${aur_packages[@]}"
}

setup_symlinks() {
  local dotfiles_repo_path="$1"
  log "Creando enlaces simbólicos para las configuraciones (DotFiles)..."

  # Función interna para crear un enlace de forma segura
  create_symlink() {
    local source_path="$1"
    local target_path="$2"

    if [ ! -e "$source_path" ]; then
      echo -e "  ${YELLOW}Advertencia: El archivo de origen $source_path no existe. Omitiendo enlace.${NC}"
      return
    fi

    mkdir -p "$(dirname "$target_path")"
    if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
      echo -e "  ${YELLOW}Haciendo backup de $target_path existente...${NC}"
      mv "$target_path" "$target_path.bak.$(date +%F-%T)"
    fi

    rm -f "$target_path"
    ln -s "$source_path" "$target_path"
    echo -e "  ${GREEN}✓ Enlace creado: $source_path -> $target_path${NC}"
  }

  # Enlazar todas tus configuraciones
  create_symlink "$dotfiles_repo_path/.config/nvim" "$HOME/.config/nvim"
  create_symlink "$dotfiles_repo_path/.config/starship/starship.toml" "$HOME/.config/starship.toml"
  create_symlink "$dotfiles_repo_path/.config/yazi" "$HOME/.config/yazi"
  create_symlink "$dotfiles_repo_path/.tmux.conf" "$HOME/.tmux.conf"
  create_symlink "$dotfiles_repo_path/.bashrc" "$HOME/.bashrc"
  create_symlink "$dotfiles_repo_path/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
}

configure_shell() {
  log "Configurando el archivo .bashrc..."

  # Función para añadir una línea a .bashrc si no existe
  add_to_bashrc_if_missing() {
    local line_to_add="$1"
    local file="$HOME/.bashrc"
    if ! grep -qF -- "$line_to_add" "$file"; then
      echo -e "\n$line_to_add" >>"$file"
      echo -e "  ${GREEN}✓ Añadido a .bashrc: $line_to_add${NC}"
    else
      echo -e "  -> Ya existe en .bashrc: $line_to_add"
    fi
  }

  # Las configuraciones específicas del shell deben estar en tu .bashrc del repositorio
  # Aquí solo nos aseguramos de que las herramientas se inicialicen
  add_to_bashrc_if_missing '# Inicializar Starship'
  add_to_bashrc_if_missing 'eval "$(starship init bash)"'
  add_to_bashrc_if_missing '# Inicializar Zoxide'
  add_to_bashrc_if_missing 'eval "$(zoxide init bash)"'
  add_to_bashrc_if_missing '# Inicializar Mise'
  add_to_bashrc_if_missing 'eval "$(~/.local/bin/mise activate bash)"'
}

setup_languages() {
  log "Instalando Mise (gestor de versiones de lenguajes)..."
  if ! check_command mise; then
    curl https://mise.run | sh
  fi

  log "Instalando versiones de lenguajes con Mise (node, python, java)..."
  ~/.local/bin/mise install
}

setup_neovim() {
  log "Instalando plugins de Neovim (puede tardar varios minutos)..."
  # Usar --headless para que no se abra la UI, sincronizar plugins y salir
  nvim --headless "+Lazy! sync" +qa
  log "${GREEN}✓ Plugins de Neovim instalados y sincronizados.${NC}"
}

setup_docker() {
    log "Configurando Docker..."
    if check_command docker; then
        sudo systemctl enable docker
        sudo systemctl start docker
        if ! groups "$USER" | grep -q '\bdocker\b'; then
            log "Agregando el usuario $USER al grupo de Docker..."
            sudo usermod -aG docker "$USER"
            echo -e "  ${YELLOW}Necesitarás cerrar sesión y volver a iniciarla para usar Docker sin sudo.${NC}"
        else
            echo -e "  -> El usuario ya pertenece al grupo de Docker."
        fi
    fi
}

# --- Ejecutar Script ---
main
