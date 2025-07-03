#!/bin/bash

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Arch Linux Developer Toolkit ===${NC}"
echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Usuario: $USER"

# Crear directorio para guardar logs
mkdir -p ~/.devtools_setup
LOGFILE=~/.devtools_setup/install_log_$(date '+%Y%m%d_%H%M%S').log

# --- Funciones de Utilidad ---

# Función para imprimir mensajes formateados y guardarlos en el log
log() {
  echo -e "${BLUE}>>> $1${NC}"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>$LOGFILE
}

# Función para verificar si un comando está disponible
check_command() {
  if command -v $1 &>/dev/null; then
    echo -e "${GREEN}✓ $1 está instalado${NC}"
    return 0
  else
    echo -e "${RED}✗ $1 no está instalado${NC}"
    return 1
  fi
}

# --- Funciones de Limpieza ---

# Función para eliminar configuraciones de alias y funciones previas
remove_old_configs() {
  log "Eliminando configuraciones de shell previas (aliases, funciones, etc.)"

  # Eliminar archivos de configuración
  if [ -f ~/.bash_aliases ]; then
    rm ~/.bash_aliases
    echo -e "${GREEN}✓ Archivo ~/.bash_aliases eliminado.${NC}"
  fi

  if [ -f ~/.bash_functions ]; then
    rm ~/.bash_functions
    echo -e "${GREEN}✓ Archivo ~/.bash_functions eliminado.${NC}"
  fi

  if [ -f ~/.load_now ]; then
    rm ~/.load_now
    echo -e "${GREEN}✓ Archivo ~/.load_now eliminado.${NC}"
  fi

  # Limpiar .bashrc de las líneas que cargaban esos archivos
  if [ -f ~/.bashrc ]; then
    log "Limpiando ~/.bashrc..."
    # Usar sed para eliminar las líneas que contienen las cadenas específicas
    sed -i '/# Cargar aliases/d' ~/.bashrc
    sed -i '/if \[ -f ~\/\.bash_aliases \]; then/,/fi/d' ~/.bashrc
    sed -i '/\. ~\/\.bash_aliases/d' ~/.bashrc

    sed -i '/# Cargar funciones/d' ~/.bashrc
    sed -i '/if \[ -f ~\/\.bash_functions \]; then/,/fi/d' ~/.bashrc
    sed -i '/\. ~\/\.bash_functions/d' ~/.bashrc

    sed -i '/starship init/d' ~/.bashrc
    sed -i '/mise activate/d' ~/.bashrc
    sed -i '/FZF_DEFAULT_COMMAND/d' ~/.bashrc
    sed -i '/FZF_DEFAULT_OPTS/d' ~/.bashrc
    sed -i '/fzf\/key-bindings/d' ~/.bashrc
    sed -i '/fzf\/completion/d' ~/.bashrc
    echo -e "${GREEN}✓ Archivo ~/.bashrc limpiado de configuraciones previas.${NC}"
  fi

  log "Limpieza de configuraciones de shell completada."
}

# --- Funciones de Instalación y Configuración (Solo para Arch) ---

install_docker_arch() {
  log "Verificando Docker, Docker Compose y Docker Buildx"

  local packages_to_install=()
  check_command docker || packages_to_install+=("docker")
  check_command docker-compose || packages_to_install+=("docker-compose")
  check_command docker-buildx || packages_to_install+=("docker-buildx")

  if [ ${#packages_to_install[@]} -gt 0 ]; then
    log "Instalando paquetes de Docker: ${packages_to_install[*]}"
    sudo pacman -S --noconfirm "${packages_to_install[@]}"

    log "Iniciando y habilitando el servicio Docker"
    sudo systemctl start docker
    sudo systemctl enable docker

    log "Agregando usuario $USER al grupo docker"
    sudo usermod -aG docker $USER
    log "Es necesario cerrar sesión y volver a iniciarla para que los cambios de grupo tengan efecto."
  else
    log "Docker, Docker Compose y Docker Buildx ya están instalados."
  fi
}

install_cargo_arch() {
  log "Verificando Rust y Cargo"
  if check_command cargo; then
    log "Cargo ya está instalado."
  else
    log "Instalando Rust y Cargo"
    sudo pacman -S --noconfirm rust
  fi
}

install_yay() {
  if ! command -v yay &>/dev/null; then
    log "Instalando yay (gestor de AUR)"
    # Se necesita base-devel y git, nos aseguramos de que estén
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  else
    log "yay ya está instalado."
  fi
}

install_arch_tools() {
  log "Actualizando sistema"
  sudo pacman -Syu --noconfirm

  # Instalar dependencias base y herramientas esenciales desde repositorios oficiales
  log "Instalando herramientas esenciales desde repositorios oficiales"
  sudo pacman -S --needed --noconfirm \
    git curl wget unzip \
    man-db man-pages \
    neovim httpie jq htop \
    starship fzf \
    pgcli mycli \
    ffmpegthumbnailer unarchiver poppler fd ripgrep \
    zellij lazygit yazi-fm \
    bat bottom eza git-delta

  # Instalar herramientas desde AUR usando yay
  log "Instalando herramientas adicionales desde AUR"
  install_yay
  yay -S --needed --noconfirm lazydocker ctop dive k9s go-yq
}

install_mise() {
  log "Instalando mise (gestor de versiones de lenguajes)"
  if ! command -v mise &>/dev/null; then
    curl https://mise.run | sh
    log "Mise instalado. Añade 'eval \"\$(~/.local/bin/mise activate bash)\"' a tu .bashrc manualmente si lo necesitas."
  else
    log "mise ya está instalado."
  fi
}

configure_starship() {
  log "Configurando Starship para Bash"
  if ! command -v starship &>/dev/null; then
    log "Starship no está instalado. Omitiendo configuración."
    return
  fi

  # Añadir la inicialización de Starship a .bashrc si no existe
  if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc; then
    log "Agregando la inicialización de Starship a ~/.bashrc"
    echo -e '\n# Inicializar Starship para un prompt personalizado\neval "$(starship init bash)"' >>~/.bashrc
    echo -e "${GREEN}✓ Starship añadido a ~/.bashrc.${NC}"
  else
    log "Starship ya está configurado en ~/.bashrc."
  fi

  # Crear un archivo de configuración mínimo para Starship
  log "Creando archivo de configuración mínimo para Starship en ~/.config/starship.toml"
  mkdir -p ~/.config
  cat >~/.config/starship.toml <<'EOL'
# ~/.config/starship.toml

# Inserta una nueva línea entre los prompts para mayor claridad.
add_newline = true

# Reemplaza el símbolo de "❯" en el prompt por "➜".
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

# Desactiva el módulo de paquete de lenguaje (e.g., "via 📦 v1.0.0") para un prompt más limpio.
[package]
disabled = true
EOL
  echo -e "${GREEN}✓ Archivo de configuración ~/.config/starship.toml creado.${NC}"
}

# --- Función Principal ---

main() {
  # 1. Verificar que estamos en Arch Linux
  if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}Este script está diseñado para funcionar exclusivamente en Arch Linux.${NC}"
    echo -e "${RED}Saliendo...${NC}"
    exit 1
  fi

  log "Distribución Arch Linux confirmada."

  # 2. Eliminar configuraciones previas de alias y funciones
  remove_old_configs

  # 3. Instalar componentes clave
  log "Comenzando instalación de componentes..."
  install_docker_arch
  install_cargo_arch

  # 4. Instalar el resto de herramientas para Arch
  log "Instalando herramientas de desarrollo..."
  install_arch_tools

  # 5. Instalar mise
  install_mise

  # 6. Configurar Starship
  configure_starship

  # 7. Verificación final
  log "Validando la instalación de herramientas clave..."
  local tools_to_check=("docker" "docker-compose" "cargo" "nvim" "git" "eza" "bat" "yazi" "zellij" "lazygit" "lazydocker" "k9s" "mise" "starship")
  local errors=0
  echo -e "\n${BLUE}=== Verificación Final de Herramientas ===${NC}"
  for tool in "${tools_to_check[@]}"; do
    if ! check_command $tool; then
      ((errors++))
    fi
  done

  if [ $errors -gt 0 ]; then
    echo -e "\n${YELLOW}⚠ Se encontraron $errors problemas durante la instalación.${NC}"
    echo -e "${YELLOW}Revisa el log para más detalles: $LOGFILE${NC}"
  else
    echo -e "\n${GREEN}✓ Todas las herramientas clave fueron instaladas y verificadas.${NC}"
  fi

  echo -e "\n${GREEN}=====================================${NC}"
  echo -e "${GREEN}✓ ¡Proceso completado!${NC}"
  echo -e "${GREEN}=====================================${NC}"
  echo -e "${BLUE}→ Se han instalado y verificado las herramientas de desarrollo.${NC}"
  echo -e "${BLUE}→ Se ha configurado un prompt mínimo con Starship.${NC}"
  echo -e "${YELLOW}IMPORTANTE: Cierra sesión y vuelve a iniciarla para usar Docker sin sudo y ver el nuevo prompt.${NC}"
  log "Script finalizado."
}

# Ejecutar el script
main
