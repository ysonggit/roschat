#!/bin/bash
# Usage :
# startMaster MASTERROSPACK MASTERLAUNCH

if [ -z "$(pgrep $1)" ]
then
    echo "no process $1 running"
else
    kill -9 $(pgrep $1)
fi
./removezombies.sh
#### start master on localhost
echo "start node on localhost : http://${MASTER}:11311"
# set environment loader
source devel/setup.bash
roslaunch $1 $2

