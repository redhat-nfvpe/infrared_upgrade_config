#!/usr/bin/env python
import json

data = json.load(open('/home/stack/instackenv.json'))

# remove all nodes
data['nodes'] = []

# create new entry for compute-1
new_node = {
    "name": "compute-1",
    "mac": ["A0:36:9F:BA:04:1C"],
    "cpu": "12",
    "memory": "131072",
    "disk": "558",
    "arch": "x86_64",
    "pm_type": "pxe_ipmitool",
    "pm_user": "TripleO",
    "pm_password": "TripleO",
    "pm_addr": "10.9.87.30",
    "capabilities": "profile:compute,boot_option:local"
}
data['nodes'].append(new_node)

# write content to new file
with open('/home/stack/instackenv_new.json', 'w') as f:
    json.dump(data, f)
