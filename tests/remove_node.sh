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
$STACK_ID $SERVER_ID

# remove compute service
source /home/stack/overcloudrc
SERVICE_RESULT=$(openstack compute service list -f value -c ID -c Host | grep compute-1)
SERVICE_ID=($SERVICE_RESULT)
SERVICE_ID=${SERVICE_ID[0]}
openstack compute service delete $SERVICE_ID

# remove entries in agents
AGENT_RESULT=$(openstack network agent list -f value -c ID -c Host | grep compute-1)
for AGENT in $AGENT_RESULT; do
    if [ "$AGENT" != "overcloud-novacompute-1.localdomain" ]; then
        openstack network agent delete $AGENT
    fi
done
