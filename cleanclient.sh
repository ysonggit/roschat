#!/bin/bash
# Usage : 
# cleanClient CLIENTROSPACK CLIENTLAUNCH
function cleanClient(){
    if [ -z "$(pgrep $1)" ]
    then
        echo "no process $1 running"
    else
        kill -9 $(pgrep $1)
    fi
    ./removezombies.sh
    
}
