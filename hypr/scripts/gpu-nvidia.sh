#!/bin/bash

echo "nvidia" > "$HOME/.config/hypr/gpu/mode"
notify-send "GPU Mode" "NVIDIA RTX 2050 mode selected. Log out and log back in to apply."
