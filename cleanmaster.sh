#!/bin/bash
# Usage :
# startMaster MASTERROSPACK
echo "1. clean zombie ros processes"
if [ -z "$(pgrep $1)" ]
then
    echo "no process $1 running"
else
    kill -9 $(pgrep $1)
fi
./removezombies.sh
echo "done"

# remove serverslist.*
echo "2. clean any servers list for writelaunch"
for f in serverslist.*; do
    if [ -e "$f" ]
    then
        rm "$f"
    fi
done
echo "done"

# set environment loader
source devel/setup.bash


