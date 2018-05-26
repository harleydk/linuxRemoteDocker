
# linuxRemoteDocker
An attempt to create a docker-recipy for invoking a linux-based development environment with relevant development stuff, such as VS Code and Python and such. And Git, let's not forget about Git.

Inspired by https://github.com/cesarandreslopez/docker-ubuntu-mate-desktop-nomachine


## Build

```
git clone https://github.com/harleydk/linuxRemoteDocker
docker build -t=linux_remote_pc_image .
```

## Usage

Running it:

```
docker run -d -t -p 4000:4000 --name=linux_remote_pc --cap-add=SYS_PTRACE linux_remote_pc_image
```

Where...

* __-d__ means 'run in background thread so we'll be able to use the docker host for other things while the container image is running'

* __-t__ means 'attach a pseudo-TTY', basically a fancy way of attaching a fake console-prompt to the container. Seems superfluous, but _this will prevent the container from exiting immediately__ and we need to keep it alive to accept remote desktop connections [what is TTY in docker?](https://www.quora.com/What-does-the-t-or-tty-do-in-Docker).

* __-p 4000:4000__ means 'map port 4000 on the container image to port 4000 on the host. Nomachine operates on port 4000, see. You can specify a different port, if you want. If, say, you have several images running on the same host.

* __name linux_remote_pc__ makes it easier to recognize the container image among all the others, lest it'll just have a generic name assigned to it.

* __--cap-add=SYS_PTRACE__ is absolutely, definitely required by [Nomachine](https://www.nomachine.com/DT08M00099), or we won't be able to create local displays for the users logging in. At least with ubuntu 16.04, that is.

## Connect to the container

Download the NoMachine client from: https://www.nomachine.com/download, install the client, create a new connection to your public ip, port 4000, NX protocol, use enviroment user and password for authentication (make sure to setup enviroment variables for that)

User-name is 'thecoder'.
Password is, well, 'password'.
