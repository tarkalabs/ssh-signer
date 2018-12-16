FROM ubuntu:18.04

# install OpenSSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# setup a non-privileged user
RUN useradd -ms /bin/bash deploy

# setup a CA pub and have the server trust 
# keys signed by the CA by adding the 
# following lines to /etc/ssh/sshd_config
# 
#   TrustedUserCAKeys /etc/ssh/ca.pub 
#   AuthorizedPrincipalsFile /etc/ssh/authorized_principals/%u
#   HostKeyAlgorithms  ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa,ssh-dss
# 
# 
RUN sed -i -e '/#PermitRootLogin/i \TrustedUserCAKeys /etc/ssh/ca.pub' \
    -e '/#PubKeyAuthentication/a \HostKeyAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa,ssh-dss' \
    -e 's:^#AuthorizedPrincipalsFile none:AuthorizedPrincipalsFile /etc/ssh/authorized_principals/%u:g' \
    /etc/ssh/sshd_config

# setup the authorized principals to allow SSH access
# for principals named with deployer / investigator
RUN mkdir -p /etc/ssh/authorized_principals && \
    echo 'deployer\ninvestigator' > /etc/ssh/authorized_principals/deploy

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd","-D","-e"]
