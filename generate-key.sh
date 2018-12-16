#!/bin/bash
ssh-keygen -q -t ecdsa -N '' -f userkey

# generate certificate and sign it with 1 week's validity
ssh-keygen -s ca -I userkey -n deployer -V +1w -z 1 userkey.pub
