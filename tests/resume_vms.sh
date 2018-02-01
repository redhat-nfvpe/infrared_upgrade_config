#!/bin/bash

LOGIN_USER=$1

source /home/stack/overcloudrc

# wait a bit until the vms are stopped properly
sleep 30

FIP_1=$(openstack server show test-sriov_vf_1 -f value -c addresses | grep -oE '10\.9\.88\.[0-9]*')
FIP_2=$(openstack server show test-sriov_vf_2 -f value -c addresses | grep -oE '10\.9\.88\.[0-9]*')

# start the vms as they were stopped after reboot
openstack server start test-sriov_vf_1
openstack server start test-sriov_vf_2

# wait until the vms come online
until ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${FIP_1} 'true' ; do :; done
until ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${FIP_2} 'true' ; do :; done

# connect and recreate ip config
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${FIP_1} 'sudo ip addr add 10.0.10.2/24 dev eth1'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${FIP_1} 'sudo ip link set eth1 up'

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${FIP_2} 'sudo ip addr add 10.0.10.3/24 dev eth1'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${FIP_2} 'sudo ip link set eth1 up'
sleep 5


