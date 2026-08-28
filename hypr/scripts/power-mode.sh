#!/bin/bash

LAST_STATE=""

while true; do
    AC_ONLINE=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n 1)

    if [ "$AC_ONLINE" = "1" ]; then
        STATE="AC"

        if [ "$LAST_STATE" != "$STATE" ]; then
            powerprofilesctl set balanced

            hyprctl eval 'hl.config({
                animations = {
                    enabled = true
                }
            })'

            LAST_STATE="$STATE"
        fi

    else
        STATE="BATTERY"

        if [ "$LAST_STATE" != "$STATE" ]; then
            powerprofilesctl set power-saver

            hyprctl eval 'hl.config({
                animations = {
                    enabled = false
                }
            })'

            LAST_STATE="$STATE"
        fi
    fi

    sleep 3
done
