#!/bin/bash
source /home/stack/stackrc

cd /opt

if [ -d  /opt/infrared_upgrade_config ]; then
    cd infrared_upgrade_config
    git pull
else
    sudo git clone https://github.com/redhat-nfvpe/infrared_upgrade_config
    cd infrared_upgrade_config
fi
sudo chown -R stack:stack /opt/infrared_upgrade_config

cd /opt/infrared_upgrade_config
cp ovs_upgrade/playbooks/ovs_upgrade.yml ./

bash ovs_upgrade/inventory/generate_inventory.sh
ansible-playbook -i /home/stack/hosts ovs_upgrade.yml 
