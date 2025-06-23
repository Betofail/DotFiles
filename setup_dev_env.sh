#!/bin/bash

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Ultimate Developer Toolkit ===${NC}"
echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Usuario: $USER"

# Crear directorio para guardar logs
mkdir -p ~/.devtools_setup
LOGFILE=~/.devtools_setup/install_log_$(date '+%Y%m%d_%H%M%S').log

# Función para detectar la distribución
detect_distro() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "redhat"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo "Distribución detectada: $DISTRO"

# Función para imprimir mensajes formateados
log() {
    echo -e "${BLUE}>>> $1${NC}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOGFILE
}

# Función para verificar si un comando está disponible
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓ $1 está instalado${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 no está instalado${NC}"
        return 1
    fi
}

# Función para buscar un comando en ubicaciones alternativas
find_command() {
    local cmd=$1
    local alt_paths=("$HOME/.cargo/bin" "$HOME/.local/bin" "/usr/local/bin" "/opt/bin")
    
    # Comprobar si el comando está en el PATH
    if command -v $cmd &> /dev/null; then
        echo $(which $cmd)
        return 0
    fi
    
    # Buscar en rutas alternativas
    for path in "${alt_paths[@]}"; do
        if [ -f "$path/$cmd" ]; then
            echo "$path/$cmd"
            return 0
        fi
    done
    
    # Buscar nombres alternativos (común en algunas distros)
    local alt_names=()
    case $cmd in
        "bat") alt_names=("batcat") ;;
        "eza") alt_names=("exa") ;;
        "fd") alt_names=("fdfind") ;;
    esac
    
    for alt_name in "${alt_names[@]}"; do
        if command -v $alt_name &> /dev/null; then
            echo $(which $alt_name)
            return 0
        fi
    done
    
    echo ""
    return 1
}

# Función para instalar Docker y Docker Compose
install_docker() {
    log "Verificando Docker y Docker Compose"
    
    # Verificar si Docker ya está instalado
    if check_command docker; then
        log "Docker ya está instalado"
    else
        log "Instalando Docker"
        
        case $DISTRO in
            arch)
                sudo pacman -S --noconfirm docker
                ;;
            debian)
                # Instalar dependencias
                sudo apt update
                sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg
                
                # Agregar clave GPG oficial de Docker
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                
                # Configurar repositorio estable
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                
                # Actualizar e instalar Docker
                sudo apt update
                sudo apt install -y docker-ce docker-ce-cli containerd.io
                ;;
            redhat)
                sudo dnf -y install dnf-plugins-core
                sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
                sudo dnf install -y docker-ce docker-ce-cli containerd.io
                ;;
            *)
                # Instalación genérica con script oficial de Docker
                log "Usando script genérico de instalación de Docker"
                curl -fsSL https://get.docker.com -o get-docker.sh
                sudo sh get-docker.sh
                rm get-docker.sh
                ;;
        esac
        
        # Iniciar y habilitar el servicio Docker
        sudo systemctl start docker
        sudo systemctl enable docker
        
        # Agregar usuario actual al grupo docker
        sudo usermod -aG docker $USER
        log "Usuario $USER agregado al grupo docker. Es necesario cerrar sesión y volver a iniciarla para que los cambios de grupo tengan efecto."
    fi
    
    # Verificar si Docker Compose ya está instalado
    if check_command docker-compose; then
        log "Docker Compose ya está instalado"
    else
        log "Instalando Docker Compose"
        
        case $DISTRO in
            arch)
                sudo pacman -S --noconfirm docker-compose
                ;;
            debian)
                # Instalar Docker Compose como plugin de Docker
                DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
                mkdir -p $DOCKER_CONFIG/cli-plugins
                COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
                
                # Descargar para arquitectura x86_64 (cambiar si es necesario)
                sudo curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                
                # Crear enlace simbólico para Plugin Compose V2
                sudo ln -sf /usr/local/bin/docker-compose $DOCKER_CONFIG/cli-plugins/docker-compose
                ;;
            *)
                # Instalación genérica
                COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
                sudo curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                ;;
        esac
    fi
    
    # Verificar Docker Buildx
    if ! docker buildx version &>/dev/null; then
        log "Instalando Docker Buildx"
        case $DISTRO in
            arch)
                sudo pacman -S --noconfirm docker-buildx
                ;;
            *)
                # Instalación manual de Buildx
                mkdir -p ~/.docker/cli-plugins/
                BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep 'tag_name' | cut -d\" -f4)
                curl -SL "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o ~/.docker/cli-plugins/docker-buildx
                chmod +x ~/.docker/cli-plugins/docker-buildx
                ;;
        esac
    fi
    
    log "Verificando instalación de Docker"
    check_command docker
    check_command docker-compose
}

# Función para instalar Cargo (Rust)
install_cargo() {
    log "Verificando Rust y Cargo"
    
    # Verificar si Rust/Cargo ya están instalados
    if check_command cargo; then
        log "Cargo ya está instalado"
    else
        log "Instalando Rust y Cargo"
        
        case $DISTRO in
            arch)
                sudo pacman -S --noconfirm rust
                ;;
            debian)
                sudo apt update
                sudo apt install -y rustc cargo
                ;;
            redhat)
                sudo dnf install -y rust cargo
                ;;
            *)
                # Instalación genérica con rustup
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                # Actualizar PATH para la sesión actual
                source $HOME/.cargo/env
                ;;
        esac
    fi
    
    log "Verificando instalación de Cargo"
    check_command cargo
    
    # Añadir ~/.cargo/bin al PATH si no está ya
    if [ -d "$HOME/.cargo/bin" ]; then
        if ! grep -q "PATH.*cargo/bin" ~/.bashrc; then
            echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
        fi
        # Aplicar a la sesión actual
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
}

install_arch() {
    log "Actualizando sistema"
    sudo pacman -Syu --noconfirm

    # Asegurarse de que cargo está instalado primero
    install_cargo
    
    # Instalar Docker
    install_docker

    log "Instalando herramientas esenciales"
    sudo pacman -S --needed --noconfirm \
        base-devel git curl wget unzip \
        man-db man-pages \
        neovim httpie jq htop \
        starship fzf \
        pgcli mycli redis \
        ffmpegthumbnailer unarchiver poppler fd ripgrep

    # Verificar e instalar zellij
    if ! check_command zellij; then
        sudo pacman -S --needed --noconfirm zellij || cargo install --locked zellij
    fi

    # Verificar e instalar lazygit
    if ! check_command lazygit; then
        sudo pacman -S --needed --noconfirm lazygit
    fi

    # Verificar e instalar yazi
    if ! check_command yazi; then
        sudo pacman -S --needed --noconfirm yazi || cargo install --locked yazi-fm
    fi

    log "Instalando herramientas desde AUR"
    if ! command -v yay &> /dev/null; then
        log "Instalando yay"
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd - && rm -rf /tmp/yay
    fi

    log "Instalando herramientas adicionales desde AUR"
    yay -S --noconfirm lazydocker ctop dive k9s go-yq
}

install_debian() {
    log "Actualizando sistema"
    sudo apt update && sudo apt upgrade -y

    # Asegurarse de que cargo está instalado primero
    install_cargo
    
    # Instalar Docker
    install_docker

    log "Instalando herramientas esenciales"
    sudo apt install -y \
        build-essential git curl wget unzip \
        manpages manpages-dev man-db \
        neovim httpie jq htop \
        fzf tldr \
        postgresql-client mysql-client redis-tools \
        ffmpegthumbnailer unar jq poppler-utils fd-find ripgrep

    log "Instalando herramientas con Cargo"
    cargo install --locked yazi-fm eza bat bottom

    log "Instalando herramientas adicionales"
    # Starship
    curl -sS https://starship.rs/install.sh | sh

    # Zellij
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/zellij-org/zellij/master/install.sh | bash

    # LazyGit
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit

    # LazyDocker
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

    # Delta
    wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb
    sudo dpkg -i git-delta_0.16.5_amd64.deb
    rm git-delta_0.16.5_amd64.deb

    # Just
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

    # Dive
    wget https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb
    sudo apt install ./dive_0.10.0_linux_amd64.deb
    rm dive_0.10.0_linux_amd64.deb

    # Instalar K9s con snap
    sudo snap install k9s
}

install_mise() {
    log "Instalando mise (gestor de versiones de lenguajes)"
    curl https://mise.run | sh
    
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
    
    # Activar mise en la sesión actual
    if [ -f ~/.local/bin/mise ]; then
        eval "$(~/.local/bin/mise activate bash)"
        
        log "Instalando plugins para mise"
        ~/.local/bin/mise plugin install python
        ~/.local/bin/mise plugin install java
        ~/.local/bin/mise plugin install node
        ~/.local/bin/mise plugin install golang
        
        log "Puedes instalar versiones específicas con: mise install python@3.11"
    else
        log "ADVERTENCIA: mise no se instaló correctamente"
    fi
}

create_symbolic_links() {
    log "Creando enlaces simbólicos para comandos con nombres diferentes"
    
    # batcat -> bat (común en Debian/Ubuntu)
    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        log "Creando enlace simbólico: batcat -> bat"
        sudo ln -sf $(which batcat) /usr/local/bin/bat
    fi
    
    # fdfind -> fd (común en Debian/Ubuntu)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        log "Creando enlace simbólico: fdfind -> fd"
        sudo ln -sf $(which fdfind) /usr/local/bin/fd
    fi
    
    # exa -> eza (compatibilidad con versiones antiguas)
    if command -v exa &> /dev/null && ! command -v eza &> /dev/null; then
        log "Creando enlace simbólico: exa -> eza"
        sudo ln -sf $(which exa) /usr/local/bin/eza
    fi
}

update_path() {
    log "Actualizando PATH para incluir todas las ubicaciones de herramientas"
    
    # Añadir ~/.cargo/bin al PATH en .bashrc si no está ya
    if [ -d "$HOME/.cargo/bin" ]; then
        if ! grep -q "HOME/.cargo/bin" ~/.bashrc; then
            echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
        fi
        # Aplicar inmediatamente
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    
    # Añadir ~/.local/bin al PATH en .bashrc si no está ya
    if [ -d "$HOME/.local/bin" ]; then
        if ! grep -q "HOME/.local/bin" ~/.bashrc; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        fi
        # Aplicar inmediatamente
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

configure_tools() {
    log "Configurando Starship"
    if command -v starship &> /dev/null; then
        # Verificar si ya está en .bashrc
        if ! grep -q "starship init" ~/.bashrc; then
            echo 'eval "$(starship init bash)"' >> ~/.bashrc
        fi
        
        # Crear configuración básica para starship
        mkdir -p ~/.config/starship
        cat > ~/.config/starship.toml << 'EOL'
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$character"""

[directory]
style = "blue"
truncate_to_repo = true

[character]
success_symbol = "[➜](green)"
error_symbol = "[✗](red)"

[git_branch]
format = "[$branch]($style) "
style = "green"

[git_status]
format = '[$all_status$ahead_behind]($style) '
style = "yellow"

[cmd_duration]
format = "[$duration]($style) "
style = "yellow"
EOL
    else
        log "ADVERTENCIA: starship no está instalado, omitiendo configuración"
    fi

    log "Configurando Yazi"
    mkdir -p ~/.config/yazi
    cat > ~/.config/yazi/keymap.toml << 'EOL'
[manager]
prepend_keymap = [
  { on = [ "<esc>" ], run = "escape", desc = "Exit visual mode, clear selected, or cancel search" },
  { on = [ "q" ],     run = "quit", desc = "Exit the process" },
]
EOL

    log "Configurando Git con Delta"
    if command -v delta &> /dev/null; then
        git config --global core.pager "delta"
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global delta.light false

        # Configurar vim como editor por defecto para Git
        git config --global core.editor "vim"
    else
        log "ADVERTENCIA: delta no está instalado, omitiendo configuración de git delta"
    fi
    
    log "Configurando alias útiles"
    cat > ~/.bash_aliases << 'EOL'
# Sistema y navegación
alias ls='eza --icons --group-directories-first 2>/dev/null || exa --icons --group-directories-first 2>/dev/null || ls --color=auto'
alias l='eza -1 --icons --group-directories-first 2>/dev/null || exa -1 --icons --group-directories-first 2>/dev/null || ls -1 --color=auto'
alias la='eza -a --icons --group-directories-first 2>/dev/null || exa -a --icons --group-directories-first 2>/dev/null || ls -a --color=auto'
alias ll='eza -alh --icons --group-directories-first 2>/dev/null || exa -alh --icons --group-directories-first 2>/dev/null || ls -lah --color=auto'
alias lt='eza --tree --icons --group-directories-first 2>/dev/null || exa --tree --icons --group-directories-first 2>/dev/null || find . -type d | sort'
alias l2='eza --tree --level=2 --icons --group-directories-first 2>/dev/null || exa --tree --level=2 --icons --group-directories-first 2>/dev/null || find . -type d -maxdepth 2 | sort'
alias l3='eza --tree --level=3 --icons --group-directories-first 2>/dev/null || exa --tree --level=3 --icons --group-directories-first 2>/dev/null || find . -type d -maxdepth 3 | sort'

# Reemplazos para comandos estándar
alias cat='bat --style=plain --paging=never 2>/dev/null || batcat --style=plain --paging=never 2>/dev/null || cat'
alias less='bat --style=plain 2>/dev/null || batcat --style=plain 2>/dev/null || less'
alias more='bat --style=plain 2>/dev/null || batcat --style=plain 2>/dev/null || more'
alias grep='grep --color=auto'
alias diff='delta 2>/dev/null || diff --color=auto'
alias top='btm 2>/dev/null || bottom 2>/dev/null || top'
alias htop='btm 2>/dev/null || bottom 2>/dev/null || htop 2>/dev/null || top'
alias du='du -h'
alias df='df -h'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'
alias vim='nvim 2>/dev/null || vim'
alias vi='nvim 2>/dev/null || vim'

# Navegación rápida
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias ~='cd ~'

# Git mejorado
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias lg='lazygit 2>/dev/null || git status'

# Docker y contenedores
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dex='docker exec -it'
alias ld='lazydocker 2>/dev/null || docker ps'
alias k='kubectl 2>/dev/null || echo "kubectl no está instalado"'
alias kk='k9s 2>/dev/null || echo "k9s no está instalado"'

# Administrador de archivos y terminal
alias yi='yazi 2>/dev/null || echo "yazi no está instalado"'
alias fm='yazi 2>/dev/null || ranger 2>/dev/null || echo "No hay gestor de archivos disponible"'
alias files='yazi 2>/dev/null || ranger 2>/dev/null || echo "No hay gestor de archivos disponible"'
alias explorer='yazi 2>/dev/null || ranger 2>/dev/null || echo "No hay gestor de archivos disponible"'
alias zj='zellij 2>/dev/null || echo "zellij no está instalado"'
alias z='zellij 2>/dev/null || echo "zellij no está instalado"'
alias tm='zellij 2>/dev/null || tmux 2>/dev/null || screen 2>/dev/null || echo "No hay multiplexor de terminal disponible"'

# Utilidades
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %T"'
alias ports='sudo netstat -tulanp 2>/dev/null || sudo ss -tulpn 2>/dev/null || echo "No hay herramientas para listar puertos"'
alias weather='curl wttr.in'
alias c='clear'
alias h='history'
alias reload='source ~/.bashrc && echo "Bash config reloaded"'
alias update='sudo apt update && sudo apt upgrade -y || sudo pacman -Syu || echo "No se pudo actualizar"'
alias ip='ip -color'
alias ipe='curl ifconfig.me'

# Python
alias py='python'
alias python='python3'
alias pip='pip3'
alias venv='python -m venv venv'
alias activate='source venv/bin/activate'

# Docker adicionales
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dclogs='docker-compose logs -f'
alias dprune='docker system prune -a'

# Mise (gestor de versiones de lenguajes)
alias mi='mise 2>/dev/null || echo "mise no está instalado"'
alias m='mise 2>/dev/null || echo "mise no está instalado"'
EOL

    # Asegurarse que .bash_aliases se cargue desde .bashrc
    if ! grep -q "~/.bash_aliases" ~/.bashrc; then
        echo '
# Cargar aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi' >> ~/.bashrc
    fi

    # Funciones útiles
    cat > ~/.bash_functions << 'EOL'
# Crear un directorio y entrar a él
mcd() {
    mkdir -p "$1" && cd "$1"
}

# Extraer cualquier tipo de archivo comprimido
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Búsqueda rápida de archivos
f() {
    if command -v fd &> /dev/null; then
        fd "$1"
    elif command -v fdfind &> /dev/null; then
        fdfind "$1"
    else
        find . -name "*$1*"
    fi
}

# Búsqueda rápida en archivos
s() {
    if command -v rg &> /dev/null; then
        rg "$1"
    else
        grep -r "$1" .
    fi
}

# Abrir archivo con el programa predeterminado
o() {
    xdg-open "$1" &>/dev/null &
}

# Mostrar información detallada del sistema
sysinfo() {
    echo "HOSTNAME: $(hostname)"
    echo "KERNEL: $(uname -r)"
    echo "UPTIME: $(uptime -p)"
    echo "CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^[ \t]*//')"
    echo "MEMORY: $(free -h | grep Mem | awk '{print $3 " / " $2 " (" $3/$2*100 "%)"}')"
    echo "DISK: $(df -h / | tail -1 | awk '{print $3 " / " $2 " (" $5 ")"}')"
    echo "IP: $(hostname -I | awk '{print $1}')"
}

# Ver contenido de archivo con sintaxis destacada y paginación
v() {
    if command -v bat &> /dev/null; then
        bat --style=full "$1"
    elif command -v batcat &> /dev/null; then
        batcat --style=full "$1"
    else
        less "$1"
    fi
}

# Monitoreo rápido de un proceso
monitor() {
    watch -n 1 "ps aux | grep $1 | grep -v grep"
}

# Crear un servidor web rápido en el directorio actual
serve() {
    local port="${1:-8000}"
    python -m http.server "$port"
}

# Docker: entrar en un contenedor en ejecución
dsh() {
    docker exec -it "$1" /bin/sh -c "${2:-/bin/bash}"
}

# Docker: limpiar recursos no utilizados
dclean() {
    echo "Limpiando contenedores parados..."
    docker container prune -f
    echo "Limpiando imágenes no utilizadas..."
    docker image prune -f
    echo "Limpiando volúmenes no utilizados..."
    docker volume prune -f
    echo "Limpiando redes no utilizadas..."
    docker network prune -f
}

# Docker: construir y ejecutar un contenedor simple
dbuild() {
    local name="${1:-app}"
    local file="${2:-Dockerfile}"
    
    if [ ! -f "$file" ]; then
        echo "Error: Dockerfile '$file' no encontrado"
        return 1
    fi
    
    echo "Construyendo imagen '$name'..."
    docker build -t "$name" -f "$file" .
    
    echo "¿Deseas ejecutar el contenedor? (s/n)"
    read answer
    if [[ "$answer" == "s" || "$answer" == "S" ]]; then
        docker run -it --rm "$name"
    fi
}

# Docker Compose: Crear un archivo docker-compose.yml básico
dcreate() {
    local file="${1:-docker-compose.yml}"
    
    if [ -f "$file" ]; then
        echo "Error: El archivo '$file' ya existe"
        return 1
    fi
    
    cat > "$file" << 'DOCKER_COMPOSE'
version: '3.8'

services:
  app:
    build: .
    container_name: app
    restart: unless-stopped
    ports:
      - "8000:8000"
    volumes:
      - ./:/app
    environment:
      - NODE_ENV=development

  # Descomenta para agregar una base de datos
  # db:
  #   image: postgres:13
  #   container_name: db
  #   restart: unless-stopped
  #   ports:
  #     - "5432:5432"
  #   volumes:
  #     - db_data:/var/lib/postgresql/data
  #   environment:
  #     - POSTGRES_PASSWORD=postgres
  #     - POSTGRES_USER=postgres
  #     - POSTGRES_DB=app

# Descomenta para usar volúmenes
# volumes:
#   db_data:
DOCKER_COMPOSE
    
    echo "Archivo '$file' creado con éxito"
}

# Git: crear una rama nueva y cambiar a ella
gnew() {
    git checkout -b "$1"
}

# Git: deshacer último commit manteniendo los cambios
gundo() {
    git reset --soft HEAD~1
}

# Abrir en el navegador GitHub para el repositorio actual
github() {
    local remote="origin"
    [ -n "$1" ] && remote="$1"
    
    local url=$(git remote get-url "$remote" | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
    echo "Abriendo: $url"
    xdg-open "$url" &>/dev/null &
}
EOL

    # Asegurarse que .bash_functions se cargue desde .bashrc
    if ! grep -q "~/.bash_functions" ~/.bashrc; then
        echo '
# Cargar funciones
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi' >> ~/.bashrc
    fi

    # Configurar FZF key bindings y opciones
    cat >> ~/.bashrc << 'EOL'

# Configuración para FZF
export FZF_DEFAULT_COMMAND="fd --type file --color=always 2>/dev/null || find . -type file -not -path '*/\.git/*' 2>/dev/null"
export FZF_DEFAULT_OPTS="--ansi --height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || echo {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || echo {}'"
export FZF_ALT_C_COMMAND="fd --type directory 2>/dev/null || find . -type directory -not -path '*/\.git/*' 2>/dev/null"
export FZF_ALT_C_OPTS="--preview 'eza --tree {} 2>/dev/null || ls -la {} 2>/dev/null | head -200'"
EOL

    # Configurar FZF key bindings
    if [ -f /usr/share/fzf/key-bindings.bash ]; then
        echo 'source /usr/share/fzf/key-bindings.bash' >> ~/.bashrc
        echo 'source /usr/share/fzf/completion.bash' >> ~/.bashrc
    elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
        echo 'source /usr/share/doc/fzf/examples/key-bindings.bash' >> ~/.bashrc
        echo 'source /usr/share/doc/fzf/examples/completion.bash' >> ~/.bashrc
    fi
    
    # Crear archivo para cargar todo inmediatamente sin reiniciar la terminal
    cat > ~/.load_now << 'EOL'
#!/bin/bash

# Función para verificar si un comando está disponible
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "\033[0;32m✓ $1 está disponible\033[0m"
        return 0
    else
        echo -e "\033[0;31m✗ $1 no está disponible\033[0m"
        return 1
    fi
}

# Cargar todos los nuevos archivos y configuraciones
echo -e "\n\033[1;34m=== Cargando configuración ===\033[0m"

# Actualizar PATH
echo -e "\033[1;34m→ Actualizando PATH\033[0m"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Cargar aliases y funciones
echo -e "\033[1;34m→ Cargando aliases y funciones\033[0m"
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
    echo -e "\033[0;32m✓ Aliases cargados\033[0m"
else
    echo -e "\033[0;31m✗ No se encontró el archivo ~/.bash_aliases\033[0m"
fi

if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
    echo -e "\033[0;32m✓ Funciones cargadas\033[0m"
else
    echo -e "\033[0;31m✗ No se encontró el archivo ~/.bash_functions\033[0m"
fi

# Intentar cargar starship
echo -e "\033[1;34m→ Configurando Starship\033[0m"
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
    echo -e "\033[0;32m✓ Starship iniciado\033[0m"
else
    echo -e "\033[0;31m✗ Starship no está disponible\033[0m"
fi

# Intentar cargar mise
echo -e "\033[1;34m→ Configurando Mise\033[0m"
if [ -f ~/.local/bin/mise ]; then
    eval "$(~/.local/bin/mise activate bash)"
    echo -e "\033[0;32m✓ Mise iniciado\033[0m"
else
    echo -e "\033[0;31m✗ Mise no está disponible\033[0m"
fi

# Exportar variables FZF
echo -e "\033[1;34m→ Configurando FZF\033[0m"
export FZF_DEFAULT_COMMAND="fd --type file --color=always 2>/dev/null || find . -type f -not -path '*/\.git/*' 2>/dev/null"
export FZF_DEFAULT_OPTS="--ansi --height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || echo {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || echo {}'"
export FZF_ALT_C_COMMAND="fd --type directory 2>/dev/null || find . -type d -not -path '*/\.git/*' 2>/dev/null"
export FZF_ALT_C_OPTS="--preview 'ls -la --color=always {} 2>/dev/null | head -200'"

# Cargar completado y keybindings de FZF
for fzf_source in /usr/share/fzf/key-bindings.bash /usr/share/fzf/completion.bash /usr/share/doc/fzf/examples/key-bindings.bash /usr/share/doc/fzf/examples/completion.bash; do
    if [ -f "$fzf_source" ]; then
        source "$fzf_source"
        echo -e "\033[0;32m✓ FZF keybindings cargados desde $fzf_source\033[0m"
    fi
done

# Verificar herramientas esenciales
echo -e "\n\033[1;34m=== Verificando comandos ===\033[0m"
check_command docker
check_command docker-compose
check_command cargo
check_command eza || check_command exa
check_command bat || check_command batcat
check_command btm || check_command bottom
check_command yazi
check_command zellij
check_command lazygit
check_command fd || check_command fdfind

echo -e "\n\033[1;32m✓ Configuración cargada correctamente\033[0m"
echo -e "\033[1;34m→ Prueba algunos comandos nuevos: ls, ll, cat archivo, yi (yazi), lg (lazygit)\033[0m"
echo -e "\033[1;34m→ Prueba comandos de Docker: dps, dex, dclean, dbuild, dcreate\033[0m"
echo -e "\033[1;34m→ Utiliza 'reload' para recargar la configuración en cualquier momento\033[0m"
EOL

    chmod +x ~/.load_now

    # Crear un alias para recargar la configuración
    echo 'alias reload="source ~/.load_now"' >> ~/.bash_aliases
}

validate_installation() {
    log "Validando instalación..."
    
    # Lista de herramientas a validar
    local tools=("docker" "docker-compose" "cargo" "bat" "eza" "btm" "yazi" "zellij" "fd" "lazygit" "starship" "delta")
    local errors=0
    
    echo -e "\n${BLUE}=== Verificación de Herramientas ===${NC}"
    for tool in "${tools[@]}"; do
        local tool_path=$(find_command $tool)
        if [ -n "$tool_path" ]; then
            echo -e "${GREEN}✓ $tool: $tool_path${NC}"
        else
            echo -e "${RED}✗ $tool: No encontrado${NC}"
            # Sugerir instalación para herramientas faltantes
            case $tool in
                "docker")
                    echo -e "   Prueba: ${YELLOW}curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh${NC}"
                    ;;
                "docker-compose")
                    echo -e "   Prueba: ${YELLOW}sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose${NC}"
                    ;;
                "cargo")
                    echo -e "   Prueba: ${YELLOW}curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh${NC}"
                    ;;
                "bat")
                    echo -e "   Prueba: ${YELLOW}cargo install bat${NC}"
                    ;;
                "eza")
                    echo -e "   Prueba: ${YELLOW}cargo install eza${NC}"
                    ;;
                "btm")
                    echo -e "   Prueba: ${YELLOW}cargo install bottom${NC}"
                    ;;
                "yazi")
                    echo -e "   Prueba: ${YELLOW}cargo install --locked yazi-fm${NC}"
                    ;;
                "zellij")
                    echo -e "   Prueba: ${YELLOW}cargo install --locked zellij${NC}"
                    ;;
                "fd")
                    echo -e "   Prueba: ${YELLOW}cargo install fd-find${NC}"
                    ;;
                "lazygit")
                    echo -e "   Prueba: ${YELLOW}Instalación manual desde GitHub${NC}"
                    ;;
                "starship")
                    echo -e "   Prueba: ${YELLOW}curl -sS https://starship.rs/install.sh | sh${NC}"
                    ;;
                "delta")
                    echo -e "   Prueba: ${YELLOW}cargo install git-delta${NC}"
                    ;;
            esac
            ((errors++))
        fi
    done
    
    echo -e "\n${BLUE}=== Verificando PATH ===${NC}"
    if [ -d "$HOME/.cargo/bin" ]; then
        if [[ ":$PATH:" == *":$HOME/.cargo/bin:"* ]]; then
            echo -e "${GREEN}✓ ~/.cargo/bin está en PATH${NC}"
        else
            echo -e "${YELLOW}⚠ ~/.cargo/bin no está en PATH, añadiendo...${NC}"
            export PATH="$HOME/.cargo/bin:$PATH"
        fi
    fi
    
    if [ -d "$HOME/.local/bin" ]; then
        if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
            echo -e "${GREEN}✓ ~/.local/bin está en PATH${NC}"
        else
            echo -e "${YELLOW}⚠ ~/.local/bin no está en PATH, añadiendo...${NC}"
            export PATH="$HOME/.local/bin:$PATH"
        fi
    fi
    
    echo -e "\n${BLUE}=== Verificando Configuración ===${NC}"
    if [ -f ~/.bash_aliases ]; then
        echo -e "${GREEN}✓ ~/.bash_aliases existe${NC}"
        
        # Verificar si se carga desde .bashrc
        if grep -q "~/.bash_aliases" ~/.bashrc; then
            echo -e "${GREEN}✓ ~/.bash_aliases se carga desde ~/.bashrc${NC}"
        else
            echo -e "${YELLOW}⚠ ~/.bash_aliases no se carga desde ~/.bashrc${NC}"
        fi
    else
        echo -e "${RED}✗ ~/.bash_aliases no existe${NC}"
    fi

    # Verificar si el usuario puede ejecutar Docker sin sudo
    if command -v docker &> /dev/null; then
        if docker ps &>/dev/null; then
            echo -e "${GREEN}✓ El usuario puede ejecutar Docker sin sudo${NC}"
        else
            echo -e "${YELLOW}⚠ El usuario no puede ejecutar Docker sin sudo. Es necesario cerrar sesión y volver a iniciarla para que los cambios de grupo tengan efecto.${NC}"
        fi
    fi
    
    # Devolver resultado
    if [ $errors -gt 0 ]; then
        echo -e "\n${YELLOW}⚠ Se encontraron $errors problemas. Algunos comandos podrían no funcionar.${NC}"
        return 1
    else
        echo -e "\n${GREEN}✓ Todas las herramientas están instaladas correctamente.${NC}"
        return 0
    fi
}

fix_common_issues() {
    log "Corrigiendo problemas comunes..."
    
    # Asegurarse de que ~/.cargo/bin esté en el PATH
    if [ -d "$HOME/.cargo/bin" ]; then
        if ! grep -q 'export PATH="$HOME/.cargo/bin:$PATH"' ~/.bashrc; then
            echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
            echo -e "${GREEN}✓ Agregado ~/.cargo/bin al PATH${NC}"
        fi
    fi
    
    # Asegurarse de que ~/.local/bin esté en el PATH
    if [ -d "$HOME/.local/bin" ]; then
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo -e "${GREEN}✓ Agregado ~/.local/bin al PATH${NC}"
        fi
    fi
    
    # Crear Enlaces simbólicos
    create_symbolic_links
    
    # Cargar los aliases ahora
    if [ -f ~/.bash_aliases ]; then
        source ~/.bash_aliases
        echo -e "${GREEN}✓ Aliases cargados${NC}"
    fi
    
    # Cargar las funciones ahora
    if [ -f ~/.bash_functions ]; then
        source ~/.bash_functions
        echo -e "${GREEN}✓ Funciones cargadas${NC}"
    fi
}

manual_install_tools() {
    log "Instalando herramientas faltantes..."
    
    # Instalar cargo si falta
    if ! check_command cargo; then
        log "Instalando Rust y Cargo..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    # Verificar Docker
    if ! check_command docker; then
        log "Instalando Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        sudo usermod -aG docker $USER
    fi

    # Verificar Docker Compose
    if ! check_command docker-compose; then
        log "Instalando Docker Compose..."
        COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
        sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    
    # Lista para instalar con cargo
    local cargo_tools=()
    
    # Verificar herramientas
    check_command bat || check_command batcat || cargo_tools+=("bat")
    check_command eza || check_command exa || cargo_tools+=("eza")
    check_command btm || check_command bottom || cargo_tools+=("bottom")
    check_command yazi || cargo_tools+=("yazi-fm")
    check_command fd || check_command fdfind || cargo_tools+=("fd-find")
    check_command delta || cargo_tools+=("git-delta")
    
    # Si hay herramientas para instalar con cargo
    if [ ${#cargo_tools[@]} -gt 0 ] && command -v cargo &> /dev/null; then
        log "Instalando herramientas con cargo: ${cargo_tools[@]}"
        for tool in "${cargo_tools[@]}"; do
            echo -e "${BLUE}Instalando $tool...${NC}"
            cargo install --locked $tool
        done
    fi
    
    # Instalar starship si falta
    if ! check_command starship; then
        log "Instalando starship..."
        curl -sS https://starship.rs/install.sh | sh
    fi
    
    # Instalar zellij si falta
    if ! check_command zellij; then
        log "Instalando zellij..."
        if command -v cargo &> /dev/null; then
            cargo install --locked zellij
        else
            curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/zellij-org/zellij/master/install.sh | bash
        fi
    fi
    
    # Instalar lazygit si falta
    if ! check_command lazygit; then
        log "Instalando lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit.tar.gz lazygit
    fi
    
    # Crear enlaces simbólicos nuevamente después de instalar
    create_symbolic_links
}

main() {
    echo -e "\n${BLUE}=== Comenzando instalación de herramientas de desarrollo ===${NC}"
    
    # Instalar Docker primero
    install_docker
    
    # Instalar Cargo
    install_cargo
    
    case $DISTRO in
        arch)
            log "Instalando para Arch Linux"
            install_arch
            ;;
        debian)
            log "Instalando para Debian/Ubuntu"
            install_debian
            ;;
        *)
            echo -e "${RED}Distribución no soportada: $DISTRO${NC}"
            echo -e "${YELLOW}Continuando con instalación genérica...${NC}"
            manual_install_tools
            ;;
    esac
    
    # Actualizar PATH antes de seguir
    update_path
    
    # Instalar mise (mejor que asdf)
    install_mise
    
    # Crear enlaces simbólicos
    create_symbolic_links
    
    # Configuración de herramientas
    configure_tools
    
    # Validar instalación
    validate_installation
    
    # Corregir problemas comunes
    fix_common_issues
    
    # Instalar manualmente herramientas faltantes
    manual_install_tools
    
    # Hacer una validación final
    validate_installation
    
    # Cargar la nueva configuración
    log "Cargando la nueva configuración en la sesión actual..."
    if [ -f ~/.load_now ]; then
        chmod +x ~/.load_now
        source ~/.load_now
    fi
    
    log "¡Instalación completa!"
    log "Todos los comandos deberían estar disponibles ahora."
    log "Si experimentas algún problema, utiliza 'reload' para recargar la configuración."
    log "Log de instalación guardado en: $LOGFILE"
    
    echo -e "\n${GREEN}=====================================${NC}"
    echo -e "${GREEN}✓ ¡Instalación completa!${NC}"
    echo -e "${GREEN}=====================================${NC}"
    echo -e "${BLUE}→ Docker y Docker Compose han sido instalados${NC}"
    echo -e "${BLUE}→ Cargo (Rust) ha sido instalado para herramientas adicionales${NC}"
    echo -e "${BLUE}→ Los comandos estándar ahora usan versiones mejoradas${NC}"
    echo -e "${BLUE}→ Prueba 'ls', 'cat', 'top', etc.${NC}"
    echo -e "${BLUE}→ Prueba comandos de Docker: dps, dex, dclean, dbuild, dcreate${NC}"
    echo -e "${BLUE}→ Usa 'yi' para abrir Yazi (explorador de archivos)${NC}"
    echo -e "${BLUE}→ Usa 'lg' para abrir LazyGit${NC}"
    echo -e "${BLUE}→ Usa 'ld' para abrir LazyDocker${NC}"
    echo -e "\n${YELLOW}IMPORTANTE: Es posible que necesites cerrar sesión y volver a iniciarla para${NC}"
    echo -e "${YELLOW}          usar Docker sin sudo y que todos los cambios tengan efecto.${NC}"
}

# Ejecutar instalación
main
