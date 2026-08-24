#!/usr/bin/env bash

# Clipboard Manager for Hyprland using cliphist and rofi
ROFI_THEME="$HOME/.config/rofi/theme.rasi"

# Handle arguments
case "$1" in
    --wipe|-w)
        cliphist wipe
        notify-send "Clipboard" "Clipboard history cleared" -i edit-clear -h string:x-canonical-private-synchronous:clipboard
        exit 0
        ;;
    --delete|-d)
        selected=$(cliphist list | rofi -dmenu -theme "$ROFI_THEME" -p "Delete Item" -me-select-entry "" -me-accept-entry "MousePrimary")
        if [ -n "$selected" ]; then
            printf '%s\n' "$selected" | cliphist delete
            notify-send "Clipboard" "Item deleted" -i edit-delete -h string:x-canonical-private-synchronous:clipboard
        fi
        exit 0
        ;;
esac

# Check for clipboard history
items=$(cliphist list)
if [ -z "$items" ]; then
    notify-send "Clipboard" "Clipboard history is empty" -i edit-paste -h string:x-canonical-private-synchronous:clipboard
    exit 0
fi

# Show clipboard history in rofi
selected=$(printf '%s\n' "$items" | rofi \
    -dmenu \
    -theme "$ROFI_THEME" \
    -p "Clipboard" \
    -kb-delete-entry "" \
    -kb-custom-1 "Alt+Delete,Shift+Delete" \
    -kb-custom-2 "Control+Delete" \
    -me-select-entry "" \
    -me-accept-entry "MousePrimary")

exit_code=$?

case "$exit_code" in
    0) # Enter / Single Click -> Copy to clipboard
        if [ -n "$selected" ]; then
            printf '%s\n' "$selected" | cliphist decode | wl-copy
        fi
        ;;
    10) # Custom 1 (Alt+Delete / Shift+Delete) -> Delete selected item
        if [ -n "$selected" ]; then
            printf '%s\n' "$selected" | cliphist delete
            notify-send "Clipboard" "Item deleted" -i edit-delete -h string:x-canonical-private-synchronous:clipboard
        fi
        ;;
    11) # Custom 2 (Ctrl+Delete) -> Wipe all history
        cliphist wipe
        notify-send "Clipboard" "Clipboard history cleared" -i edit-clear -h string:x-canonical-private-synchronous:clipboard
        ;;
    *) # Escape / Cancelled
        exit 0
        ;;
esac
