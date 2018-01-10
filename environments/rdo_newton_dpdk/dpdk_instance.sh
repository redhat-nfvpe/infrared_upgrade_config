# 1.
# Create flavor
openstack flavor create  m1.dpdk --ram 4096 --disk 150 --vcpus 4

# 2.
# Set flavor property
openstack flavor set --property hw:cpu_policy=dedicated --property  hw:mem_page_size=large m1.dpdk

# 3.
# Create dpdk network
# 'segmentation id'  maps to NeutronNetworkVLANRanges: 'dpdk:1:1' in heat Template
# 'physical_network' maps to NeutronBridgeMappings: 'dpdk:br-link' in heat Template
neutron net-create net-dpdk --provider:network_type=vlan  --provider:segmentation_id=216 --provider:physical_network dpdk

# 4.
# Create dpdk subnet
# 'net-dpdk' is created in step 3.
neutron subnet-create --name net-dpdk-subnet --disable-dhcp --gateway 10.10.0.1 --allocation-pool start=10.10.0.2,end=10.10.0.50 net-dpdk 10.10.0.0/24

# 5.
# Customize image to allow root/password login
# 
virt-customize -a /var/lib/libvirt/images/centos.qcow2 --root-password password:redhat

# 6.
# Create glance image
glance image-create --name centos --disk-format qcow2 --container-format bare --file /var/lib/libvirt/images/centos.qcow2 --progress

# 7.
# Get neutron dpdk network ID
neutron net-list

# 8.
# Create dpdk instance with flavor + nic + image + vm_name
# 'net-id' is retrieved from step 7
# 'dpdk_vm' is the vm name
nova boot --flavor m1.dpdk --nic net-id=6712afe1-7903-485c-9c67-2b1b1178bbc8 --image centos dpdk_vm

