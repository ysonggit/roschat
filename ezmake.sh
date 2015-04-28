#!/bin/sh
# this file must be placed directly under the catkin workspace
MYDIR="./src"

PKGS=`ls -l $MYDIR | egrep '^d' | awk '{print $9}'`

# "ls -l $MYDIR"      = get a directory listing
# "| egrep '^d'"           = pipe to egrep and select only the directories
# "awk '{print $8}'" = pipe the result from egrep to awk and print only the 8th field

SRCDIR="./build"
if [-d "${SRCDIR}" ]; then
    # and now loop through the directories:
    for DIR in $PKGS
    do
        EXE=`find ${SRCDIR}/${DIR} -type f -executable | awk '{print $1}'`
        TARGETDIR="${MYDIR}/${DIR}/"
        echo "cp ${EXE} ${TARGETDIR}"
        cp ${EXE} ${TARGETDIR} 
    done

fi
