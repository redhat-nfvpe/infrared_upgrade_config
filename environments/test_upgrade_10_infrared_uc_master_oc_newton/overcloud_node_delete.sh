#!/bin/bash

STACK_ID=$1
NODE_ID=$2

openstack overcloud node delete --stack $STACK_ID --templates /home/stack/tripleo-heat-templates-newton \
-e /home/stack/tripleo-heat-templates-newton/environments/puppet-pacemaker.yaml \
-e /home/stack/tripleo-heat-templates-newton/environments/network-isolation.yaml \
-e /home/stack/tripleo-heat-templates-newton/environments/net-single-nic-with-vlans.yaml \
-e /home/stack/test_upgrade_10_infrared_uc_master_oc_newton/network-environment.yaml \
-e /home/stack/tripleo-heat-templates-newton/environments/neutron-sriov.yaml \
--log-file overcloud_delete.log $NODE_ID
