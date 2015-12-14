FROM ubuntu:15.10
# Expose the SSH port
EXPOSE 22

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server \
    xpra x11-apps xterm \
    xserver-xephyr i3

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd 

RUN adduser --disabled-password --gecos "User" --uid 1000 user

# to allow adding the public key e.g. with docker exec -i x11-xpra /bin/bash -c 'cat > /home/user/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
RUN mkdir /home/user/.ssh/

VOLUME /home/user

# Start SSH so we are ready to make a tunnel
CMD mkdir -p /home/user/.ssh/ && chown -R user:user /home/user && /usr/sbin/sshd -D
