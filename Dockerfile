FROM ubuntu:17.10

ENV DEBIAN_FRONTEND=noninteractive

# Some general updates.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* &&  apt-get clean &&  apt-get update -y &&  apt-get upgrade -y
RUN apt-get install -y software-properties-common 
RUN add-apt-repository universe
RUN apt-get install -y cups curl libgconf2-4 iputils-ping libxss1 wget xdg-utils libpango1.0-0 fonts-liberation
RUN apt-get update -y && apt-get install -y software-properties-common && apt-get install -y locales

# Install nomachine, change password and username to whatever you want here.
# Important to note: install the nomachine-server _before_ adding the user. Or we won't have ...
ENV NOMACHINE_PACKAGE_NAME nomachine_6.1.6_9_amd64.deb
ENV NOMACHINE_MD5 00b7695404b798034f6a387cf62aba84

RUN curl -fSL "http://download.nomachine.com/download/6.1/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb

# Let's add a user:
ENV USER='thecoder'
ENV PASSWORD='password'

RUN groupadd -r $USER -g 433 \
     && useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
      #&& adduser $USER sudo \
      && mkdir /home/$USER \
      && chown -R $USER:$USER /home/$USER \
      && echo $USER':'$PASSWORD | chpasswd

# Install Visual Studio Code
# ...foobar...
# We can't install VS Code extentions as super-user, so we'll revert to a regular user as we do that:

# Configure timezone and locale to en_US. Change locale and timezone to whatever you want.
 ENV LANG="en_US.UTF-8"
 ENV LANGUAGE=en_US
 RUN locale-gen en_US.UTF-8 && locale-gen en_US
 RUN echo "Europe/Copenhagen" > /etc/timezone && \
     apt-get install -y locales && \
     sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
     dpkg-reconfigure --frontend=noninteractive locales && \
     update-locale LANG=$LANG

# Use the Xfce desktop. Because it's nice to look at.
RUN apt-get update -y && \
    apt-get install -y xfce4
# There's also the MATE desktop-enviroment. Bit more light-weight.
#RUN apt-get update -y && \
#   apt-get install -y mate-desktop-environment-extras    

# Install git
RUN apt-get install -y git
# Install Python.
# Whoa, waitaminute - Ubuntu 17.10 already comes with Python 3.6 as default. Just run python3 to invoke it.

# Install Visual Studio Code
ENV VSCODEPATH="https://go.microsoft.com/fwlink/?LinkID=760868"
RUN curl -fSL "${VSCODEPATH}" -o vscode.deb \
&& dpkg -i vscode.deb

# To make it easier to automate and configure VS Code, it is possible to list, install, 
# and uninstall extensions from the command line. When identifying an extension, provide 
# the full name of the form publisher.extension, for example donjayamanne.python.
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



