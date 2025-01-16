#!/bin/bash

# Arrêter le script en cas d'erreur
 set -e
#
 echo "Initialisation de Terraform..."
 cd terraform
 terraform init
#
 echo "Planification de Terraform..."
 terraform plan
#
 echo "Application de Terraform..."
 terraform apply -auto-approve
#
# # Extraire les IP des nœuds pour Ansible
 echo "Récupération des IP des nœuds..."
 terraform output -json node_ips | jq -r '.[] | "node ansible_host=\(.) ansible_user=ec2-user"' > ../ansible/inventory

#
 echo "Configuration du cluster avec Ansible..."
 cd ../ansible
 ansible-playbook playbook.yml