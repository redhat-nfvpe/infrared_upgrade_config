# disable the service
source /home/stack/overcloudrc
openstack compute service set overcloud-novacompute-1.localdomain nova-compute --disable

# remove the node
source /home/stack/stackrc
STACK_ID=$(openstack stack list -f value -c ID)

SERVER_RESULT=$(openstack server list -f value -c ID -c Name | grep compute-1)
SERVER_ID=($SERVER_RESULT)
SERVER_ID=${SERVER_ID[0]}

bash /home/stack/test_upgrade_10_infrared_uc_master_oc_newton/overcloud_node_delete.sh \
$STACK_ID $NODE_ID
