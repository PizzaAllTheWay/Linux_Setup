#!/bin/bash

# Custom setup
# For stationary PC at Nordic Semiconductors

# nRF Connect SDK Toolchain, always auto-loaded
# Picks the latest installed toolchain automatically
NCS_TOOLCHAIN=$(ls -dt "$HOME"/ncs/toolchains/*/environment.json 2>/dev/null | head -n1)
NCS_TOOLCHAIN="${NCS_TOOLCHAIN%/environment.json}"
if [ -n "$NCS_TOOLCHAIN" ] && [ -f "$NCS_TOOLCHAIN/environment.json" ]; then
    eval "$(NCS_TC="$NCS_TOOLCHAIN" python3 -c "
import json, os
tc = os.environ['NCS_TC']
cfg = json.load(open(f'{tc}/environment.json'))
SKIP = {'LD_LIBRARY_PATH'}
for v in cfg['env_vars']:
    key = v['key']
    if key in SKIP:
        continue
    if v['type'] == 'string':
        print(f'export {key}=\"{v[\"value\"]}\"')
    elif v['type'] == 'relative_paths':
        paths = ':'.join(f'{tc}/{p}' for p in v['values'])
        if v.get('existing_value_treatment') == 'prepend_to':
            print(f'export {key}=\"{paths}:\${key}\"')
        else:
            print(f'export {key}=\"{paths}\"')
")"
fi

export EDITOR="cursor --wait"
export VISUAL="cursor --wait"

alias code="cursor"

export PATH="$HOME/.local/bin:$PATH"

ssh() {
  case "$1" in
    nordic-pc)
      ip=$(getent ahostsv4 masm-linux.nordicsemi.no | awk '{print $1}' | head -1)
      if [[ -z "$ip" ]]; then
        echo "Couldn't reach masm-linux — you're probably not on VPN. Try reconnecting to network or VPN."
        return 1
      fi
      shift
      command ssh "masm@$ip" "$@"
      ;;
    *)
      command ssh "$@"
      ;;
  esac
}

# Remote connect (RDP)
# NOTE: VPN must be ON (GlobalProtect) on the machine you connect FROM.
#
# One-time setup on the OFFICE PC (masm-linux — the machine you connect TO):
#   1. sudo apt install xrdp xorgxrdp dbus-x11
#   2. sudo ufw allow 3389/tcp          # if ufw is active
#   3. sudo adduser xrdp ssl-cert
#   4. sudo systemctl enable --now xrdp
#   5. Create ~/.xsession (fixes black screen on Ubuntu + GNOME):
#        #!/bin/sh
#        export GNOME_SHELL_SESSION_MODE=ubuntu
#        export XDG_CURRENT_DESKTOP=ubuntu:GNOME
#        export XDG_SESSION_TYPE=x11
#        unset DBUS_SESSION_BUS_ADDRESS
#        unset XDG_RUNTIME_DIR
#        exec dbus-run-session -- gnome-session
#      chmod +x ~/.xsession
#   6. sudo systemctl restart xrdp
#
# On THIS machine (client): sudo apt install freerdp2-x11
# Then run: remote_connect nordic-pc
# At the xrdp login screen, pick session type: Xorg
remote_connect() {
  case "$1" in
    nordic-pc)
      ip=$(getent ahostsv4 masm-linux.nordicsemi.no | awk '{print $1}' | head -1)
      xfreerdp /u:masm /v:"$ip" \
        /f +clipboard \
        /network:lan +async-update +async-input \
        /gfx +gfx-progressive +gfx-thin-client \
        /gdi:hw /kbd:0x00000414 \
        /compression-level:0 /bpp:16 /audio-mode:0 \
        -wallpaper -themes -menu-anims -fonts
      ;;
    *)
      echo "Usage: remote_connect nordic-pc"
      ;;
  esac
}
