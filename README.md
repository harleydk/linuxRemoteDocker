
# linuxRemoteDocker

A docker-recipe for invoking a linux-based development environment with relevant development stuff, such as VS Code, Git, Python, those things. Includes a (free) NoMachine server, so it's easy to remote into.

Use this as inspiration for creating your own docker-based tear-down-and-build-up dev machine.


## Build it

Clone this git repo, install docker if not already, then issue the ...

```
docker build -t=linux_remote_pc_image .
```

... command. 

## Run it

Then there's just running it: 

```
docker run -d -t -p 4000:4000 --name=linux_remote_pc --cap-add=SYS_PTRACE  --memory=4096m linux_remote_pc_image
```

Where...

* __-d__ means 'run in background thread so we'll be able to use the docker host for other things while the container image is running'

* __-t__ means 'attach a pseudo-TTY', basically a fancy way of attaching a fake console-prompt to the container. Seems superfluous, but _this will prevent the container from exiting immediately__ and we need to keep it alive to accept remote desktop connections [what is TTY in docker?](https://www.quora.com/What-does-the-t-or-tty-do-in-Docker).

* __-p 4000:4000__ means 'map port 4000 on the container image to port 4000 on the host. Nomachine operates on port 4000, see. You can specify a different port, if you want. If, say, you have several images running on the same host.

* __name linux_remote_pc__ makes it easier to recognize the container image among all the others, lest it'll just have a generic name assigned to it.

* __--cap-add=SYS_PTRACE__ is absolutely, definitely required by [Nomachine](https://www.nomachine.com/DT08M00099), or we won't be able to create local displays for the users logging in. At least with ubuntu 16.04+, that is.

* __--memory=4096__ (optional) limit the memory consumption of the container (4 gb, in this case)

## Connect to it

Download the NoMachine client from: https://www.nomachine.com/download, install the client, create a new connection to your public ip, port 4000, NX protocol, use enviroment user and password for authentication (make sure to setup enviroment variables for that)

User-name is 'thecoder'. Password is, well, 'password'. Just change it in the Dockerfile if you'd rather have it differently.


## Hope it's useful

Hope it's useful to you! Let me know if there's anything I can do - just create an issue within these pages and I'll try be of help, if I can. Please consider supporting my coffee-habit if you can.

<a href="https://www.buymeacoffee.com/Ghi82pFzV" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>
