#!/bin/bash

### yum update
yum update

### sample ansible install
yum install -y wget
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install ansible