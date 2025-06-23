#!/bin/bash
echo "Workflow recibido: $1" > $HOME/.cache/hyprland_workflow_test
notify-send "Hyprland Workflow" "Workflow recibido: $1"
