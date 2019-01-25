#!/bin/bash
set -e

PROJECT_PATH=`pwd`

echo "******************************"
echo "Run Travis Tests"
echo "******************************"
echo "Validating Packer files"
echo "******************************"
cd $PROJECT_PATH/
packer validate -var-file=packer/variables.json.example packer/db.json
packer validate -var-file=packer/variables.json.example packer/app.json
packer validate -var-file=packer/variables.json.example packer/immutable.json
packer validate -var-file=packer/variables.json.example packer/ubuntu16.json

echo "******************************"
echo "Validating Terraform files"
echo "******************************"
touch ~/.ssh/appuser && touch ~/.ssh/appuser.pub

cd $PROJECT_PATH/terraform/stage
mv terraform.tfvars.example terraform.tfvars
terraform init -backend=false && terraform validate && terraform get && tflint

cd $PROJECT_PATH/terraform/prod
mv terraform.tfvars.example terraform.tfvars
terraform init -backend=false && terraform validate && terraform get && tflint

echo "******************************"
echo "Validating Ansible files"
echo "******************************"
cd $PROJECT_PATH/ansible
ansible-lint playbooks/*.yml --exclude=roles/jdauphant.nginx
