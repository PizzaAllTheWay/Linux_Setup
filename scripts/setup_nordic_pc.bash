#!/bin/bash

# Custom setup
# For stationary PC at Nordic Semiconductors

# nRF Connect SDK Toolchain
NCS_TOOLCHAIN="$HOME/ncs/toolchains/43683a87ea"
if [ -f "$NCS_TOOLCHAIN/environment.json" ]; then
    eval "$(python3 -c "
import json, os
tc = '$NCS_TOOLCHAIN'
cfg = json.load(open(f'{tc}/environment.json'))
for v in cfg['env_vars']:
    if v['type'] == 'string':
        print(f'export {v[\"key\"]}=\"{v[\"value\"]}\"')
    elif v['type'] == 'relative_paths':
        paths = ':'.join(f'{tc}/{p}' for p in v['values'])
        if v.get('existing_value_treatment') == 'prepend_to':
            print(f'export {v[\"key\"]}=\"{paths}:\${v[\"key\"]}\"')
        else:
            print(f'export {v[\"key\"]}=\"{paths}\"')
")"
fi
