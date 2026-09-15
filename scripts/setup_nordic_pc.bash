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
      ip=$(ping -c1 -W3 masm-linux.nordicsemi.no | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
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
# NOTE: VPN must be ON (GlobalProtect)
remote_connect() {
  case "$1" in
    nordic-pc)
      xfreerdp /u:masm /v:masm-linux.nordicsemi.no \
      /dynamic-resolution +clipboard /network:lan \
      /gfx +gfx-progressive +gfx-thin-client \
      /kbd:0x00000414 \
      /compression /jpeg /bpp:16 -wallpaper -themes -menu-anims
      ;;
    *)
      echo "Usage: remote_connect nordic-pc"
      ;;
  esac
}
