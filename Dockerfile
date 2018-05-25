FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Some general updates.
RUN apt-get update -y && apt-get install -y software-properties-common 
RUN add-apt-repository universe
RUN apt-get install -y cups curl libgconf2-4 iputils-ping libnss3-1d libxss1 wget xdg-utils libpango1.0-0 fonts-liberation
RUN apt-get update -y && apt-get install -y software-properties-common  && apt-get install -y locales

# Install the mate-desktop-enviroment version you would like to have
RUN apt-get update -y && \
    apt-get install -y mate-desktop-environment-extras

# Install nomachine, change password and username to whatever you want here.
# Important to note: install the nomachine-server _before_ adding the user. Or we won't have ...
ENV NOMACHINE_PACKAGE_NAME nomachine_6.1.6_9_amd64.deb
ENV NOMACHINE_MD5 00b7695404b798034f6a387cf62aba84

RUN curl -fSL "http://download.nomachine.com/download/6.1/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb

# copy the nxserver.sh script. 
COPY nxserver.sh /
RUN ["chmod", "+x", "/nxserver.sh"]

# Let's add a user:
# We can't install VS Code extentions as super-user, so we'll revert to a regular user as we do that:
# RUN useradd -ms /bin/bash newuser
# RUN echo 'newuser:password' | chpasswd

# Install Visual Studio Code





# Start the nomachine-remote server
ENTRYPOINT ["/nxserver.sh"]

