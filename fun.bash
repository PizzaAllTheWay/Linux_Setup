#!/bin/bash

# Check if the window is big enough to have pixel art on it
# If not just skip this file
min_width=140
cols=$(tput cols)
if [ "$cols" -lt "$min_width" ]; then
    return 0
fi

# Function to strip ANSI escape sequences for length calculations
strip_ansi() {
    sed 's/\x1B\[[0-9;]*[a-zA-Z]//g'
}

# Select a random .txt file from "Linux_Setup/pixelart" folder
folder="$HOME/Linux_Setup/pixelart/"
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
diag_lines+=("$(echo -e "\033[1;36m#==========# System Diagnostics #==========#\033[0m")")

# Pixel Art
pokemon_name=$(basename "$file" .txt)
diag_lines+=("$(echo -e "\033[1;31mPixel Art: \033[0m$pokemon_name")")

# System and Uptime
diag_lines+=("$(echo -e "\033[1;34mUptime:    \033[0m$(uptime -p)")")
distro=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
diag_lines+=("$(echo -e "\033[1;34mSystem:    \033[0mKernel: $(uname -s) $(uname -r) | Distro: $distro")")

# Network
interface=$(ip route | grep default | awk '{print $5}')
ip_addr=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
gateway=$(ip route | grep default | awk '{print $3}')
mac_addr=$(cat /sys/class/net/"$interface"/address)
dns_servers=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | paste -sd "," -)
diag_lines+=("$(echo -e "\033[1;35mNetwork:   \033[0mIF: $interface | IP: $ip_addr | GW: $gateway | MAC: $mac_addr | DNS: $dns_servers")")

# CPU and GPU Specs 
cpu_model=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
gpu_model=$(lspci | grep -i 'vga\|3d\|display' | head -1 | cut -d ':' -f3- | sed 's/^ *//')
diag_lines+=("$(echo -e "\033[1;32m\033[1mCPU:       \033[0m$cpu_model")")
diag_lines+=("$(echo -e "\033[1;32m\033[1mGPU:       \033[0m$gpu_model")")

# Battery
battery=$(upower -e | grep BAT | head -n1)
if [ -n "$battery" ]; then
    battery_info=$(upower -i "$battery" | grep -E 'state|percentage' | xargs)
    diag_lines+=("$(echo -e "\033[1;33mBattery:   \033[0m$battery_info")")
fi

# Combined CPU load, Memory, and Net load in one line
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1 "%"}')
mem_usage=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
mem_percent=$(free | awk '/Mem:/ {printf("%.2f%%", $3/$2 * 100)}')
rx_bytes=$(cat /sys/class/net/"$interface"/statistics/rx_bytes | numfmt --to=iec)
tx_bytes=$(cat /sys/class/net/"$interface"/statistics/tx_bytes | numfmt --to=iec)
diag_lines+=("$(echo -e "\033[1;33mLoad:      \033[0mCPU: $cpu_usage | Memory: $mem_usage ($mem_percent) | Net: RX: $rx_bytes, TX: $tx_bytes")")

# Add an empty line
diag_lines+=("$(echo -e "")")

# Define a rainbow palette with smooth RGB transitions
rainbow=(
  196 202 208 214 220 226   # Red to Yellow
  190 154 118 82 46         # Yellow to Green
  47 48 49 50 51            # Green to Cyan
  45 39 33 27 21            # Cyan to Blue
  57 93 129 165 201         # Blue to Magenta
  207 213 219 225           # Magenta to Pink/White (completes 30 colors)
)
palette_line=""
for code in "${rainbow[@]}"; do
    palette_line+=$(echo -ne "\033[38;5;${code}m█\033[0m")
done
diag_lines+=("$palette_line")

# Calculate max lines
max_lines=${#pixelart_lines[@]}
[ ${#diag_lines[@]} -gt $max_lines ] && max_lines=${#diag_lines[@]}

left_width=30

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

# Empty space for separation
echo ""