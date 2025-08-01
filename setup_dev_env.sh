#!/bin/bash
# ===================================================================================
#   Script de Instalación y Configuración de Entorno de Desarrollo para Arch Linux
#   Versión Final Validada
# ===================================================================================

# --- Configuración Inicial y Colores ---
set -e # Salir inmediatamente si un comando falla

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
  if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}Error: Este script está diseñado exclusivamente para Arch Linux.${NC}"
    exit 1
  fi

  local DOTFILES_DIR
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  log "Repositorio de DotFiles detectado en: $DOTFILES_DIR"

  install_packages
  setup_symlinks "$DOTFILES_DIR"
  configure_shell
  setup_languages
  setup_neovim
  setup_docker

  log "${GREEN}¡Proceso completado con éxito!${NC}"
  echo -e "${YELLOW}IMPORTANTE: Reinicia tu terminal o cierra sesión y vuelve a iniciarla para aplicar todos los cambios.${NC}"
}

# --- Módulos de Instalación y Configuración ---
install_packages() {
  log "Actualizando sistema e instalando paquetes..."
  sudo pacman -Syu --noconfirm

  local pacman_packages=(
    'git' 'base-devel' 'curl' 'wget' 'unzip' 'openssh' 'intel-ucode'
    'network-manager-applet' 'hyprland' 'waybar' 'sddm' 'kitty' 'wofi' 'dunst'
    'polkit-kde-agent' 'qt5-wayland' 'qt6-wayland' 'xdg-desktop-portal-hyprland'
    'grim' 'slurp' 'swayimg' 'brightnessctl' 'unclutter' 'pipewire'
    'pipewire-pulse' 'pipewire-alsa' 'wireplumber' 'neovim' 'tmux' 'starship'
    'ripgrep' 'fd' 'zoxide' 'bat' 'eza' 'bottom' 'lazygit' 'htop'
    'git-delta' 'docker' 'docker-compose' 'less' 'libnotify' 'pgcli' 'rustup'
    'go-yq' 'nodejs' 'npm' 'yarn' 'python-pytest' 'jdk-openjdk' 'kotlin'
    'elixir' 'ruby' 'lua51' 'luarocks' 'alacritty'
  )

  local aur_packages=(
    'lazydocker' 'ctop' 'dive' 'k9s' 'yazi-fm' 'mycli' 'fzf-git' )

  log "Instalando paquetes de Pacman..."
  sudo pacman -S --needed --noconfirm "${pacman_packages[@]}"

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

  # --- Enlazar todas tus configuraciones ---
  create_symlink "$dotfiles_repo_path/nvim" "$HOME/.config/nvim"
  create_symlink "$dotfiles_repo_path/starship/starship.toml" "$HOME/.config/starship.toml"
  create_symlink "$dotfiles_repo_path/yazi" "$HOME/.config/yazi"
  create_symlink "$dotfiles_repo_path/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  create_symlink "$dotfiles_repo_path/tmux/tmux.conf" "$HOME/.tmux.conf"
  create_symlink "$dotfiles_repo_path/bash/.bashrc" "$HOME/.bashrc"
  create_symlink "$dotfiles_repo_path/mise/config.toml" "$HOME/.config/mise/config.toml"

  # ... (La lógica para añadir la configuración de navegación de Tmux se mantiene igual) ...
  local tmux_config_target="$HOME/.tmux.conf"
  if [ -f "$tmux_config_target" ]; then
    local tmux_nav_config="\n# Habilitar navegación inteligente entre Neovim y tmux\nis_vim=\"ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\\\S+\\\\/)?g?(view|n?vim?x?)(diff)?$'\"\nbind-key -n 'C-h' if-shell \"\$is_vim\" 'send-keys C-h' 'select-pane -L'\nbind-key -n 'C-j' if-shell \"\$is_vim\" 'send-keys C-j' 'select-pane -D'\nbind-key -n 'C-k' if-shell \"\$is_vim\" 'send-keys C-k' 'select-pane -U'\nbind-key -n 'C-l' if-shell \"\$is_vim\" 'send-keys C-l' 'select-pane -R'"
    if ! grep -q "is_vim" "$tmux_config_target"; then
      echo -e "$tmux_nav_config" >>"$tmux_config_target"
      echo -e "  ${GREEN}✓ Configuración de navegación para Tmux-Neovim añadida.${NC}"
    fi
  fi
}

configure_shell() {
  log "Configurando el archivo .bashrc..."

  add_to_bashrc_if_missing() {
    local line_to_add="$1"
    local file="$HOME/.bashrc"
    if [ ! -L "$file" ] && ! grep -qF -- "$line_to_add" "$file"; then
      echo -e "\n$line_to_add" >>"$file"
      echo -e "  ${GREEN}✓ Añadido a .bashrc: $line_to_add${NC}"
    fi
  }

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

  log "Instalando versiones de lenguajes con Mise..."
  ~/.local/bin/mise install
}

setup_neovim() {
  log "Instalando plugins de Neovim (puede tardar varios minutos)..."
  nvim --headless "+Lazy! sync" +qa
  log "${GREEN}✓ Plugins de Neovim instalados y sincronizados.${NC}"
}

setup_docker() {
  log "Configurando Docker..."
  if check_command docker; then
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
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
