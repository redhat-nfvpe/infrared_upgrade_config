#!/bin/bash

openstack overcloud deploy --debug --templates --control-scale 3 --compute-scale 2 --ceph-storage-scale 0 \
-e /home/stack/tripleo-heat-templates-newton/environments/puppet-pacemaker.yaml \
-e /home/stack/tripleo-heat-templates-newton/environments/network-isolation.yaml \
-e /home/stack/tripleo-heat-templates-newton/environments/net-single-nic-with-vlans.yaml \
-e /home/stack/test_upgrade_10_infrared_uc_master_oc_newton/network-environment.yaml \
-e /home/stack/tripleo-heat-templates-newton/environments/neutron-sriov.yaml \
--ntp-server pool.ntp.org --log-file overcloud_install.log
