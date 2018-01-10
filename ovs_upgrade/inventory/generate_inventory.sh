#!/bin/bash

inventory="/home/stack/hosts"

# delete old inventory file
rm -rf $inventory

# generate new inventory file
source /home/stack/stackrc

# retrieve & save overcloud nodes
echo "[overcloud_nodes]" > $inventory
nova list | awk '$1 !~ /^\+/ && NR>3 {print $12}' | cut -d = -f2 >> $inventory
echo "" >> $inventory

# retrieve & save controller IPs
echo "[controller]" >> $inventory
nova list | awk '$1 !~ /^\+/ && NR>3 && $0 ~ /control/ {print $12}' | cut -d = -f2 >> $inventory
echo "" >> $inventory

# retrieve & save compute IPs
echo "[compute]" >> $inventory
nova list | awk '$1 !~ /^\+/ && NR>3 && $0 ~ /compute/ {print $12}' | cut -d = -f2 >> $inventory
echo "" >> $inventory

# set vars
echo "[overcloud_nodes:vars]" >> $inventory
echo "ansible_ssh_user=heat-admin" >> $inventory
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $inventory
echo "" >> $inventory

echo "[controller:vars]" >> $inventory
echo "ansible_ssh_user=heat-admin" >> $inventory
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $inventory
echo "" >> $inventory

echo "[compute:vars]" >> $inventory
echo "ansible_ssh_user=heat-admin" >> $inventory
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $inventory
