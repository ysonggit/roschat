#!/bin/bash
# this file must be placed directly under the catkin workspace
echo "|----------------------------|"
echo "| ROS Nodes Launcher         |"
echo "| Author: Yang Song          |"
echo "| Email: ysong.sc@gmail.com  |"
echo "|                (((         |"
echo "|               (. .)        |"
echo "|              (( v ))       |"
echo "|----------------m-m---------|"

# 1. source environment loader
# source devel/setup.bash

# 2. read ssh configure file to figure out available server names
host="eos"
echo " Connect to Server ${host} ... "
ssh $host '
cd catkin_ws

source devel/setup.bash

roslaunch roslistener listeners.launch
'

