# Get the distro:
FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

# Do some general updates.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* &&  apt-get clean &&  apt-get update -y &&  apt-get upgrade -y
# RUN apt-get install -y software-properties-common
# RUN apt-get install -y cups - for printing
# RUN apt-get install -y curl 
RUN apt-get install -y sudo 
RUN apt-get install -y libgconf2-4 
RUN apt-get install -y iputils-ping 
RUN apt-get install -y libxss1 
RUN apt-get install -y wget 
RUN apt-get install -y xdg-utils 
RUN apt-get install -y libpango1.0-0 
# RUN apt-get install -y fonts-liberation

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


# Use the Xfce desktop. Because it's nice to look at, in my opinion.
# Thanks, https://linuxhint.com/install-xfce-desktop-on-debian-9-stretch/!
# RUN apt-get update -y && \
#    apt-get install -y xfce4
# RUN systemctl set-default graphical.target


# There's also the MATE desktop-enviroment. Bit more light-weight.
#RUN apt-get update -y && \
#   apt-get install -y mate-desktop-environment-extras    

# Install Python.
# Whoa, waitaminute - Ubuntu 17.10 already comes with Python 3.6 as default. Just run python3 to invoke it.

# Install miniconda, for Python virtual environmentaziation
# RUN curl -fSL "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -o Miniconda3-latest-Linux-x86_64.sh
# RUN bash Miniconda3-latest-Linux-x86_64.sh -b
# Enable conda
# RUN echo ". /home/theadmin/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
# RUN conda create -n <name_of_env> python=3.6 -y


# To make it easier to automate and configure VS Code, it is possible to list, install, 
# and uninstall extensions from the command line. When identifying an extension, provide 
# the full name of the form publisher.extension, for example donjayamanne.python.
USER $USER
WORKDIR /home/$USER


# Annnnnd back to root for the remainder of this session.
USER root

# Install nomachine, the remote-desktop server that enables us to remote into the container image.
# You don't have to rely on my choice of NoMachine - just go to their website and get a different one, if you want.
ENV NOMACHINE_MAJOR_VERSION "6.2"
ENV NOMACHINE_PACKAGE_NAME "nomachine_6.2.4_1_amd64.deb"
ENV NOMACHINE_MD5 "210bc249ec9940721a1413392eee06fe"

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



