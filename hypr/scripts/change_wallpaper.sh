#!/usr/bin/env bash

# Directories to search for wallpapers
WALLPAPER_DIRS=(
    "$HOME/.config/walpaper"
    "$HOME/Pictures/Wallpapers"
    "$HOME/Pictures/wallpapers"
    "$HOME/Pictures"
)

TARGET=""

if [ -n "$1" ] && [ -f "$1" ]; then
    TARGET="$(realpath "$1")"
else
    IMAGES=()
    for dir in "${WALLPAPER_DIRS[@]}"; do
        if [ -d "$dir" ] || [ -L "$dir" ]; then
            while IFS= read -r -d '' file; do
                filename=$(basename "$file")
                # Exclude avatars, lockscreens, or temp files
                if [[ "$filename" != "avatar."* ]] && [[ "$filename" != "current_wallpaper"* ]] && [[ "$filename" != "lockscreen."* ]]; then
                    real_file="$(realpath "$file")"
                    # Avoid duplicates
                    if [[ ! " ${IMAGES[*]} " =~ " ${real_file} " ]]; then
                        IMAGES+=("$real_file")
                    fi
                fi
            done < <(find -L "$dir" -maxdepth 2 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 2>/dev/null)
        fi
    done

    if [ ${#IMAGES[@]} -eq 0 ]; then
        echo "No wallpapers found in ${WALLPAPER_DIRS[*]}"
        exit 1
    fi

    CURRENT=""
    if [ -f "$HOME/.config/walpaper/current_wallpaper" ]; then
        CURRENT=$(cat "$HOME/.config/walpaper/current_wallpaper")
    fi

    if [ ${#IMAGES[@]} -gt 1 ]; then
        for _ in {1..20}; do
            CANDIDATE="${IMAGES[RANDOM % ${#IMAGES[@]}]}"
            if [ "$CANDIDATE" != "$CURRENT" ]; then
                TARGET="$CANDIDATE"
                break
            fi
        done
        [ -z "$TARGET" ] && TARGET="${IMAGES[0]}"
    else
        TARGET="${IMAGES[0]}"
    fi
fi

# Save current wallpaper path & symlink
mkdir -p "$HOME/.config/walpaper"
echo "$TARGET" > "$HOME/.config/walpaper/current_wallpaper"
cp -f "$TARGET" "$HOME/.config/walpaper/wallpaper.jpg"

# Apply wallpaper with hyprpaper
if command -v hyprctl >/dev/null 2>&1; then
    if ! pgrep -x hyprpaper >/dev/null 2>&1; then
        hyprpaper &
        sleep 0.2
    fi
    hyprctl hyprpaper wallpaper ",$TARGET" 2>/dev/null || true
fi

echo "Successfully applied wallpaper: $(basename "$TARGET")"
