FROM ubuntu:14.04
MAINTAINER Alex Marginean "alexandru.marginean.13@ucl.ac.uk"

#install the requirements for building ROSE
RUN apt-get update && apt-get install -y git wget gcc-4.8 g++-4.8 gfortran-4.8 autoconf automake libtool flex bison doxygen ghostscript graphviz texlive make vim libgcrypt11-dev libffi-dev

RUN cp /usr/bin/gcc-4.8 /usr/bin/gcc 
RUN cp /usr/bin/g++-4.8 /usr/bin/g++
RUN cp /usr/bin/gfortran-4.8 /usr/bin/gfortran

#build the folder structure
RUN mkdir /home/development
RUN mkdir /home/ROSE
RUN mkdir /home/ROSE/RoseInstallTree
RUN mkdir /home/ROSE/BoostInstallTree
RUN mkdir /home/ROSE/BuildFolder
RUN mkdir /home/ROSE/BuildFolder/RoseCompileTree


#first copy the ssh keys; needed for gitolite repo
RUN mkdir -p /root/.ssh/
COPY id_rsa /root/.ssh/
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan goa.cs.ucl.ac.uk >> /root/.ssh/known_hosts

#copy the wrapper script required for specifying the key files
COPY git.sh /home/ROSE/BuildFolder/
RUN chmod +x /home/ROSE/BuildFolder/git.sh


#clone a compilable version of ROSE and Boost, using the copied git wrapper 
RUN cd /home/ROSE/BuildFolder && ./git.sh -i /root/.ssh/id_rsa clone gitolite@goa.cs.ucl.ac.uk:projects/retype/roseubuntu14.04

#untar them
RUN cd /home/ROSE/BuildFolder && tar -xzvf roseubuntu14.04/boost_1_53_0.tar.gz 
RUN cd /home/ROSE/BuildFolder && tar -xzvf roseubuntu14.04/edg4x-rose.tar.gz
RUN cd /home/ROSE/BuildFolder && tar -xzvf roseubuntu14.04/jdk1.8.0_25.tar.gz

#install jdk
RUN mv /home/ROSE/BuildFolder/jdk1.8.0_25 /usr/lib/

#install BOOSTcd
#boost install folder /home/ROSE/BoostInstallTree
RUN cd /home/ROSE/BuildFolder/boost_1_53_0 && ./bootstrap.sh --prefix=/home/ROSE/BoostInstallTree
RUN cd /home/ROSE/BuildFolder/boost_1_53_0 && ./bjam install --prefix=/home/ROSE/BoostInstallTree



#fix includes
RUN cp -r /usr/include/x86_64-linux-gnu/sys /usr/include/sys

#install ROSE
#install tree: /home/ROSE/RoseInstallTree
#compile tree: /home/ROSE/BuildFolder/RoseCompileTree


#RUN export JAVA_HOME=/usr/lib/jdk1.8.0_25 && export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH && export LD_LIBRARY_PATH=/home/ROSE/BoostInstallTree/lib:$LD_LIBRARY_PATH

RUN cd /home/ROSE/BuildFolder/edg4x-rose/ && export JAVA_HOME=/usr/lib/jdk1.8.0_25 && export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH && export LD_LIBRARY_PATH=/home/ROSE/BoostInstallTree/lib:$LD_LIBRARY_PATH && ./build

#RUN cd /home/ROSE/BuildFolder/RoseCompileTree && /home/ROSE/BuildFolder/edg4x-rose/configure --prefix=/home/ROSE/BuildFolder/edg4x-rose --with-boost=/home/ROSE/BoostInstallTree --enable-static --without-haskell && make -j4 && make install


RUN cd /home/ROSE/BuildFolder/RoseCompileTree && export JAVA_HOME=/usr/lib/jdk1.8.0_25 && export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH && export LD_LIBRARY_PATH=/home/ROSE/BoostInstallTree/lib:$LD_LIBRARY_PATH && /home/ROSE/BuildFolder/edg4x-rose/configure --prefix=/home/ROSE/RoseInstallTree --with-boost=/home/ROSE/BoostInstallTree --enable-static --without-haskell 

RUN cd /home/ROSE/BuildFolder/RoseCompileTree && export JAVA_HOME=/usr/lib/jdk1.8.0_25 && export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH && export LD_LIBRARY_PATH=/home/ROSE/BoostInstallTree/lib:$LD_LIBRARY_PATH && make -C src/ -j8

RUN cd /home/ROSE/BuildFolder/RoseCompileTree && export JAVA_HOME=/usr/lib/jdk1.8.0_25 && export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH && export LD_LIBRARY_PATH=/home/ROSE/BoostInstallTree/lib:$LD_LIBRARY_PATH && export MKDIR_P="mkdir -p" && make install-core

#install retype
#do not install retype here any more
#it will be added into a shared folder
#RUN cd /home/development && git clone gitolite@goa.cs.ucl.ac.uk/projects/retype/retype

#configure command: ./configure CPPFLAGS="-I/home/ROSE/RoseInstallTree/include/rose -I/home/ROSE/BoostInstallTree/include" LDFLAGS="-L/home/ROSE/RoseInstallTree/lib -L/home/ROSE/BoostInstallTree/lib -L/usr/lib/jdk1.8.0_25/jre/lib/amd64/server" CFLAGS="-O0 -g" CXXFLAGS="-O0 -g"
RUN ls

#install eclipse
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module


RUN cd /home && wget http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/luna/SR1/eclipse-cpp-luna-SR1-linux-gtk-x86_64.tar.gz  && tar -xzvf eclipse-cpp-luna-SR1-linux-gtk-x86_64.tar.gz

RUN echo "/home/eclipse/eclipse -vm /usr/lib/jdk1.8.0_25/jre/bin/java" > /usr/bin/eclipse


RUN chmod +x /usr/bin/eclipse


#echo /home/development/eclipse/eclipse -vm /usr/lib/jdk1.8.0_25/bin/java > /usr/bin/eclipse



#RUN mkdir /root/development

ENV JAVA_HOME /usr/lib/jdk1.8.0_25
ENV LD_LIBRARY_PATH /home/ROSE/BoostInstallTree/lib:/usr/lib/jdk1.8.0_25/jre/lib/amd64/server:

RUN cp /home/ROSE/BuildFolder/RoseCompileTree/rose_config.h /home/ROSE/RoseInstallTree/include/rose

#new user needed for running X server apps
#RUN echo "developer:x:1000:1000:Developer,,,:/home/development:/bin/bash" >> /etc/passwd && \
#    echo "developer:x:1000:" >> /etc/group && \
#    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#    chmod 0440 /etc/sudoers.d/developer && \
#    chown developer:developer -R /home/development && \
#    chown developer:developer -R /home/eclipse && \
#    chown developer:developer /usr/bin/sudo && chmod 4755 /usr/bin/sudo




