#!/bin/bash
# this file must be placed directly under the catkin workspace

# 2. read ssh configure file to figure out available server names
# keys of sed:
# 1. set does line-based operation (line-by-line)
# 2. set works on a copy of input file
#sed  -i -- "s/\${number}/$num/" ${SRCFILE}  

# template.launch contains only the XML format definition of a ros node
TEMPLATE="template.launch"
XMLFILE="run.launch"
#nodetemplate=$(<${TEMPLATE})
template_array=()
function getArray() {
    i=0
    while read line # Read a line
    do
        template_array[i]=$line # Put it into the array
        i=$(($i + 1))
    done < $1
}

getArray ${TEMPLATE}

nums=(28 29 30)
# get array length
arr_len=${#nums[@]}
# write to launch file
echo "<launch>" >> ${XMLFILE}
for (( i=0; i<${arr_len}; i++ ));
do
    for e in "${template_array[@]}"
    do
        elem=$e
        elem=${elem/"#"/${nums[$i]}}
        echo $elem >> ${XMLFILE}
    done
done
echo "</launch>" >> ${XMLFILE};

#echo $nodetemplate >> ${XMLFILE}



