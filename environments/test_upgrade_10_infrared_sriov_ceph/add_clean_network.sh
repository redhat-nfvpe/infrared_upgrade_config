#!/bin/bash
FILE_TO_REPLACE=$1
echo $FILE_TO_REPLACE
source /home/stack/stackrc
CLEAN_NETWORK=$(openstack network show ctlplane -f value -c id)
sed -i "s/##CLEANING_NETWORK_UUID##/${CLEAN_NETWORK}/g" ${FILE_TO_REPLACE}

