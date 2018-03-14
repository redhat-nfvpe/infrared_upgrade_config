#!/bin/bash
infrared virsh -v --host-address=127.0.0.2 --host-key=/root/.ssh/id_rsa --cleanup yes --kill yes --topology-nodes hybrid_undercloud:1,hybrid_controller:3 -e override.controller.memory=28672 -e override.undercloud.memory=28672 -e override.controller.cpu=4 -e override.undercloud.cpu=6

sleep 5

infrared virsh -v --topology-nodes hybrid_undercloud:1,hybrid_controller:3 -e override.controller.memory=28672 -e override.undercloud.memory=28672 -e override.controller.cpu=4 -e override.undercloud.cpu=6 --host-address 127.0.0.2 --host-key /root/.ssh/id_rsa --topology-network 3_bridges_1_net --image-url https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2

sleep 5

infrared tripleo-undercloud -vv -o install.yml \
    -o undercloud-install.yml \
    --version newton \
    --config-file ../infrared_upgrade_config/environments/rdo_newton_dpdk/undercloud.conf

sleep 5

infrared tripleo-undercloud -v \
    -o undercloud-images.yml \
    --images-task=import \
    --images-url=https://images.rdoproject.org/newton/rdo_trunk/current-tripleo/


sleep 5

infrared tripleo-overcloud -v -o overcloud-install.yml --version newton --deployment-files ../infrared_upgrade_config/environments/rdo_newton_dpdk --introspect=yes --tagging=yes --deploy=no -e provison_virsh_network_name=br-ctlplane --hybrid ../infrared_upgrade_config/environments/rdo_newton_dpdk/hybrid_nodes.json --vbmc-force yes

sleep 5

infrared tripleo-overcloud -vv -o overcloud-install.yml --version newton --deployment-files ../infrared_upgrade_config/environments/rdo_newton_dpdk --overcloud-script ../../../infrared_upgrade_config/environments/rdo_newton_dpdk/overcloud_deploy.sh --introspect=no --tagging=no --deploy=yes -e provison_virsh_network_name=br-ctlplane --hybrid ../infrared_upgrade_config/environments/rdo_newton_dpdk/hybrid_nodes.json --ansible-args="skip-tags=inventory_update" --vbmc-force yes


# OSP RUN

# cleanup
infrared virsh -v --host-address=127.0.0.2 --host-key=/root/.ssh/id_rsa --cleanup yes --kill yes --topology-nodes hybrid_undercloud:1,hybrid_controller:3 -e override.controller.memory=28672 -e override.undercloud.memory=28672 -e override.controller.cpu=4 -e override.undercloud.cpu=6

# create oc/uc instances
infrared virsh -v --topology-nodes hybrid_undercloud:1,hybrid_controller:3 -e override.controller.memory=28672 -e override.undercloud.memory=28672 -e override.controller.cpu=4 -e override.undercloud.cpu=6 --host-address 127.0.0.2 --host-key /root/.ssh/id_rsa --topology-network 3_bridges_1_net --image-url file:///opt/infrared_images/rhel-guest-image-7.4.qcow2

# install undercloud and import overcloud images
infrared tripleo-undercloud -vv -o install.yml     -o undercloud-install.yml     --version 10 --images-task rpm --build z8     --config-file ../infrared_upgrade_config/environments/rdo_newton_dpdk/undercloud.conf

# introspection
infrared tripleo-overcloud -v -o overcloud-install.yml --version 10 --deployment-files ../infrared_upgrade_config/environments/rdo_newton_dpdk --introspect=yes --tagging=yes --deploy=no -e undercloud_version=newton -e provison_virsh_network_name=br-ctlplane --hybrid ../infrared_upgrade_config/environments/rdo_newton_dpdk/hybrid_nodes.json --vbmc-force yes

# deploy overcloud
infrared tripleo-overcloud -vv -o overcloud-install.yml --version 10 --deployment-files ../infrared_upgrade_config/environments/rdo_newton_dpdk --overcloud-script ../../../infrared_upgrade_config/environments/rdo_newton_dpdk/overcloud_deploy.sh --introspect=no --tagging=no --deploy=yes -e undercloud_version=10 -e provison_virsh_network_name=br-ctlplane --hybrid ../infrared_upgrade_config/environments/rdo_newton_dpdk/hybrid_nodes.json --ansible-args="skip-tags=inventory_update" --vbmc-force yes


# update inventory
infrared tripleo-overcloud -vv -o overcloud-install.yml --version 10 --deployment-files ../infrared_upgrade_config/environments/rdo_newton_dpdk --overcloud-script ../../../infrared_upgrade_config/environments/rdo_newton_dpdk/overcloud_deploy.sh --introspect=no --tagging=no --deploy=yes -e undercloud_version=10 -e provison_virsh_network_name=br-ctlplane --hybrid ../infrared_upgrade_config/environments/rdo_newton_dpdk/hybrid_nodes.json --ansible-args="tags=inventory_update" --vbmc-force yes

# download ffu.repo (custom-script)
curl file.brq.redhat.com/~mcornea/tripleo/osp13/ffu_repo.yaml -o ./ffu.yaml

# undercloud ffu
export LANG=en_US.UTF-8

time infrared tripleo-upgrade     --undercloud-ffu-upgrade yes     --undercloud-ffu-releases '11,12,13'     --upgrade-ffu-workarounds true -e @workarounds.yaml -e @ffu.yaml
