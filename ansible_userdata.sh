#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install ansible2 -y
# test ansible
echo -e "- hosts: localhost\n  tasks:\n    - name: Test Connection\n      ping:" > test_playbook.yml
ansible-playbook test_playbook.yml
