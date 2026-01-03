#!/usr/bin/env fish

# 1. Handle Toggle (When clicked)
if contains "toggle" $argv
    set current (powerprofilesctl get)
    switch $current
        case "performance"
            powerprofilesctl set power-saver
        case "balanced"
            powerprofilesctl set performance
        case "power-saver"
            powerprofilesctl set balanced
        case "*"
            powerprofilesctl set balanced
    end
    
    # FORCE UPDATE: Tell Waybar to refresh this module immediately
    pkill -SIGRTMIN+8 waybar
    exit 0
end

# 2. Display Logic (When Waybar asks "what icon?")
set current (powerprofilesctl get)
switch $current
    case "performance"
        echo '{"text": "󰓅", "class": "performance", "tooltip": "Performance Mode"}'
    case "power-saver"
        echo '{"text": "", "class": "power-saver", "tooltip": "Power Saver Mode"}'
    case "balanced"
        echo '{"text": "󰗑", "class": "balanced", "tooltip": "Balanced Mode"}'
    case "*"
        echo '{"text": "󰗑", "class": "unknown", "tooltip": "Unknown Mode"}'
end
