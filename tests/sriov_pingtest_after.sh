#!/bin/bash

LOGIN_USER=$1

source /home/stack/overcloudrc


# now test ping between vms
OUTPUT=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${LAST_FIP_1} 'ping -q -w 1 10.0.10.3; echo "result$?"')
if [[ "$OUTPUT" == *"result1"* ]]; then
    echo "ping failed"
    exit 1
else
    echo "ping successful"
fi

OUTPUT=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${LOGIN_USER}@${LAST_FIP_2} 'ping -q -w 1 10.0.10.2; echo "result$?"')
if [[ "$OUTPUT" == *"result1"* ]]; then
    echo "ping failed"
    exit 1
else
    echo "ping successful"
fi

