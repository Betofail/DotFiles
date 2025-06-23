#!/bin/bash

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
player=$(playerctl -l 2>/dev/null | head -n 1)

if [ -z "$player" ]; then
  # No hay reproductor
  icon=""
  artist="Nada"
  title="Reproduciendo"
else
  # Si no hay metadatos, mostrar vacíos amigables
  [ -z "$artist" ] && artist="Desconocido"
  [ -z "$title" ] && title="Sin título"

  # Cambia el icono según el reproductor
  case "$player" in
    *spotify*) icon="" ;;
    *mpd*) icon="" ;;
    *vlc*) icon="嗢" ;;
    *) icon="" ;;
  esac
fi

# Imprime un JSON válido
echo "{\"icon\": \"$icon\", \"artist\": \"$artist\", \"title\": \"$title\"}"
