#!/bin/bash
#
#  Bootstrap a bastion instance for hadoop setup.
#

if [[ ! -f $HOME/.aws/config ]]; then
  # Isntall AWS CLI
  apt-get update -y
  apt-get install -y python-pip
  pip install awscli

  # Configure AWS CLI
  aws configure
fi

# Install dependencies
apt-get install -y pdsh

# Download setup code
apt-get install -y git-core
git clone https://github.com/uprush/hadoop-demo.git
cd hadoop-demo
