FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Some general updates to get us started:
RUN apt-get update -y && apt-get install -y software-properties-common  && apt-get install -y locales
RUN add-apt-repository universe
RUN apt-get install -y cups curl libgconf2-4 iputils-ping libnss3-1d libxss1 wget xdg-utils libpango1.0-0 fonts-liberation


# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="da_DK.UTF-8"
ENV LANGUAGE=da_DK
RUN locale-gen da_DK.UTF-8 && locale-gen da_DK
RUN echo "Europe/Copenhagen" > /etc/timezone && \
    apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG

    

# Install the mate-desktop-enviroment version you would like to have
RUN apt-get update -y && \
    apt-get install -y mate-desktop-environment-extras
    
# Install xfce4 desktop - hm, doesn't work with nomachine.
#RUN apt-get update -y && \
#    apt-get install -y xfce4

# Install git
RUN apt-get install -y git
# Install python
# RUN apt-get install -y python3.6

# Install Visual Studio Code
ENV VSCODEPATH="https://go.microsoft.com/fwlink/?LinkID=760868"
RUN curl -fSL "${VSCODEPATH}" -o vscode.deb \
&& dpkg -i vscode.deb

# To make it easier to automate and configure VS Code, it is possible to list, install, 
# and uninstall extensions from the command line. When identifying an extension, provide 
# the full name of the form publisher.extension, for example donjayamanne.python.

# We can't install VS Code extentions as super-user, so we'll revert to a regular user as we do that:
# RUN useradd -ms /bin/bash newuser
# RUN echo 'newuser:password' | chpasswd

ENV USER='newuser'
ENV PASSWORD='password'

RUN groupadd -r $USER -g 433 \
    && useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
    #&& adduser $USER sudo \
    && mkdir /home/$USER \
    && chown -R $USER:$USER /home/$USER \
    && echo $USER':'$PASSWORD | chpasswd

USER $USER
WORKDIR /home/$USER

# Enable viewing git log, file history, compare branches and commits - https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory
RUN code --install-extension donjayamanne.githistory
# Install Ms' python - linting, debugging, intellisense, etc.
RUN code --install-extension ms-python.python
# Install code outline provider - better code visualization in the explorer pane
RUN code --install-extension patrys.vscode-code-outline


# Annnnnd back to root for the remainder of this session.
USER root

# Install nomachine, so we can remote into the machine
ENV NOMACHINE_PACKAGE_NAME nomachine_6.1.6_9_amd64.deb
ENV NOMACHINE_MD5 00b7695404b798034f6a387cf62aba84

RUN curl -fSL "http://download.nomachine.com/download/6.1/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb

# Copy the nxserver.sh script.
COPY nxserver.sh /
# And make it executable, or we can't start the server.
RUN ["chmod", "+x", "/nxserver.sh"]

# Start the NoMachine remote desktop service.
ENTRYPOINT ["/nxserver.sh"]


# Now install the Nomachine-client and remote into the image. Provide user-credentials, like so:
# docker run -d -p 4000:4000 --name linux_remote_pc -e PASSWORD=password -e USER=user --cap-add=SYS_PTRACE 'linux_remote_pc_image'