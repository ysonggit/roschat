#!/bin/bash

# $1 : MASTER host name
# $2 : Client host name
# $3 : Nodes ids
# $4 : Client ros package name

# use double quotes after ssh
# otherwise, if single quotes, shell will interpolate $parameter before sending command to server
ssh $2 "
cd catkin_ws

export ROS_MASTER_URI=http://$1:11311

pwd

source devel/setup.bash

./cleanclient.sh $4

./writelaunch.sh $3 $4
"
