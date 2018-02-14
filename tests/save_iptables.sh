#!/bin/bash
source /home/stack/stackrc

COMPUTE1_IP=$(openstack server list -f value -c Name -c Networks | grep compute-0 |  cut -d ' ' -f2 | cut -d '=' -f2 )
COMPUTE2_IP=$(openstack server list -f value -c Name -c Networks | grep compute-1 |  cut -d ' ' -f2 | cut -d '=' -f2 )

# ssh into the vms and save iptables
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null heat-admin@${COMPUTE1_IP} 'sudo bash -c "iptables-save > /etc/sysconfig/iptables"'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null heat-admin@${COMPUTE2_IP} 'sudo bash -c "iptables-save > /etc/sysconfig/iptables"'

