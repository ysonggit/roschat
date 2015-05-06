#!/bin/bash
# Usage : 
# cleanClient CLIENTROSPACK
echo "1. clean zombie ros processes ... "
if [ -z "$(pgrep $1)" ]
then
    echo "no process $1 running"
else
    kill -9 $(pgrep $1)
fi
./removezombies.sh
echo "done"

echo "2. clean old client launch files ..."
for f in src/$1/client*; 
do 
   if [ -e "$f" ]; 
   then
       rm src/$1/client*	 
   fi
   break;	
done  
echo "done"

echo "ls ./src/$1"
ls src/$1
