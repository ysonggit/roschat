#!/bin/bash
source writelaunch.sh
# Useage:
# connect_server MASTERNAME CLIENTNAME
# NOTE: make sure to compile the ros program before run it 
# 1. connect to server using ssh
# 2. write launch file to run on that server based on template file
# 3. set ROS_MASTER to 
# 4. call roslaunch 
function connectServer(){
    master=$1
    host=$2
    echo " Connect to Server ${host} ... "
    ssh $host '
    cd catkin_ws

    export ROS_MASTER_URI=http://${master}:11311

    ./writelaunch.sh

    source devel/setup.bash

    roslaunch roslistener run.launch
    '
}