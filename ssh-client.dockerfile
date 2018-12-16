FROM ubuntu:18.04

# install OpenSSH
RUN apt-get update && apt-get install -y openssh-client

CMD ["/bin/bash"]
