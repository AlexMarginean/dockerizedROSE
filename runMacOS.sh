#!/bin/bash

CurrentPath=$(pwd)

xhost +
export DISPLAY=:0.0

if [ "$1" == "eclipse" ]; then
	docker run -P --rm -e DISPLAY=192.168.59.3:0 -v $CurrentPath/exampleProject:/root -v $CurrentPath/.ssh:/root/.ssh -v $CurrentPath/eclipseConf/eclipse.ini:/home/eclipse/eclipse.ini development/rose /bin/sh -c 'eclipse'
else
	docker run -P  -t -i --rm -e DISPLAY=192.168.59.3:0 -v $CurrentPath/exampleProject:/root -v $CurrentPath/.ssh:/root/.ssh -v $CurrentPath/eclipseConf/eclipse.ini:/home/eclipse/eclipse.ini development/rose /bin/bash
fi
xhost -
