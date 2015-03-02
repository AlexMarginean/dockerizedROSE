#!/bin/bash

OS=$(uname -a | head -n1 | awk '{print $1;}')

echo "Your operating system is:" $OS ". If this is not correct, run ./dockerizeRetypeLinux.sh for linux and ./dockerizeRetypeMacOS.sh for mac os x."

read -p "Do you want to continue with the curent selection? (y/n)"

if [ $REPLY == "n" ]; then
	echo "Exiting..."
	exit 1
fi

if [ $OS == "Linux" ]; then
	echo "The operating system is a linux distro... building native containers"
	echo "Testing your hardware configurations for building ROSE..."
	
	./checkLinux.sh
	OUT=$?
	
	if [ $OUT -eq 1 ];then
   		echo "You meet the hardware configs for building ROSE! The process will start right now ..."
		TRIES=3
		RETURN_CODE=1
		
		while [ "$RETURN_CODE" -ne 0 ] && [ "$TRIES" -ge 0 ]
		do
			./dockerizeRetypeLinux.sh
			RETURN_CODE=$?
			TRIES=$(( $TRIES - 1 ))
		done

		if [ "$RETURN_CODE" -eq 0 ]; then
			echo "You have successfully built ROSE! Use the script ./run.sh for running it with eclipse as IDE!"
			cp runLinux.sh run.sh
			exit 0
		else
			echo "An error oquired during the build process! Contact us for further details."
			exit 1
		fi
	else
   		echo "You are missing some dependendencies! Results may be affected."
   		read -p "Do you still want to continue? (y/n)?"
   		if [ $REPLY == "n" ]; then
			echo "Exiting..."
			exit 1
   		fi
	fi


elif [$OS == "Darwin" ]; then
	echo "The operating system is mac os x... building in boot2docker... be sure that you are running this for boot2docker"

	./checkMacOS.sh
	OUT=$?
	
	if [ $OUT -eq 1 ];then
   		echo "You meet the hardware configs for building ROSE! The process will start right now ..."
		TRIES=3
		RETURN_CODE=1
		
		while [ "$RETURN_CODE" -ne 0 ] && [ "$TRIES" -ge 0 ]
		do
			./dockerizeRetypeMacOS.sh
			RETURN_CODE=$?
			TRIES=$(( $TRIES - 1 ))
		done

		if [ "$RETURN_CODE" -eq 0 ]; then
			echo "You have successfully built ROSE! Use the script ./run.sh for running it with eclipse as IDE!"
			cp runMacOS.sh run.sh
			exit 0
		else
			echo "An error oquired during the build process! Contact us for further details."
			exit 1
		fi
	else
   		echo "You are missing some dependendencies! Results may be affected."
   		read -p "Do you still want to continue? (y/n)?"
   		if [ $REPLY == "n" ]; then
			echo "Exiting..."
			exit 1
   		fi
	fi
else 
	echo "Unsupported OS! Exiting ..."
	exit 1
fi

