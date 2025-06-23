# DotFiles
Configuración para trabajar en diferentes ambientes

**Fecha de última actualización:** 2024-06-23

## Descripción

Este script automatiza la instalación y configuración de un conjunto completo de herramientas modernas para desarrollo web con contenedores. Configura automáticamente:

- Docker y Docker Compose
- Herramientas de terminal mejoradas (reemplazos para comandos estándar)
- Gestión de versiones de lenguajes (Python, Node.js, Java, Go)
- Utilidades para desarrollo web con Docker
- Configuración optimizada para productividad

## Características

- **Detección automática de distribución:** Funciona en Arch Linux, Debian/Ubuntu y otras distribuciones
- **Instalación garantizada de Docker:** Con configuración apropiada para cada distribución
- **Reemplazo inteligente de comandos:**
  - `ls` → `eza` (con iconos y colores)
  - `cat` → `bat` (con syntax highlighting)
  - `top` → `bottom` (interfaz moderna)
  - `cd` → navegación mejorada con aliases
  - y muchos más...
- **Herramientas Docker avanzadas:**
  - `lazydocker` (interfaz TUI para Docker)
  - Funciones útiles para Docker (`dbuild`, `dclean`, etc.)
  - Aliases intuitivos para comandos Docker
- **Gestor de versiones moderno:**
  - `mise` para gestionar Python, Node.js, Java, etc.
- **Herramientas de productividad:**
  - `yazi` (explorador de archivos moderno)
  - `zellij` (gestor de sesiones de terminal)
  - `starship` (prompt personalizable)
  - `fzf` (búsqueda difusa)
  - `lazygit` (gestión visual de Git)

## Uso

### Comandos Docker

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `d` | Alias para `docker` | `d ps` |
| `dc` | Alias para `docker-compose` | `dc up -d` |
| `dps` | Listar contenedores activos | `dps` |
| `di` | Listar imágenes de Docker | `di` |
| `dex [contenedor] [comando]` | Entrar a un contenedor con shell interactivo | `dex mysql` o `dex nginx /bin/sh` |
| `ld` | Iniciar LazyDocker (TUI) | `ld` |
| `dcu` | Levantar servicios de Docker Compose | `dcu` |
| `dcd` | Detener servicios de Docker Compose | `dcd` |
| `dcr` | Reiniciar servicios de Docker Compose | `dcr` |
| `dclogs` | Ver logs de Docker Compose | `dclogs` |
| `dprune` | Eliminar recursos no utilizados | `dprune` |
| `dclean` | Limpiar contenedores, imágenes, volúmenes y redes no utilizados | `dclean` |
| `dbuild [nombre] [dockerfile]` | Construir una imagen Docker y opcionalmente ejecutarla | `dbuild myapp` o `dbuild backend Dockerfile.backend` |
| `dcreate [nombre]` | Crear un archivo docker-compose.yml plantilla | `dcreate` o `dcreate docker-compose.dev.yml` |

### Navegación y Archivos

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `ls`, `l` | Listar archivos con iconos y colores | `ls` |
| `la` | Listar todos los archivos (incluyendo ocultos) | `la` |
| `ll` | Listar archivos en formato detallado | `ll` |
| `lt` | Listar archivos como estructura de árbol | `lt` |
| `l2`, `l3` | Listar árbol con profundidad de 2 o 3 niveles | `l2` o `l3` |
| `yi` o `fm` | Abrir Yazi (explorador de archivos moderno) | `yi` o `yi ~/proyectos` |
| `f "texto"` | Buscar archivos por nombre | `f "config"` |
| `s "texto"` | Buscar texto dentro de archivos (usa ripgrep) | `s "function main"` |
| `v archivo` | Ver archivo con syntax highlighting | `v app.js` |
| `o archivo` | Abrir archivo con el programa predeterminado | `o imagen.jpg` |
| `extract archivo` | Extraer cualquier archivo comprimido automáticamente | `extract backup.zip` |
| `mcd carpeta` | Crear directorio y entrar inmediatamente | `mcd nuevo-proyecto` |

### Terminal y Desarrollo

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `zj` o `z` | Iniciar Zellij (multiplexor de terminal) | `zj` |
| `tm` | Iniciar Zellij o tmux (el disponible) | `tm` |
| `lg` | Iniciar LazyGit (interfaz TUI para Git) | `lg` |
| `serve [puerto]` | Crear servidor web en directorio actual | `serve` o `serve 3000` |
| `sysinfo` | Mostrar información detallada del sistema | `sysinfo` |
| `weather` | Mostrar pronóstico del tiempo | `weather` |
| `monitor [proceso]` | Monitorizar un proceso | `monitor nginx` |
| `path` | Mostrar PATH en formato legible | `path` |
| `ipe` | Mostrar IP pública | `ipe` |
| `reload` | Recargar configuración de la terminal | `reload` |

### Git Mejorado

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `g` | Alias para `git` | `g status` |
| `gs` | Git status | `gs` |
| `ga` | Git add | `ga .` |
| `gc` | Git commit | `gc -m "Mensaje"` |
| `gp` | Git push | `gp` |
| `gl` | Git log | `gl` |
| `gd` | Git diff | `gd` |
| `lg` | LazyGit (TUI para Git) | `lg` |
| `gnew [rama]` | Crear y cambiar a nueva rama | `gnew feature/login` |
| `gundo` | Deshacer último commit (soft) | `gundo` |
| `github` | Abrir repo en navegador | `github` |

### Gestor de Versiones (mise)

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `mi` o `m` | Alias para `mise` | `mi list` |
| `mi install python@3.11` | Instalar versión de Python | `mi install python@3.11` |
| `mi use nodejs@18` | Usar versión de Node.js | `mi use nodejs@18` |
| `mi use --global java@17` | Configurar Java globalmente | `mi use --global java@17` |
| `mi plugins` | Listar plugins disponibles | `mi plugins` |
| `mi exec python@3.11 -- python script.py` | Ejecutar con versión específica | `mi exec python@3.11 -- python script.py` |

### Atajos y Utilidades

| Comando | Descripción | Ejemplo de uso |
|---------|-------------|----------------|
| `c` | Limpiar pantalla | `c` |
| `h` | Mostrar historial | `h` |
| `now` | Mostrar fecha y hora actual | `now` |
| `..` | Subir un directorio | `..` |
| `...` | Subir dos directorios | `...` |
| `~` | Ir al directorio home | `~` |
| `ports` | Listar puertos en uso | `ports` |
| `update` | Actualizar el sistema | `update` |

## Personalización

Puedes personalizar las siguientes configuraciones:

- **Starship prompt:** `~/.config/starship.toml`
- **Yazi file manager:** `~/.config/yazi/`
- **Aliases personalizados:** `~/.bash_aliases`
- **Funciones personalizadas:** `~/.bash_functions`

### Añadir tus propios alias

Para añadir más aliases personalizados:
```bash
echo 'alias micomando="comando personalizado"' >> ~/.bash_aliases
source ~/.bash_aliases
```

## Requisitos

- Linux (Arch, Debian, Ubuntu, u otras distribuciones)
- Acceso sudo
- Conexión a Internet

## Instalación

1. Descarga el script:
```bash
curl -O https://raw.githubusercontent.com/usuario/repo/main/ultimate_dev_setup.sh
