#!/bin/bash

# Custom setup
# For stationary PC at Nordic Semiconductors

# nRF Connect SDK Toolchain, always auto-loaded
# Picks the latest installed toolchain automatically
NCS_TOOLCHAIN=$(ls -dt "$HOME"/ncs/toolchains/*/ 2>/dev/null | head -n1)
NCS_TOOLCHAIN="${NCS_TOOLCHAIN%/}"
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
