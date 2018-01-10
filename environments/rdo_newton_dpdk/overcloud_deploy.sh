#!/bin/bash


openstack overcloud deploy --templates --control-scale 3 --compute-scale 2 --ceph-storage-scale 0 --control-flavor controller --compute-flavor compute -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml  -e /usr/share/openstack-tripleo-heat-templates/environments/neutron-ovs-dpdk.yaml -e /home/stack/rdo_newton_dpdk/network-environment.yaml --ntp-server pool.ntp.org --log-file overcloud_install.log
