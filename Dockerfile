FROM ubuntu:15.10
# Expose the SSH port
EXPOSE 22

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server \
    xpra x11-apps xterm \
    xserver-xephyr i3

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd 
# to allow adding the public key e.g. with docker exec -i x11-xpra /bin/bash -c 'cat > /root/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
RUN mkdir /root/.ssh/

# Start SSH so we are ready to make a tunnel
CMD ["/usr/sbin/sshd", "-D"]
