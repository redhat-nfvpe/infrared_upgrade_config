# 1.
# Create flavor
openstack flavor create  m1.sriov --ram 4096 --disk 150 --vcpus 4

# 2.
# Set flavor property
openstack flavor set --property hw:cpu_policy=dedicated --property  hw:mem_page_size=large m1.sriov

# 3.
# Create sriov network
# 'segmentation id'  maps to NeutronNetworkVLANRanges: 'sriov:1:1' in heat Template
# 'physical_network' maps to NeutronBridgeMappings: 'sriov:br-sriov' in heat Template
neutron net-create net-sriov --provider:network_type=vlan  --provider:segmentation_id=1 --provider:physical_network sriov

# 4.
# Create sriov subnet
# 'net-sriov' is created in step 3.
neutron subnet-create --name net-sriov-subnet --disable-dhcp --gateway 10.10.0.1 --allocation-pool start=10.10.0.2,end=10.10.0.50 net-sriov 10.10.0.0/24

# 5.
# Customize image to allow root/password login
# 
virt-customize -a /var/lib/libvirt/images/centos.qcow2 --root-password password:redhat

# 6.
# Create glance image
glance image-create --name centos --disk-format qcow2 --container-format bare --file /var/lib/libvirt/images/centos.qcow2 --progress

# 7.
# Create sriov VF port
# 'net-sriov' is created in step 3.
# 'sriov_port' is the sriov port name
openstack port create --network net-sriov --vnic-type direct sriov_port

# 8.
# Get neutron sriov port ID
neutron port-list

# 9.
# Create sriov instance with flavor + nic + image + vm_name
# 'port-id' is retrieved from step 8
# 'sriov_vm' is the vm name
nova boot --flavor m1.sriov --nic port-id=6712afe1-7903-485c-9c67-2b1b1178bbc8 --image centos sriov_vm

