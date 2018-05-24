# linuxRemoteDocker
An attempt to create a docker-recipy for invoking a linux-based development environment with relevant development stuff, such as VS Code and Python and such. And Git, let's not forget about Git.

Inspired by https://github.com/cesarandreslopez/docker-ubuntu-mate-desktop-nomachine


## Build

```
git clone https://github.com/harleydk/linuxRemoteDocker
docker build -t=linux_remote_pc_image .
```

## Enviroment vaiables
USER -> user for the nomachine login
PASSWORD -> password for the nomachine login

## Usage

Running it:

```
docker run -d -p 4000:4000 --name linux_remote_pc -e PASSWORD=password -e USER=user --cap-add=SYS_PTRACE 'linux_remote_pc_image'
```

## Connect to the container

Download the NoMachine client from: https://www.nomachine.com/download, install the client, create a new connection to your public ip, port 4000, NX protocol, use enviroment user and password for authentication (make sure to setup enviroment variables for that)
