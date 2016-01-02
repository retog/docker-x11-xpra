# Note: Using 15.10 and the winswitch repo leads to:  Error starting Xvfb: [Errno 2] No such file or directory
FROM ubuntu:14.04
# Expose the SSH port
EXPOSE 22

RUN apt-get install -y curl \
    && curl https://winswitch.org/gpg.asc | apt-key add - \
    && echo "deb http://winswitch.org/ trusty main" > /etc/apt/sources.list.d/winswitch.list


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server \
    x11-apps xterm \
    xserver-xephyr i3 xpra

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd 

RUN adduser --disabled-password --gecos "User" --uid 1000 user

# to allow adding the public key e.g. with docker exec -i x11-xpra /bin/bash -c 'cat > /home/user/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
RUN mkdir /home/user/.ssh/

VOLUME /home/user

ENV DISPLAY=:100

RUN echo DISPLAY=$DISPLAY >> /etc/environment

# Start SSH anx Xpra
CMD mkdir -p /home/user/.ssh/ && chown -R user:user /home/user && /usr/sbin/sshd && su user -c "xpra start $DISPLAY --no-daemon"
