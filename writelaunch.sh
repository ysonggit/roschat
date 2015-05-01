#!/bin/bash
# this file must be placed directly under the catkin workspace
# Usage:
# writeLaunch NODESIDS 

# take array as argument
declare -a argarray=("${!1}")
nums=(`echo $argarray`)
# get array length
arr_len=${#nums[@]}

# read template xml fil
template_array=()
TEMPFILE="template.launch"
i=0
while read line # Read a line
do
    template_array[i]=$line # Put it into the array
    i=$(($i + 1))
done < $TEMPFILE

# write to launch file based on template
LAUNCH="client.launch"
if [ -f $LAUNCH ];
then
    rm $LAUNCH
fi

echo "<launch>" >> ${LAUNCH}
for (( i=0; i<${arr_len}; i++ ));
do
    for e in "${template_array[@]}"
    do
        elem=$e
        elem=${elem/"@"/${nums[$i]}}
        echo $elem >> ${LAUNCH}
    done
done
echo "</launch>" >> ${LAUNCH};

#echo $nodetemplate >> ${XMLFILE}



