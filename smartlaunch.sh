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
INFILE="/acct/s1/song24/.ssh/config"
array=()
servers=()
# Read the file in parameter and fill the array named "array"
getArray() {
    i=0
    while read line # Read a line
    do
        array[i]=$line # Put it into the array
        i=$(($i + 1))
    done < $1
}

printArray() {
    for e in  "${array[@]}"
    do
        echo "$e"
    done
}

getServers(){
    idx=0;
    rem=0;
    serveridx=1;
    for eachline in "${array[@]}"
    do
        rem=$(($idx%4))
        if [ "$rem" -eq 0 ]
        then
            #printf "%s\n" "${lines[$idx]}"
            words=$(echo $eachline | tr ' ' '\n')
            for word in $words
            do
                if [ "$word" != "Host" ]
                then
                     servers[serveridx]=$word
                fi
            done
            serveridx=$(($serveridx+1))
        fi
        idx=$(($idx+1))
    done 
}

printServers() {
    id=1
    for e in  "${servers[@]}"
    do
        echo " ${id}    $e"
        id=$(($id+1))
    done
}

echo "--------------------------"
echo " Available ROS Servers    "
echo "--------------------------"
echo " Id |       Name          "
echo "--------------------------"
getArray ${INFILE}
getServers
printServers

echo "Enter the server id, followed by [ENTER]: "
read srvid

