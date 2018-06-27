# Get the distro:
FROM ubuntu:17.10
ENV DEBIAN_FRONTEND=noninteractive

# Do some general updates.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* &&  apt-get clean &&  apt-get update -y &&  apt-get upgrade -y
RUN apt-get install -y --no-install-recommends software-properties-common 
RUN add-apt-repository universe
Run apt-get update -y
RUN apt-get install -y curl sudo libgconf2-4 iputils-ping libxss1 wget xdg-utils libpango1.0-0 fonts-liberation locales 

# Let's add a user, so we have a chance to, well, actually use the machine.
ENV USER='thecoder'
ENV PASSWORD='password'
RUN groupadd -r $USER -g 433 \
    && useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
    && adduser $USER sudo \
    && mkdir /home/$USER \
    && chown -R $USER:$USER /home/$USER \
    && echo $USER':'$PASSWORD | chpasswd

# Let's add a super user, too. Same password
ENV SUDOUSER='theadmin'
ENV PASSWORD='password'
RUN groupadd $SUDOUSER \
    && useradd -r -g $SUDOUSER -d /home/$SUDOUSER -s /bin/bash -c "$SUDOUSER" $SUDOUSER \
    && adduser $SUDOUSER sudo \
    && mkdir /home/$SUDOUSER \
    && chown -R $SUDOUSER:$SUDOUSER /home/$SUDOUSER \
    && echo $SUDOUSER':'$PASSWORD | chpasswd

# Configure timezone and locale to en_US. __Change locale and timezone to whatever you want.__
 ENV LANG="en_US.UTF-8"
 ENV LANGUAGE=en_US
 RUN locale-gen en_US.UTF-8 && locale-gen en_US
 RUN echo "Europe/Copenhagen" > /etc/timezone && \
     apt-get install -y locales && \
     sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
     dpkg-reconfigure --frontend=noninteractive locales && \
     update-locale LANG=$LANG

# Create an keyboard-layout file, so we won't have to set it every time the machine starts. Just replace XKBLAYOUT="dk" with your layout, ex. "us".
# RUN printf '# Consult the keyboard(5) manual page.\nXKBMODEL="pc105"\nXKBLAYOUT="dk"\nXKBVARIANT=""\nXKBOPTIONS=""\nBACKSPACE="guess"\n'"" > /etc/default/keyboard
# - doesn't work :(
# set danish keyboard layout
# RUN setxkbmap dk  - doesnt work :(

# Install some much needed programs - nano, midnight commander, guake terminal
RUN apt-get install -y nano mc guake git firefox

# Use the Xfce desktop. Because it's nice to look at, in my opinion.
RUN apt-get update -y && \
    apt-get install -y xfce4
# There's also the MATE desktop-enviroment. Bit more light-weight.
#RUN apt-get update -y && \
#   apt-get install -y mate-desktop-environment-extras    


# Install miniconda, for Python virtual environmentaziation
# RUN curl -fSL "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -o Miniconda3-latest-Linux-x86_64.sh
# RUN bash Miniconda3-latest-Linux-x86_64.sh -b
# Enable conda
# RUN echo ". /home/theadmin/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
# RUN conda create -n <name_of_env> python=3.6 -y

# Install Postman to 'opt' dir
RUN wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
RUN tar -xzf postman.tar.gz -C /opt
RUN rm postman.tar.gz

# Install eclipse
ENV ECLIPSE_WORKSPACE=${HOME}/eclipse-workspace

ARG ELCIPSE_TAR=${ELCIPSE_TAR:-eclipse-jee-oxygen-R-linux-gtk-x86_64.tar.gz}

WORKDIR /opt
RUN wget -c http://mirror.math.princeton.edu/pub/eclipse//technology/epp/downloads/release/oxygen/R/${ELCIPSE_TAR} && \
    tar xvf ${ELCIPSE_TAR} && \
    rm ${ELCIPSE_TAR} 
    
#VOLUME ${ECLIPSE_WORKSPACE}
#VOLUME ${HOME}/.eclipse 

RUN mkdir -p ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} &&\
    chown -R ${USER}:${USER} ${ECLIPSE_WORKSPACE} ${HOME}/.eclipse
    

# Annnnnd back to root for the remainder of this session.
USER root


# Install JDK with no add-ons
RUN apt-get -y -f install --no-install-recommends openjdk-8-jdk 

# Install Maven
ENV MAVEN_VERSION 3.3.1
RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven

#Install Tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.63
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
        && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
        && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
        && tar -xvf tomcat.tar.gz --strip-components=1 \
        && rm bin/*.bat \
        && rm tomcat.tar.gz* \
        && chmod -R 777 /usr/local/tomcat

#HTTP port
EXPOSE 8080



RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections
RUN apt-get update
RUN apt-get install -y --force-yes vim
RUN apt-get -y install oracle-java8-installer || true
RUN cd /var/lib/dpkg/info
RUN sed -i 's|JAVA_VERSION=8u151|JAVA_VERSION=8u162|' oracle-java8-installer.*
RUN sed -i 's|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/|' oracle-java8-installer.*
RUN sed -i 's|SHA256SUM_TGZ="c78200ce409367b296ec39be4427f020e2c585470c4eed01021feada576f027f"|SHA256SUM_TGZ="68ec82d47fd9c2b8eb84225b6db398a72008285fafc98631b1ff8d2229680257"|' oracle-java8-installer.*
RUN sed -i 's|J_DIR=jdk1.8.0_151|J_DIR=jdk1.8.0_162|' oracle-java8-installer.*
RUN apt-get install -f -y
RUN apt-get install -y oracle-java8-set-default

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# install java
RUN apt-get install -y --no-install-recommends software-properties-common
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre
RUN update-alternatives --config java
RUN update-alternatives --config javac

# install tomcat


# Install nomachine, the remote-desktop server that enables us to remote into the container image.
# You don't have to rely on my choice of NoMachine - just go to their website and get a different one, if you want.
ENV NOMACHINE_MAJOR_VERSION "6.2"
ENV NOMACHINE_PACKAGE_NAME nomachine_6.2.4_1_amd64.deb
ENV NOMACHINE_MD5 210bc249ec9940721a1413392eee06fe

RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_MAJOR_VERSION}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb


# Create an executable file that starts the NoMachine remote desktop server.
# A unix executable .sh-file must start with #!/bin/bash. '\n' means 'newline'.
# Note how the file ends with a /bin/bash-command. That's deliberate, it allows
# us do - don't ask me how - keep the container running when we use it later.
RUN printf '#!/bin/bash\n/etc/NX/nxserver --startup\n/bin/bash'"" > /etc/NX/nxserverStart.sh
# Now make the executable _actually_ executable ...
RUN chmod +x /etc/NX/nxserverStart.sh
# ... and start the nomachine-remote server when the container runs, and ...
CMD ["/etc/NX/nxserverStart.sh"]
#... happy developing! Use a NoMachine-client program to log into the server.
# PS: remember to run the container with the -d and -t arguments. 
# Check the readme.md file, https://github.com/harleydk/linuxRemoteDocker/blob/master/README.md



