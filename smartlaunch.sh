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

export ROSLAUNCH_SSH_UNKNOWN=1
# read ssh configure file to figure out available server names
# The format of ssh config is
# Host XXX
#      HostName XXX.cse.sc.edu
#      Port YYY
#      User ZZZ
INFILE="/acct/s1/song24/.ssh/config"
MASTER="eos"
MASTERLAUNCH="chat.launch"
MASTERROSPACK="rostalker"
# template.launch contains only the XML format definition of a ros node
TEMPLATE="template.launch"
CLIENTLAUNCH="client.launch"
CLIENTROSPACK="roslistener"

array=()
declare -A servers
# Usage
# getArray SOURCEFILE 
# Read the file in parameter and fill the array named "array"
function getArray() {
    i=0
    while read line # Read a line
    do
        array[i]=$line # Put it into the array
        i=$(($i + 1))
    done < $1
}

function printArray() {
    for e in  "${array[@]}"
    do
        echo "$e"
    done
}

function getServers(){
    getArray ${INFILE}
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
                     servers[$serveridx]=$word
                fi
            done
            serveridx=$(($serveridx+1))
        fi
        idx=$(($idx+1))
    done 
}

function printServers() {
    echo "--------------------------"
    echo " Available ROS Servers    "
    echo "--------------------------"
    echo " Id |       Name          "
    echo "--------------------------"
    for k in  "${!servers[@]}"
    do
        echo " $k ${servers[$k]}"
    done
}

# Useage:
# connect_server CLIENTNAME NODESIDS CLIENTROSPACK CLIENTLAUNCH
# NOTE: make sure to compile the ros program before run it 
# 1. connect to server using ssh
# 2. write launch file to run on that server based on template file
# 3. set ROS_MASTER to MASTER
# 4. call roslaunch 
function connectServer(){
    echo " Connect to Server $2 ... "
    nohup ./startclient.sh $1 $2 $3 $4 $5 &
}


declare -A used_servers
declare -A nodes
declare -A used_nodes
declare -A server_nodes

function distributeTasks(){
    # number of servers
    n=${#servers[@]}
    echo "Enter total number of nodes run on the server, followed by [ENTER]:"
    read total

    for((i=1; i<=${total}; i++));
    do
        nodes[$i]=$i
        used_nodes[$i]=0
    done

    verbose=false
    #### show initial arrays
    if [ $verbose == true ];
    then
        for j in "${nodes[@]}"
        do
            echo "$j"
            echo "used_nodes[$j] = ${used_nodes[$j]}" 
        done
    fi
    ####
    echo "Enter maximum number of nodes you want to run on each server, followed by [ENTER]:"
    read num

    nodes_count=0
    servers_count=0
    while [ $nodes_count -lt $total ]
    do
        rest_nodes=$((${total}-${nodes_count}))
        rest_servers=$((${n}-${servers_count}))
        echo "There are $rest_nodes nodes to be assigned to $rest_servers servers"
        if [ $verbose == true ];
        then
            echo "Available servers: "
            for((i=1; i<=n; i++));
            do
                if [ -z "${used_servers[$i]}" ]; # server not used yet -z : is zero 
                then
                    echo "$i : ${servers[$i]}"
                fi
            done
        fi
        srvid=$((${servers_count}+1))
        server_nodes[$srvid]=""
        tasks_num=$((${rest_nodes}>${num}?${num}:${rest_nodes}))
        nodes_count=$((${nodes_count} + ${tasks_num}))
        count=0
        for k in "${nodes[@]}"
        do
            if [ ${used_nodes[$k]} == "0" ];
            then
                used_nodes[$k]=1
                count=$(($count+1))
                server_nodes[$srvid]="${server_nodes[$srvid]}  $k"
                if [ $count == $num ];
                then
                    break;
                fi
                if [  $nodes_count == $total  ];
                then
                    break;
                fi
            fi
        done

        for snkey in "${!server_nodes[@]}"
        do
            printf "Server $snkey runs nodes : "
            for snval in "${server_nodes[$snkey]}"
            do
                printf "$snval  "
            done
            printf "\n"
        done

        #### debug info
        if [ $verbose == true ];
        then
            for((i=1; i<=total; i++));
            do
                echo "used_nodes[$i] = ${used_nodes[$i]}"
            done
        fi
        #####
    done
}

getServers
#printServers
distributeTasks
nohup ./startmaster.sh $MASTERROSPACK $MASTERLAUNCH &
for sid in "${!server_nodes[@]}"
do
    echo "start node on server : ${servers[$sid]}" 
    connectServer $MASTER "${servers[$sid]}" "${server_nodes[$sid]}" $CLIENTROSPACK $CLIENTLAUNCH
done
