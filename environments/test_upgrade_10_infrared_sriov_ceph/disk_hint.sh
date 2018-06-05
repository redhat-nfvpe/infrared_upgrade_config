#!/bin/bash
source /home/stack/stackrc
openstack baremetal node set storage-0 --property root_device='{"serial": "61866da068d916001f64317a14ceb1f4"}'
openstack baremetal node set storage-1 --property root_device='{"serial": "61866da0ae17a10021147d4606828bce"}'
openstack baremetal node set storage-2 --property root_device='{"serial": "61866da0ae0db1002114aa2a052b7e91"}'
