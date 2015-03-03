#!/bin/bash

CurrentPath=$(pwd)

#copy the ssh keys folder. we need to do this because a Dockerfile can add just files in the same root as the Dockerfile
sudo cp -r ~/.ssh ssh/

sudo docker build -t development/rose .
OUT=$?
echo "Docker returned: " $OUT

if [ $OUT -ne 0 ]; then
	echo "This try has failed!"
	exit 1
else
	sudo docker run -P -e --rm -v $CurrentPath/exampleProject:/root -v $CurrentPath/.ssh:/root/.ssh development/rose /bin/sh -c 'mkdir /root/development; cd /root/development; cd /root/development/exampleRoseProject; autoreconf -i; ./configure CPPFLAGS="-I/home/ROSE/RoseInstallTree/include/rose -I/home/ROSE/BoostInstallTree/include" LDFLAGS="-L/home/ROSE/RoseInstallTree/lib -L/home/ROSE/BoostInstallTree/lib -L/usr/lib/jdk1.8.0_25/jre/lib/amd64/server" CFLAGS="-O0 -g" CXXFLAGS="-O0 -g"; make; make check; echo SUCCES '
	exit 0
fi
