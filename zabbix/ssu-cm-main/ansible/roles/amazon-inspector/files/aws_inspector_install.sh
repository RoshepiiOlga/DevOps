#!/bin/bash
#
# Install AWS Inspector and remove installer and service once installed

curl https://inspector-agent.amazonaws.com/linux/latest/install | bash

if [[ $? -ne 0 ]];
then
    logger -p daemon.err "Unable to install AWS Inspector, would be retried"
    exit 1
else
    /bin/systemctl disable aws_inspector_install.service
    exit 0
fi
