#!/bin/bash
umask 77
ssh-keygen -q -N '' -C CA -f ca
