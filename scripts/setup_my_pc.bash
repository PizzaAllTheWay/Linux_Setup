#!/bin/bash

# Custom setup for bash
# This should be modified to each persons liking

# ROS 2 setup (START) ==================================================
# Load the ROS 2 Jazzy environment
source /opt/ros/jazzy/setup.bash

# Defines the ROS 2 communication domain (0 is default).
# Nodes must have the same domain ID to communicate
export ROS_DOMAIN_ID=0

# Enables automatic discovery of all ROS 2 nodes
# OFF: disables discovery (not recommended)
# LOCALHOST: limits to localhost
# SUBNET: communicates with all devices on your subnet
# LINK: limits to same network link only
export ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET
# ROS 2 setup (STOP) ==================================================



# Go Setup
export PATH=$PATH:/usr/local/go/bin



# D Language Setup
export PATH=~/dlang/dmd-2.109.1/linux/bin64:$PATH



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



# Remote connect (RDP)
# NOTE: VPN must be ON (GlobalProtect)
remote_connect() {
  case "$1" in
    nordic-pc)
      xfreerdp /u:masm /v:TURING-PC.nordicsemi.no \
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
