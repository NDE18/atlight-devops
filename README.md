# atlight-devops : Déploiement d'un cluster EKS avec Terraform et Ansible

Ce projet DevOps automatise le déploiement d'un cluster **Amazon EKS** (Elastic Kubernetes Service) sur AWS à l'aide de **Terraform** pour la création des ressources AWS et de **Ansible** pour la configuration des nœuds du cluster.  
Le processus de déploiement est entièrement orchestré par le script `deploy.sh`, qui prend en charge toutes les étapes, de l'infrastructure à la configuration des nœuds.

---

##  **Objectif du projet**
- Déployer automatiquement un cluster Kubernetes (EKS) sur AWS.  
- Créer une infrastructure réseau sécurisée (VPC, subnets, NAT gateway).  
- Assurer la haute disponibilité avec plusieurs zones de disponibilité.  
- Automatiser la configuration des nœuds Kubernetes avec Ansible.  
- Rendre le cluster prêt à exécuter des workloads Kubernetes.  

---

##  **Architecture**
###  **VPC avec 4 subnets** :  
- **2 subnets publics** : pour le Load Balancing externe.  
- **2 subnets privés** : pour l'exécution sécurisée des nœuds EKS.  

###  **Internet Gateway et NAT Gateway** :  
- L'Internet Gateway permet aux subnets publics d'accéder à Internet.  
- Le NAT Gateway permet aux subnets privés d'accéder à Internet (exemple : téléchargement de packages).  

###  **IAM Roles** :  
- Un rôle IAM pour le cluster EKS.  
- Un rôle IAM pour le groupe de nœuds EC2 avec les permissions nécessaires.  

###  **Cluster EKS** :  
- Provision d'un cluster Kubernetes avec une version spécifiée.  
- Création d'un groupe de nœuds (Node Group) associé au cluster.  

---

##  **Technologies Utilisées**
| Technologie | Description |
|------------|-------------|
| **Terraform** | Infrastructure as Code (IaC) pour provisionner les ressources AWS |
| **Ansible** | Configuration Management pour installer et configurer les nœuds |
| **AWS** | Plateforme cloud pour héberger le cluster EKS |
| **Kubernetes** | Orchestration de conteneurs |
| **Docker** | Conteneurisation des applications |
| **SSH** | Accès sécurisé aux nœuds EC2 |

---

##  **Prérequis**
Avant de commencer le déploiement, assurez-vous d'avoir :  
 **Terraform** ≥ 1.5.0 → [Installation Terraform](https://developer.hashicorp.com/terraform/downloads)  
 **Ansible** ≥ 2.10 → `pip install ansible`  
 **AWS CLI** → `brew install awscli` ou [Documentation AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)  
 **kubectl** → `brew install kubectl` ou [Documentation Kubernetes](https://kubernetes.io/docs/tasks/tools/)  
 **Clé SSH** dans `~/.ssh/id_rsa.pub` (nécessaire pour l'accès aux nœuds EC2)  

---

##  **Structure du Projet**
```
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
├── ansible/
│   ├── ansible.cfg
│   ├── playbook.yml
│   ├── inventory
├── deploy.sh
└── README.md
```

---

## **Déploiement Automatisé avec `deploy.sh`**
Le fichier **`deploy.sh`** est le point d'entrée principal du projet.  
Ce script automatise toutes les étapes du déploiement :  

1. **Initialisation de Terraform**  
2. **Planification de l'infrastructure**  
3. **Application du plan Terraform**  
4. **Extraction des adresses IP des nœuds pour Ansible**  
5. **Exécution du playbook Ansible pour configurer les nœuds**  

---

###  **Exécution du script**  
Dans le répertoire racine du projet, lancez :  
```bash
chmod +x deploy.sh
./deploy.sh
```

### **Contenu du fichier `deploy.sh`**
```bash
#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Initialisation de Terraform
echo "Initialisation de Terraform..."
cd terraform
terraform init

# Planification Terraform
echo "Planification de Terraform..."
terraform plan

# Application Terraform
echo "Application de Terraform..."
terraform apply -auto-approve

# Extraction des IP des nœuds pour Ansible
echo "Récupération des IP des nœuds..."
terraform output -json node_ips | jq -r '.[] | "node ansible_host=\(.) ansible_user=ec2-user"' > ../ansible/inventory

# Configuration avec Ansible
echo "Configuration du cluster avec Ansible..."
cd ../ansible
ansible-playbook playbook.yml
```

---

## 🔍 **Détails Techniques**
###  **Terraform**  
| Fichier | Description |
|---------|-------------|
| `main.tf` | Crée le VPC, les subnets, et le cluster EKS. Configure les rôles IAM. |
| `provider.tf` | Configure le fournisseur AWS. |
| `variables.tf` | Définit les paramètres du cluster (nom, version, région). |
| `outputs.tf` | Expose les résultats après le déploiement (nom du cluster, endpoint, IP des nœuds). |

---

###  **Ansible**  
| Fichier | Description |
|---------|-------------|
| `ansible.cfg` | Configure Ansible (désactive la vérification des clés SSH). |
| `playbook.yml` | Configure les nœuds EC2 (installation de Docker, kubectl, et kubeconfig). |
| `inventory` | Fichier généré automatiquement par le script `deploy.sh` contenant les IP des nœuds. |

---

###  **Playbook Ansible : `playbook.yml`**
Principales étapes :  
 Installe Docker et Git sur les nœuds.  
 Lance le service Docker.  
 Installe `kubectl` (compatible avec la version du cluster).  
 Configure le fichier `kubeconfig` pour le contrôle du cluster.  
 Vérifie la connectivité du cluster avec `kubectl get nodes`.  

---

##  **Commandes Utiles**
| Commande | Description |
|----------|-------------|
| `terraform init` | Initialise Terraform dans le répertoire de travail |
| `terraform plan` | Prépare un plan d'exécution Terraform |
| `terraform apply -auto-approve` | Applique le plan Terraform |
| `terraform destroy` | Supprime toutes les ressources créées |
| `ansible-playbook playbook.yml` | Lance le playbook Ansible sur les nœuds |
| `kubectl get nodes` | Vérifie l'état des nœuds du cluster |

---

##  **Résultat Attendu**
-  Un cluster EKS entièrement configuré sur AWS.  
-  Des nœuds EC2 configurés avec Docker et Kubernetes.  
-  Un cluster opérationnel prêt à exécuter des workloads Kubernetes.  
-  Une connectivité réseau sécurisée grâce au NAT Gateway et aux subnets privés/publics.  

---

## **Nettoyage**
Pour supprimer toutes les ressources :  
```bash
cd terraform
terraform destroy -auto-approve
```
