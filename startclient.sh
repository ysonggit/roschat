#!/bin/bash

# $1 : MASTER host name
# $2 : Client host name
# $3 : Nodes ids
# $4 : Client ros package name
# $5 : Client ros launch file
# use double quotes after ssh
# otherwise, if single quotes, shell will interpolate $parameter before sending command to server
ssh $2 "
cd catkin_ws

export ROS_MASTER_URI=http://$1:11311

pwd

./cleanclient.sh $4 $5

source devel/setup.bash

source writelaunch.sh

writeLaunch $3 $4

cp $5 ./src/$4/$5

roslaunch $4 $5
"
