#!/bin/bash
# this file must be placed directly under the catkin workspace

# 2. read ssh configure file to figure out available server names
# keys of sed:
# 1. set does line-based operation (line-by-line)
# 2. set works on a copy of input file
#sed  -i -- "s/\${number}/$num/" ${SRCFILE}  

#nodetemplate=$(<${TEMPLATE})
template_array=()

function readTemplate() {
    i=0
    while read line # Read a line
    do
        template_array[i]=$line # Put it into the array
        i=$(($i + 1))
    done < $1
}

# NOTE: must have server_nodes array built before call this function
# Usage:
# writeLaunch NODESIDS
function writeLaunch(){
    # take array as argument
    declare -a argarray=("${!1}")
    nums=(`echo $argarray`)
    # get array length
    arr_len=${#nums[@]}
    # read template xml file
    readTemplate ${TEMPLATE}
    # write to launch file based on template
    echo "<launch>" >> ${CLIENTLAUNCH}
    for (( i=0; i<${arr_len}; i++ ));
    do
        for e in "${template_array[@]}"
        do
            elem=$e
            elem=${elem/"@"/${nums[$i]}}
            echo $elem >> ${CLIENTLAUNCH}
        done
    done
    echo "</launch>" >> ${CLIENTLAUNCH};

    #echo $nodetemplate >> ${XMLFILE}
}


