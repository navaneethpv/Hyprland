#!/bin/bash

# Leave fullscreen on the current window
hyprctl dispatch fullscreen 0

# Switch to the next window
hyprctl dispatch cyclenext

# Make the newly focused window fullscreen
hyprctl dispatch fullscreen 0
