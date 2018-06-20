# Get the distro:
FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

# Do some general updates.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* &&  apt-get clean &&  apt-get update -y &&  apt-get upgrade -y
RUN apt-get install -y software-properties-common 
RUN apt-get install -y cups curl sudo libgconf2-4 iputils-ping libxss1 wget xdg-utils libpango1.0-0 fonts-liberation
RUN apt-get update -y && apt-get install -y software-properties-common && apt-get install -y locales 

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
RUN apt-get update -y && \
    apt-get install -y xfce4
RUN systemctl set-default graphical.target


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

