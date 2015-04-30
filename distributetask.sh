#!/bin/bash
echo "Bash Script"
declare -A servers
declare -A used_servers
servers[1]="eos"
servers[2]="broad"
# number of servers
n=${#servers[@]}

declare -A nodes
declare -A used_nodes
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
echo "Enter maximum number of nodes you want to run on this server, followed by [ENTER]:"
read num

declare -A server_nodes
nodes_count=0
servers_count=0
while [ $nodes_count -lt $total ]
do
    rest_nodes=$((${total}-${nodes_count}))
    rest_servers=$((${n}-${servers_count}))
    echo "There are $rest_nodes nodes to be assigned to $rest_servers servers"
    echo "Available servers: "
    for((i=1; i<=n; i++));
    do 
        if [ -z "${used_servers[$i]}" ]; # server not used yet -z : is zero 
        then 
            echo "$i : ${servers[$i]}"
        fi  
    done
    srvid=$((${servers_count}+1))
    server_nodes[$srvid]=""
    
    tasks_num=$(($rest_nodes>$num?$num:$rest_nodes))
    nodes_count=$(($nodes_count+$task_num))
    count=0
    for k in "${nodes[@]}"
    do
        if [ ${used_nodes[$k]} == "0" ];
        then
            used_nodes[$k]=1
            count=$(($count+1))
            server_nodes[$srvid]="${server_nodes[$srvid]}  $k"
            if [ $count == $num || $nodes_count == $total ];
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
    #### 
    
done
