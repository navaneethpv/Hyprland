#!/bin/bash

echo "intel" > "$HOME/.config/hypr/gpu/mode"
notify-send "GPU Mode" "Intel mode selected. Log out and log back in to apply."
