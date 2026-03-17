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



# RDP (Remote Desktop Protocol) to work PC
# NOTE: Requires Nordic internal VPN for this to work (Global Protect VPN)
rdpnordic() {
  RDP_USER="masm"
  RDP_DOMAIN="NVLSI"
  RDP_HOST="10.250.15.112" # Internal IP of my machine after connecting to VPN (Global Protect VPN)
  rdesktop -u "$RDP_USER" -d "$RDP_DOMAIN" -g 90% -a 16 -k no -p - "$RDP_HOST"
}
