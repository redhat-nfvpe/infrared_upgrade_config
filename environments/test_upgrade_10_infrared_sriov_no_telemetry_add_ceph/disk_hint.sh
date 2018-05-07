#!/bin/bash
source /home/stack/stackrc
openstack baremetal node set --property root_device='{"serial": "61866da068d916001f64317a14ceb1f4"}' storage-0
