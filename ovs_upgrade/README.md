Role Name
=========

This role aims to provdie a tool for upgrading openvswitch from 2.6(newton) to 2.8(queens).

Requirements
============

This role requires:

* An ansible inventory file containing reacheable overcloud nodes (e.g hosts)


Role Variables
==============

Tripleo repos URL:

    tripleo_repos_url

Openvswitch config directory:

    ovs_config_dir

Openvswitch log directory:

    ovs_log_dir

Openvswitch run directory:

    ovs_run_dir

Whether DPDK is enabled on upgrading node:

    dpdk_enabled

DPDK port mapping ( name: pci_address):

    dpdk_ports

Dependencies
============

None

Example Playbook
================

An example playbook is provided in playbooks/ovs_upgrade.yml:

    ---
    - hosts: compute1
      gather_facts: true
      roles:
        - ovs_upgrade

Usage
=====

Clone ovs_upgrade role to undercloud dir:

    git clone https://github.com/zshi-redhat/ovs_upgrade.git
  
Copy playbook out of ovs_upgrade role:

    cp ovs_upgrade/playbooks/ovs_upgrade.yml
  
Execute ansible playbook:

    ansible-playbook -i ovs_upgrade/hosts ovs_upgrade.yml
