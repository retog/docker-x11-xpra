FROM ubuntu:20.04
# Expose the SSH port
EXPOSE 22

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server \
    x11-apps xterm language-pack-en-base \
    xserver-xephyr i3

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd 

RUN adduser --disabled-password --gecos "User" --uid 1000 user

# to allow adding the public key e.g. with docker exec -i x11-xpra /bin/bash -c 'cat > /home/user/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
RUN mkdir /home/user/.ssh/

RUN mkdir /home/user/.i3
ADD i3-config /home/user/.i3/config

VOLUME /home/user


RUN echo AddressFamily inet >> /etc/ssh/sshd_config


# Start SSH
CMD mkdir -p /home/user/.ssh/ && chown -R user:user /home/user \ 
    && /usr/sbin/sshd && rm -f /tmp/.X100-lock \ 
    && su user -c "sleep infinity"
