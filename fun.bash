#!/bin/bash

# Function to strip ANSI escape sequences for length calculations
strip_ansi() {
    sed 's/\x1B\[[0-9;]*[a-zA-Z]//g'
}

# Select a random .txt file from "Linux_Setup/pixelart" folder
folder="Linux_Setup/pixelart"
file=$(find "$folder" -type f -name "*.txt" | shuf -n 1)

# Capture pixel art lines
pixelart_lines=()
if [ -n "$file" ]; then
    while IFS= read -r line; do
        pixelart_lines+=("$(echo -e "$line")")
    done < "$file"
else
    pixelart_lines+=("No .txt files found in $folder T_T")
fi

# Collect diagnostics into an array
diag_lines=()

# Diagnostics header
diag_lines+=("$(echo -e "\033[1;36m--- System Diagnostics ---\033[0m")")

# Pokémon name in red
pokemon_name=$(basename "$file" .txt)
diag_lines+=("$(echo -e "\033[1;31mPixel Art: \033[0m$pokemon_name")")

# Battery in yellow
battery=$(upower -e | grep BAT | head -n1)
if [ -n "$battery" ]; then
    battery_info=$(upower -i "$battery" | grep -E 'state|percentage' | xargs)
    diag_lines+=("$(echo -e "\033[1;33mBattery:   \033[0m$battery_info")")
fi

# OS & Uptime in blue
diag_lines+=("$(echo -e "\033[1;34mUptime:    \033[0m$(uptime -p)")")
diag_lines+=("$(echo -e "\033[1;34mOS:        \033[0m$(uname -o) ($(uname -r))")")

# Network in magenta
interface=$(ip route | grep default | awk '{print $5}')
ip_addr=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
gateway=$(ip route | grep default | awk '{print $3}')
mac_addr=$(cat /sys/class/net/"$interface"/address)
dns_servers=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | paste -sd "," -)
diag_lines+=("$(echo -e "\033[1;35mNetwork:   \033[0mIF: $interface | IP: $ip_addr | GW: $gateway | MAC: $mac_addr | DNS: $dns_servers")")

# CPU, GPU, Memory in bold green
cpu_model=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
gpu_model=$(lspci | grep -i 'vga\|3d\|display' | head -1 | cut -d ':' -f3- | sed 's/^ *//')
mem_info=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
diag_lines+=("$(echo -e "\033[1;32m\033[1mCPU:       \033[0m$cpu_model")")
diag_lines+=("$(echo -e "\033[1;32m\033[1mGPU:       \033[0m$gpu_model")")
diag_lines+=("$(echo -e "\033[1;32m\033[1mMemory:    \033[0m$mem_info")")

# Calculate max lines
max_lines=${#pixelart_lines[@]}
[ ${#diag_lines[@]} -gt $max_lines ] && max_lines=${#diag_lines[@]}

left_width=5

# Print side-by-side with proper padding
for ((i = 0; i < max_lines; i++)); do
    left_line="${pixelart_lines[i]}"
    right_line="${diag_lines[i]}"
    # Get visible length by stripping ANSI codes
    visible_left=$(echo -e "$left_line" | strip_ansi)
    pad_length=$(( left_width - ${#visible_left} ))
    [ $pad_length -lt 0 ] && pad_length=0
    pad=$(printf "%*s" $pad_length "")
    printf "%s%s  %s\n" "$left_line" "$pad" "$right_line"
done
