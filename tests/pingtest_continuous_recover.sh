#!/bin/bash
LOGIN_USER=$1

source /home/stack/overcloudrc

# reboot the vnf
nova start test-sriov_dpdk_vf_2

VNF1_IP=$(openstack server list -f value -c Name -c Networks | grep vf_1 |  sed 's/.*, \(.*\);.*/\1/')
VNF2_IP=$(openstack server list -f value -c Name -c Networks | grep vf_2 |  sed 's/.*, \(.*\);.*/\1/')

# wait until it is accessible again
while ! ping -c 1 ${VNF2_IP} &> /dev/null; do sleep 1; done

# restore network connection
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${VNF1_IP} 'sudo ip addr add 10.0.10.3/24 dev eth1'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${VNF2_IP} 'sudo ip link set eth1 up'

# wait to test for pingtest again
sleep 60

# kill the ping process if still runs
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${VNF1_IP} 'PROCESS=$(pgrep -f "ping -D 10.0.10.3"); kill -2 $PROCESS'

# then output file content
echo "pingtest results between vms"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${VNF1_IP} "tail -n2 /tmp/pingtest_output"

# kill the pingtest on the undercloud and output results
PROCESS1=$(pgrep -f "ping -D ${VNF1_IP}")
kill -2 $PROCESS1

echo "pingtest result on external network"
tail -n2 /tmp/external_pingtest_output


