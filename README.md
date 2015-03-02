Instalation instruction:

The contained Dockerfile and scripts will build the ROSE compiler infrastructure, togheter with an example autotools project. ROSE is built in a docker container. The path to the example project inside the container is: /root/development/exampleRoseProject, while the path for the installed ROSE is: /home/ROSE/RoseInstallTree . Togheter with ROSE the container contains eclipse. ROSE is installed with gcc 4.8 and Boost 1.53 . 

The current version support Linux and Mac OS X systems. We automatically detect your operating system, and check some of the hardware requirements. You should have at least 6GB RAM memory and 50GB available disk space on the phisic location of the docker container. By default the compilation of ROSE is done on 8 threads. Acording to the number of cores in your system you can increase / decrease this number: in ''Dockerfile'' find and replace ''-j8'' with ''-jx'', where x is the number of threads used by Make in building ROSE. 


* [Install]
* * Run ./buildRoseContainer. This may take a while, because we have to build ROSE here. After it you will have a full instalation of ROSE compiler infrastructure. The folder exampleProject is the folder shared between the filesystem and Docker. Only the modifications in the container done in shared paths will be saved after the container is closed.  ''exampleProject'' folder and the workspace from the docker image are shared folder in our scripts. We share the workspace for persisting configurations of eclipse and existing projects between sessions.

* [Run]
* * For developing / testing retype you have to run the script ./run.sh . If you want to run just eclipse, you can run: ./run.sh eclipse . If you run: ./run.sh , then you will enter in an interactive shell. 
From here you can also start eclipse, by running: eclipse . The project is already configured and tested. 
* * For connecting to the repository with your ssh key, run the following on the local file system: sudo cp /path/to/ssh/id_rsa dockerizedretype_full/.ssh/ || sudo cp /path/to/ssh/id_rsa .ssh/
* * Note: for running ROSE on Mac OS X, you have to run all the scripts from the boot2docker terminal.


* First time usage of eclipse: 
	Once entered in eclipse you can import the project: File -> New -> Makefile Project with Existing Code and follow the wizzard; after this is finished: File -> New -> Convert to a C/C++ Autotools Project . After the project is configured right click on the project; Properties; expand Autotools; Configure Settings; expand configure; Advanced; copy and paste in the box near Additional command-line options:

	CPPFLAGS="-I/home/ROSE/RoseInstallTree/include/rose -I/home/ROSE/BoostInstallTree/include" LDFLAGS="-L/home/ROSE/RoseInstallTree/lib -L/home/ROSE/BoostInstallTree/lib -L/usr/lib/jdk1.8.0_25/jre/lib/amd64/server" CFLAGS="-O0 -g" CXXFLAGS="-O0 -g"
Run Project -> Build All, and then you will be able to use eclipse for retype.


	After the first configuration the settings will be persistent. 

** On linux machines the GUI (for eclipse) should run by default. However, on Mac OS X systems there are some additional requirements for running GUI program. A way for this is:
	1) Install socat and xquartz: 
		brew install socat
		brew cask install xquartz
		open -a XQuartz
	2) Before running ''./run.sh'' open a different terminal window, and open socat: socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
	3) Run ''./run.sh eclipse'' and the GUI should work
	* * * Note: We assume that you use the default ip address for boot2docker. If not, check the ip address in boot2docker (boot2docker conf), and replace: ''192.168.59.3'' with the identified IP address . 

** The current scripts and configuration should work on any Linux or Mac OS X machine. The image by itself may be used also on  Windows, but the scripts were not tested. If runned from boot2docker you may try to run ./dockerizeRetypeMacOS.sh and ./runMacOS.sh for building and running.  However the GUI will not work in this case.

*** If you want to change the default location of the docker images (for saving space on / ), on Linux systems, then:

	sudo vim /etc/default/docker.io (for Ubuntu 14.04) / sudo vim /etc/default/docker (in all the other cases)
	add / replace the line with DOCKER_OPTS : DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --storage-driver=devicemapper --storage-opt dm.basesize=50G -g PATH_CONTAINERS"
	sudo services docker.io restart  -> for Ubuntu 14.04 / sudo services docker restart -> for all the other cases
	sudo docker run -P -e --rm ubuntu:14.04 df -h /  -> check that the size of the root partition is 50G. If it is not then: 
		sudo docker stop $(sudo docker ps -a -q)
                sudo docker rm $(sudo docker ps -a -q)
                sudo docker rmi $(sudo docker images -a)
                sudo services docker.io stop / sudo services docker stop           
                sudo rm -r /var/lib/docker
                sudo services docker.io start / sudo services docker start

