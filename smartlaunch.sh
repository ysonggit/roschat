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
    num=2
    echo "Each host runs maximum $num nodes"
    
    nodes_count=0
    servers_count=0
    srvid=1
    rest_nodes=$total
    rest_servers=$n
    while [ $nodes_count -lt $total ]
    do
        
        echo "Totally $rest_nodes nodes to be assigned to $rest_servers servers"
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
        
        server_nodes[$srvid]=""
        count=0
        for k in "${nodes[@]}"
        do
            echo "Assign task $k ... "
            if [ ${used_nodes[$k]} == "0" ];
            then
                used_nodes[$k]=1
                count=$(($count+1))
                server_nodes[$srvid]="${server_nodes[$srvid]} $k"
                nodes_count=$((${nodes_count} + 1))
                if [ $count == $num ];
                then
                    srvid=$((${srvid}+1))
                    servers_count=$((${servers_count}+1))
                    break;
                fi
                if [  $nodes_count == $total  ];
                then
                    srvid=$((${srvid}+1))
                    break;
                fi
            fi
        done
        rest_nodes=$((${total}-${nodes_count}))
        rest_servers=$((${n}-${servers_count}))
        
        for snkey in "${!server_nodes[@]}"
        do
            nodeslist=""
            printf "Server $snkey runs nodes : "
            for snval in "${server_nodes[$snkey]}"
            do
                nodeslist="$nodeslist $snval"
                printf "$snval "
            done
            printf "\n"
            echo "start node $nodesids on server : ${servers[$snkey]}"
            echo " Connect to Server ${servers[$snkey]} ... "
            ssh ${servers[$snkey]} "cd catkin_ws

            export ROS_MASTER_URI=http://$MASTER:11311

            source devel/setup.bash

            ./cleanclient.sh $CLIENTROSPACK

            ./writelaunch.sh ${servers[$snkey]} ${nodeslist}"
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

# for sid in "${!server_nodes[@]}"
# do
#     nodesids=""
#     for nd in "${server_nodes[$sid]}"
#     do
#         nodesids="${nodesids} $nid"
#     done
#     echo "start node $nodesids on server : ${servers[$sid]}"
#     echo " Connect to Server ${servers[$sid]} ... "
#     ssh ${servers[$sid]} "cd catkin_ws
#     export ROS_MASTER_URI=http://$MASTER:11311
#     source devel/setup.bash
#     ./cleanclient.sh $CLIENTROSPACK
#     ./writelaunch.sh ${servers[$sid]} $nodesids
#     "
#     #sh -c "./startclient.sh $MASTER ${servers[$sid]} ${server_nodes[$sid]} $CLIENTROSPACK"
# done

echo "start node on localhost : http://$MASTER:11311"
sh -c "./startmaster.sh $MASTERROSPACK $MASTERLAUNCH"
