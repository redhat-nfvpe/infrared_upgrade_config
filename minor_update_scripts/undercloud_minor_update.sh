#!/bin/bash
sudo yum -y install python-pip
cd /opt
sudo git clone https://github.com/openstack/tripleo-repos || true
cd /opt/tripleo-repos
sudo pip install ./
sudo tripleo-repos -b master current
sudo yum update -y kernel openvswitch gnutls
sudo tripleo-repos -b newton current
sudo rm -rf /etc/yum.repos.d/rhos-*
