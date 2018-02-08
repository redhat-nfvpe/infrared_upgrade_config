#!/bin/bash
LOGIN_USER=$1

VNF_IP=$(openstack server list -f value -c Name -c Networks | grep vf_1 |  sed 's/.*, \(.*\);.*/\1/')

# first kill the ping process if still runs
ssh $LOGIN_USER@$VNF_IP "PROCESS=$(pgrep -f 'ping -D -w 4000 10.0.10.3'); kill-2 $PROCESS"

# then output file content
ssh $LOGIN_USER@$VNF_IP "cat /tmp/pingtest_output"


