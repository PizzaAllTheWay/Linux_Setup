#!/bin/bash
# Babylon MOTD: gradient banner + random quote + diagnostics

# --- 0) Small delay to let terminal settle ---
sleep 0.01

# --- 1) Require wide terminal; exit cleanly whether sourced or executed ---
min_width=140
cols=$(tput cols)
if [ "$cols" -lt "$min_width" ]; then
  if [ "${BASH_SOURCE[0]}" != "$0" ]; then return 0; else exit 0; fi
fi

# --- 2) Utils ---
# TrueColor per-character gradient (warm → teal → blue)
grad_tc() {
  awk '
    function esc(r,g,b){ return sprintf("\033[38;2;%d;%d;%dm", r,g,b) }
    function lerp(a,b,t){ return a+(b-a)*t }
    function sample(t,  k,u,r,g,b){
      split("0,0.45,0.75,1", pos, ",")
      R[1]=255; G[1]=140; B[1]=0;     # warm orange
      R[2]=230; G[2]=200; B[2]=76;    # yellow-green (warmer)
      R[3]=64;  G[3]=191; B[3]=191;   # teal
      R[4]=0;   G[4]=112; B[4]=221;   # blue
      for(k=1;k<4;k++) if (t<=pos[k+1]){
        u=(t-pos[k])/(pos[k+1]-pos[k]); if(u<0)u=0; if(u>1)u=1
        r=int(lerp(R[k],R[k+1],u)); g=int(lerp(G[k],G[k+1],u)); b=int(lerp(B[k],B[k+1],u))
        return esc(r,g,b)
      }
      return esc(R[4],G[4],B[4])
    }
    { n=length($0); out=""
      for(i=1;i<=n;i++){ t=(n<=1)?0:(i-1)/(n-1); out=out sample(t) substr($0,i,1) }
      print out "\033[0m"
    }'
}

# --- 3) Babylon banner (NO stray chars/blank line at top) ---
BABYLON_BANNER=$(cat <<'ART'
  /$$$$$$$   /$$$$$$  /$$$$$$$  /$$     /$$ /$$        /$$$$$$  /$$   /$$
 | $$__  $$ /$$__  $$| $$__  $$|  $$   /$$/| $$       /$$__  $$| $$$ | $$
 | $$  \ $$| $$  \ $$| $$  \ $$ \  $$ /$$/ | $$      | $$  \ $$| $$$$| $$
 | $$$$$$$ | $$$$$$$$| $$$$$$$   \  $$$$/  | $$      | $$  | $$| $$ $$ $$
 | $$__  $$| $$__  $$| $$__  $$   \  $$/   | $$      | $$  | $$| $$  $$$$
 | $$  \ $$| $$  | $$| $$  \ $$    | $$    | $$      | $$  | $$| $$\  $$$
 | $$$$$$$/| $$  | $$| $$$$$$$/    | $$    | $$$$$$$$|  $$$$$$/| $$ \  $$
 |_______/ |__/  |__/|_______/     |__/    |________/ \______/ |__/  \__/
ART
)

# --- 4) Quotes (keeps their own colors; one random *.txt) ---
quotes_folder="$HOME/Linux_Setup/fun/quotes/"
file=$(find "$quotes_folder" -type f -name "*.txt" | shuf -n 1)
quote_lines=()
if [ -n "$file" ]; then
  # printf '%b' interprets \033, \n, etc. in the files
  while IFS= read -r line; do
    quote_lines+=("$(printf '%b' "$line")")
  done < "$file"
else
  quote_lines+=("No .txt files found in $quotes_folder")
  file=""
fi

# --- 5) Diagnostics block ---
diagnostics_info=()
diagnostics_info+=("$(echo -e "\033[1;36m#==========# System Diagnostics #==========#\033[0m")")
diagnostics_info+=("$(echo -e "\033[1;31mQuote:     \033[0m$(basename "${file:-unknown}" .txt)")")

# System + uptime
diagnostics_info+=("$(echo -e "\033[1;34mUptime:    \033[0m$(uptime -p)")")
distro=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
diagnostics_info+=("$(echo -e "\033[1;34mSystem:    \033[0mKernel: $(uname -s) $(uname -r) | Distro: $distro")")

# Network
interface=$(ip route | awk "/default/{print \$5; exit}")
ip_addr=$(ip -4 addr show "$interface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
gateway=$(ip route | awk "/default/{print \$3; exit}")
mac_addr=$(cat /sys/class/net/"$interface"/address 2>/dev/null)
dns_servers=$(grep -h ^nameserver /etc/resolv.conf | awk '{print $2}' | paste -sd "," -)
diagnostics_info+=("$(echo -e "\033[1;35mNetwork:   \033[0mIF: $interface | IP: $ip_addr | GW: $gateway | MAC: $mac_addr | DNS: $dns_servers")")

# CPU/GPU
cpu_model=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
gpu_model=$(lspci | grep -i 'vga\|3d\|display' | head -1 | cut -d ':' -f3- | sed 's/^ *//')
diagnostics_info+=("$(echo -e "\033[1;32m\033[1mCPU:       \033[0m$cpu_model")")
diagnostics_info+=("$(echo -e "\033[1;32m\033[1mGPU:       \033[0m$gpu_model")")

# Battery (if present)
battery=$(upower -e 2>/dev/null | grep BAT | head -n1)
if [ -n "$battery" ]; then
  battery_info=$(upower -i "$battery" | grep -E 'state|percentage' | xargs)
  diagnostics_info+=("$(echo -e "\033[1;33mBattery:   \033[0m$battery_info")")
fi

# Load + memory + NIC counters
cpu_usage=$(top -bn1 | awk -F'[, ]+' '/Cpu\(s\)/{print 100-$8"%"}')
mem_usage=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
mem_percent=$(free | awk '/Mem:/ {printf("%.2f%%", $3/$2 * 100)}')
rx_bytes=$(cat /sys/class/net/"$interface"/statistics/rx_bytes 2>/dev/null | numfmt --to=iec)
tx_bytes=$(cat /sys/class/net/"$interface"/statistics/tx_bytes 2>/dev/null | numfmt --to=iec)
diagnostics_info+=("$(echo -e "\033[1;33mLoad:      \033[0mCPU: $cpu_usage | Memory: $mem_usage ($mem_percent) | Net: RX: $rx_bytes, TX: $tx_bytes")")
diagnostics_info+=("")

# --- 6) Render: Banner (gradient) → Quote (raw colors) → Diagnostics ---
printf "%s" "$BABYLON_BANNER" | grad_tc
echo ""
for line in "${quote_lines[@]}"; do printf '%b\n' "$line"; done
echo ""
for line in "${diagnostics_info[@]}"; do echo -e "$line"; done
echo ""
