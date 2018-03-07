#!/bin/bash

openstack overcloud deploy --templates --control-scale 3 --compute-scale 1 --ceph-storage-scale 0 \
-e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml \
-e /home/stack/test_upgrade_10_infrared_uc_master_oc_newton/network-environment.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-sriov.yaml \
--ntp-server clock.redhat.com --log-file overcloud_install.log
