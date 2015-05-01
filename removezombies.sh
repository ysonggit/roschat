#!/bin/bash
#### clear previous program
procs=("roslaunch", "rosmaster", "rosout")
for p in "${procs[@]}"
do
    if [ -z "$(pgrep $p)" ];
    then
        echo "process $p is not running"
    else
        kill -9 $(pgrep "$p")
    fi
done
