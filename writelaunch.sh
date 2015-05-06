#!/bin/bash
# this file must be placed directly under the catkin workspace
# Usage:
# writeLaunch NODESIDS 

clientname=$1
# take array as argument
IN="serverslist.$1"
# read template xml fil
template_array=()
TEMPFILE="template.launch"
i=0
while read line # Read a line
do
    template_array[i]=$line # Put it into the array
    i=$(($i + 1))
done < $TEMPFILE

LAUNCH="client${clientname}.launch"
# write to launch file based on template
echo "<launch>" >> ${LAUNCH}
#for (( i=0; i<${arr_len}; i++ ));
while read line
do
    for e in "${template_array[@]}"
    do
        elem=$e
        elem=${elem/"@"/$line}
        echo $elem >> ${LAUNCH}
    done
done < $IN
echo "</launch>" >> ${LAUNCH};

#source devel/setup.bash

sh -c "mv ${LAUNCH} src/roslistener/"

sh -c "roslaunch roslistener ${LAUNCH} &"



