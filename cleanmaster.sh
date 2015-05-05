#!/bin/bash
# Usage :
# startMaster MASTERROSPACK

if [ -z "$(pgrep $1)" ]
then
    echo "no process $1 running"
else
    kill -9 $(pgrep $1)
fi
./removezombies.sh
#### start master on localhost
# set environment loader
#source devel/setup.bash


