#!/bin/bash

# 1. Find the active player (Prioritize 'Playing', fallback to any)
# We get the player name (e.g., 'spotify' or 'firefox') to target commands specifically.
PLAYER=$(playerctl -a metadata --format '{{status}} {{playerName}}' 2>/dev/null | grep "^Playing" | head -n1 | awk '{print $2}')

# If nothing is playing, just grab the first available player
if [ -z "$PLAYER" ]; then
    PLAYER=$(playerctl -l 2>/dev/null | head -n1)
fi

# If absolutely no player is running, exit safely
if [ -z "$PLAYER" ]; then
    if [ "$1" == "status" ]; then
        echo '{"text": "No Media", "class": "inactive", "tooltip": "No player found"}'
    fi
    exit 0
fi

# 2. Handle the commands based on the argument passed
case "$1" in
    "status")
        STATUS=$(playerctl status -p "$PLAYER" 2>/dev/null)
        # Get title and truncate it to 30 chars
        TEXT=$(playerctl metadata -p "$PLAYER" --format '{{title}}' 2>/dev/null | cut -c 1-30)
        
        if [ -z "$TEXT" ]; then TEXT="Unknown"; fi

        if [[ "$STATUS" == "Playing" ]]; then
            echo "{\"text\": \"$TEXT\", \"class\": \"playing\", \"tooltip\": \"$PLAYER: Playing\"}"
        elif [[ "$STATUS" == "Paused" ]]; then
            echo "{\"text\": \"$TEXT\", \"class\": \"paused\", \"tooltip\": \"$PLAYER: Paused\"}"
        else
            echo '{"text": "", "class": "inactive", "tooltip": "Stopped"}'
        fi
        ;;
    "play-pause")
        playerctl -p "$PLAYER" play-pause
        ;;
    "next")
        playerctl -p "$PLAYER" next
        ;;
    "prev")
        playerctl -p "$PLAYER" previous
        ;;
esac