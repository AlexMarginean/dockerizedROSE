#!/bin/bash

SUCCESFUL=1

#VERSION="$(cat /proc/cpuinfo | grep processor | wc -l)"
#OUT=$?
#if [ "$VERSION" == "8" ]; then
#	echo "Right number of cores!"
#else
#	SUCCESFUL=0
#	echo "Different number of cores! Our experiments where run on a 8 core machine"
#fi


VERSION="$(grep MemTotal /proc/meminfo | grep -o '[0-9][0-9]*')"
OUT=$?
if [ "$VERSION" -ge  6131850 ]; then
	echo "Right amount of RAM memory: " $VERSION " !"
else
	SUCCESFUL=0
	echo "Not enough RAM memory! You have just : " $VERSION " available!"
fi

exit $SUCCESFUL
