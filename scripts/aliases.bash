#!/bin/bash

# Handy aliases for terminal to make life better :)

# Superior version of "ls -la" command
: '
NOTE: To enable icons in eza:
      1. Install a Font that supports icons
          $ mkdir -p ~/.local/share/fonts
          $ cd ~/.local/share/fonts
          $ wget -O "Hack.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
          $ unzip Hack.zip -d Hack
          $ rm Hack.zip
          $ fc-cache -fv

      2. Right-click in the Terminator window → Preferences
      3. Under Profiles → General → disable "Use the system fixed width font"
      4. Select "Hack Nerd Font Mono" Font
      5. Close and reopen Terminator for changes to take effect
'
alias lz="eza \
  --group-directories-first \
  --sort=filename \
  --color=always \
  --color-scale=all \
  --color-scale-mode=gradient \
  -al -H -b -F --git --header --time-style=long-iso \
  --long --icons --tree --level=1"
export EXA_COLORS="da=38;5;67" # Custom BLUE Tint color for date and time when running "eza" commands

# Superior version of "cat" command
alias bat='batcat --paging=never'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert "Wakey Wakey"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Just a handy ssh to different static IPs
ssh() {
  case "$1" in
    babylon)
      command ssh babylon@babylon-server.tailcb6f53.ts.net
      ;;
    martynas)
      command ssh martynas@martynas-pc.tailcb6f53.ts.net
      ;;
    *)
      command ssh "$@"
      ;;
  esac
}

# RDP (Remote Desktop Protocol) to work PC
# NOTE: Requires Nordic internal VPN for this to work (Global Protect VPN)
rdpnordic() {
  RDP_USER="martynas.smilingis@nordicsemi.no"
  RDP_DOMAIN="NVLSI"
  RDP_HOST="10.250.15.112" # Internal IP of my machine after connecting to VPN (Global Protect VPN)
  rdesktop -u "$RDP_USER" -d "$RDP_DOMAIN" -g 90% -k no -p - "$RDP_HOST"
}
