# Get the distro:
FROM ubuntu:17.10
ENV DEBIAN_FRONTEND=noninteractive

# Do some general updates.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* &&  apt-get clean &&  apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends software-properties-common 
RUN add-apt-repository universe && \
    apt-get update -y
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

# Let's add a super user, too. Same password.
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

# Install some much needed programs
RUN apt-get install -y epiphany-browser nano mc guake git gedit retext

# Use the Xfce desktop. Because it's nice to look at, in my opinion.
RUN apt-get update -y && \
    apt-get install -y xfce4

# Install Java. And Maven.
RUN \
  apt-get update && \
  apt-get install -y maven openjdk-8-jdk && \
  rm -rf /var/lib/apt/lists/*
RUN update-alternatives --config java
RUN update-alternatives --config javac

# Install miniconda, for Python virtual environmentaziation
# RUN curl -fSL "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -o Miniconda3-latest-Linux-x86_64.sh
# RUN bash Miniconda3-latest-Linux-x86_64.sh -b
# Enable conda
# RUN echo ". /home/theadmin/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
# RUN conda create -n <name_of_env> python=3.6 -y

# Install Postman to 'opt' dir
#RUN wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz && \
    #tar -xzf postman.tar.gz -C /opt && \
#    rm postman.tar.gz

# Install eclipse
ENV ECLIPSE_WORKSPACE=${HOME}/eclipse-workspace
ARG ELCIPSE_TAR=${ELCIPSE_TAR:-eclipse-jee-oxygen-R-linux-gtk-x86_64.tar.gz}
WORKDIR /opt
RUN wget -c http://mirror.math.princeton.edu/pub/eclipse//technology/epp/downloads/release/oxygen/R/${ELCIPSE_TAR} && \
    tar xvf ${ELCIPSE_TAR} && \
    rm ${ELCIPSE_TAR} 

# install eclipse plugins. Thanks, https://www.cs.ubc.ca/~gberseth/blog/install-eclipse-plugins-via-the-command-line.html
RUN /opt/eclipse/eclipse -application org.eclipse.equinox.p2.director -repository http://eclipse-jetty.github.io/update -installIU net.sourceforge.eclipsejetty.feature.feature.group
#VOLUME ${ECLIPSE_WORKSPACE}
#VOLUME ${HOME}/.eclipse 

# install postman
RUN wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
RUN tar -xzf postman.tar.gz -C /opt
RUN rm postman.tar.gz
RUN printf '[Desktop Entry]\nName=Postman\nComment=Postman\nExec=/opt/Postman/app/Postman \nIcon=/opt/Postman/app/resources/app/assets/icon.png\nTerminal=false\nType=Application\nStartupNotify=true'"" > /home/theuser/Desktop/postman.desktop
RUN printf '[Desktop Entry]\nName=Postman\nComment=Postman\nExec=/opt/Postman/app/Postman \nIcon=/opt/Postman/app/resources/app/assets/icon.png\nTerminal=false\nType=Application\nStartupNotify=true'"" > /home/theadmin/Desktop/postman.desktop

# Create a desktop shortcut to Eclipse:
#  executable file that starts the NoMachine remote desktop server.
# A unix executable .sh-file must start with #!/bin/bash. '\n' means 'newline'.
# Note how the file ends with a /bin/bash-command. That's deliberate, it allows
# us do - don't ask me how - keep the container running when we use it later.
RUN printf '[Desktop Entry]\nName=Eclipse\nComment=Eclipse\nExec=/opt/eclipse/eclipse\nIcon=/opt/eclipse/icon.xpm\nTerminal=false\nType=Application\nStartupNotify=true'"" > /home/thecoder/Desktop/eclipse.desktop
RUN printf '[Desktop Entry]\nName=Eclipse\nComment=Eclipse\nExec=/opt/eclipse/eclipse\nIcon=/opt/eclipse/icon.xpm\nTerminal=false\nType=Application\nStartupNotify=true'"" > /home/theadmin/Desktop/eclipse.desktop

RUN mkdir -p ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} && \
    chown -R ${USER}:${USER} ${ECLIPSE_WORKSPACE} ${HOME}/.eclipse

# Install Gradle
#RUN wget https://services.gradle.org/distributions/gradle-4.8.1-bin.zip && \
#    #mkdir /opt/gradle && \
#    unzip -d /opt/gradle gradle-4.8.1-bin.zip
#ENV PATH="/opt/gradle/gradle-4.8.1/bin:${PATH}"


#HTTP port
EXPOSE 8080

# Annnnnd back to root for the remainder of this session.
USER root

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



