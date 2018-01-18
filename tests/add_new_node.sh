source /home/stack/overcloudrc
openstack overcloud node import /home/stack/instackenv_new.json

openstack overcloud image upload --update-existing
openstack overcloud node introspect --all-manageable
openstack overcloud node provide --all-manageable

IRONIC_RESULT=$(openstack baremetal node list -f value -c UUID -c Name | grep compute-1)
IRONIC_ID=($IRONIC_RESULT)
IRONIC_ID=${IRONIC_ID[0]}
openstack baremetal node set --property capabilities='profile:compute,boot_option:local' $IRONIC_ID

KERNEL_RESULT=$(openstack image list -f value -c ID -c Name | grep "bm-deploy-kernel" | head -n1)
KERNEL_ID=($KERNEL_RESULT)
KERNEL_ID=${KERNEL_ID[0]}
openstack baremetal node set --driver-info deploy_kernel="$KERNEL_ID" $IRONIC_ID

RAMDISK_RESULT=$(openstack image list -f value -c ID -c Name | grep "bm-deploy-ramdisk" | head -n1)
RAMDISK_ID=($RAMDISK_RESULT)
RAMDISK_ID=${RAMDISK_ID[0]}
openstack baremetal node set --driver-info deploy_ramdisk="$RAMDISK_ID" $IRONIC_ID

bash /home/stack/test_upgrade_10_infrared_uc_master_oc_newton/overcloud_deploy_scale.sh
