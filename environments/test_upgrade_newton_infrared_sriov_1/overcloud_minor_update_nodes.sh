#!/bin/bash
source /home/stack/stackrc
function update_node_overcloud {
    local NODE_HOST=$1
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no heat-admin@$1 'sudo yum -y install python-pip'
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no heat-admin@$1 'cd /opt; sudo git clone https://github.com/openstack/tripleo-repos || true'
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no heat-admin@$1 'cd /opt/tripleo-repos; sudo pip install ./'
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no heat-admin@$1 'sudo tripleo-repos -b master current; sudo yum update -y kernel openvswitch;'
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no heat-admin@$1 'sudo tripleo-repos -b newton current'
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no heat-admin@$1 'sudo rm -rf /etc/yum.repos.d/rhos-*'
}
source /home/stack/stackrc
IPS=$(nova list | grep overcloud | awk '{ split($12, v, "="); print v[2]}')
readarray -t IPS <<<"$IPS"
for IP in "${IPS[@]}"; do
    update_node_overcloud $IP
done
