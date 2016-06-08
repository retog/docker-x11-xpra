# docker-x11-xpra
A docker image proving a basis for X applications accessible via ssh with or 
without [Xpra](http://xpra.org/) and optionally within Xephyr/i3

The docker image comes witha small set o X-Application like xclock, xterm, 
xeyes it is meant to be extended to provide the required applications.

## Usage example

Run with

    docker run -p 2020:22 -d --name x11-xpra reto/x11-xpra 

Copy your ssh public key
    
    docker exec -i x11-xpra /bin/bash -c 'cat > /home/user/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub

Start xclock

    ssh -p 2020 user@localhost xclock

The DISPLAY variable set to `:100` which the virtual display provided by Xpra. You 
will not see the application until a client connects to the Xpra server.

To connect a client from the local machine
  
    xpra --ssh="ssh -p 2020" attach ssh:user@localhost:100

As any time you can start more applications

    ssh -p 2020 user@localhost xeyes

If rather than having "rootless" remote applications you would like to have a whole
remote desktop you can start start Xephyr as display `:200`

    ssh -p 2020 user@localhost "Xephyr -ac -br -noreset -screen 800x600 :200" &

Start i3 as display manager

    ssh -p 2020 user@localhost DISPLAY=:200 i3 & 

And start xclock on Xephyr

    ssh -p 2020 user@localhost DISPLAY=:200 xclock &

You may need to adapt the keyboard layout

    ssh -p 2020 user@localhost DISPLAY=:200 setxkbmap -layout ch
    
Simial projects

 - A more comprehensive framework to run desktop applications in Docker is [subuser](http://subuser.org/)

