#!/bin/bash

CurrentPath=$(pwd)

xhost +

if [ "$1" == "eclipse" ]; then
	sudo docker run -P --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $CurrentPath/exampleProject:/root -v $CurrentPath/.ssh:/root/.ssh development/rose /bin/sh -c 'eclipse'
else
	sudo docker run -P  -t -i --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $CurrentPath/exampleProject:/root -v $CurrentPath/.ssh:/root/.ssh development/rose /bin/bash
fi

xhost -

