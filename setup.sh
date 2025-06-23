#!/bin/bash

APPS=(hyprland wofi waybar kitty neovim rofi dunst mako fastfetch)
CONFIGS=(hypr waybar wofi kitty nvim rofi dunst mako fastfetch)

install_apps() {
	if command -v pacman &> /dev/null; then
		sudo pacman -S --needed --noconfirm "${APPS[@]}"
	elif command -v apt &> /dev/null; then
		sudo apt update
		sudo apt install -y "${APPS[@]}"
	elif command -v dnf &> /dev/null; then
		sudo dnf install -y "${APPS[@]}"
	else
		echo "No se detecto un getor de paquetes soportado. Instala manualmente: ${APPS[*]}"
	fi
}

link_configs() {
	for config in "${CONFIGS[@]}"; do
		SRC="$(pwd)/$config"
		DEST="$HOME/.config/$config"
		if [ -d "$SRC" ]; then
			rm -rf "$DEST"
			ln -s "$SRC" "$DEST"
			echo "Symlink creado: $DEST -> $SRC"
		fi
	done
}

echo "instalando aplicaciones necesarias..."
install_apps

echo "creando symlinks de configuracion..."
link_configs

echo "Todo listo, los cambios realizados en los archivos se veran reflejados en ~/.config"
