FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Make it clear that the following commands are executed as 'root' user, the most super of super users.
USER root

# Run some general updates. 'apt-get' is a package manager that scours the internet for awesome software to install.
RUN apt-get update -y && apt-get install -y software-properties-common 
RUN add-apt-repository universe
RUN apt-get install -y cups curl libgconf2-4 iputils-ping libnss3-1d libxss1 wget xdg-utils libpango1.0-0 fonts-liberation
RUN apt-get update -y && apt-get install -y software-properties-common  && apt-get install -y locales

# Install the mate-desktop-enviroment version you would like to have. Lots to choose from, unlike on windows.
RUN apt-get update -y && \
    apt-get install -y mate-desktop-environment-extras

# Install nomachine, the software that'll allow us to establish a remote desktop connection.
ENV NOMACHINE_PACKAGE_NAME nomachine_6.1.6_9_amd64.deb
ENV NOMACHINE_MD5 00b7695404b798034f6a387cf62aba84

RUN curl -fSL "http://download.nomachine.com/download/6.1/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb

# Create the user that we'll log on with:
ENV USER='thecoder'
ENV PASSWORD='password'

RUN groupadd -r $USER -g 433 \
     && useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
     && mkdir /home/$USER \
     && chown -R $USER:$USER /home/$USER \
     && echo $USER':'$PASSWORD | chpasswd


# Install Visual Studio Code
# ...foobar...
# Let's add a user:

# Change into this new user and install VS code extension.
USER $USER


# We can't install VS Code extentions as super-user, so we'll revert to a regular user as we do that:



# Change back to root for the remainder of this party:
USER root

# Create an executable file that starts the server... 
# A unix executable .sh-file must start with #!/bin/bash. '\n' means 'newline'.
#RUN printf '#!/bin/bash\n/etc/NX/nxserver --startup\n'"" > /etc/NX/nxserverStart.sh
# .. and make it actually executable ...
#RUN chmod +x /etc/NX/nxserverStart.sh

# Start the nomachine-remote server and ...
RUN /etc/NX/nxserver --startup
# .. continously monitor the NoMachine server log, and ...
#ENTRYPOINT ["tail", "-f", "/usr/NX/var/log/nxserver.log"]
#... happy developing!

# How to run the image? Like so:
# docker run -d -t -p 4000:4000 --name 'linux_remote_pc' --cap-add=SYS_PTRACE 'linux_remote_pc_image'



