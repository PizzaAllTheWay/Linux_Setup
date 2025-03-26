#!/bin/bash

# Custom setup for bash
# This should be modified to each persons liking

# ROS 2 setup (START) ==================================================
# Load the ROS 2 Jazzy environment
source /opt/ros/jazzy/setup.bash

# Defines the ROS 2 communication domain (0 is default).
# Nodes must have the same domain ID to communicate
export ROS_DOMAIN_ID=0 

# 0: Allows ROS 2 to communicate with other devices on the network
# 1: Restricts ROS 2 communication to the local machine only
export ROS_LOCALHOST_ONLY=0

# Enables automatic discovery of all ROS 2 nodes 
# within the same subnet, allowing multi-device communication
export ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET
# ROS 2 setup (STOP) ==================================================



# Go Setup
export PATH=$PATH:/usr/local/go/bin



# D Language Setup
export PATH=~/dlang/dmd-2.109.1/linux/bin64:$PATH