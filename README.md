# atlight-devops
# Projet DevOps : Déploiement d'un cluster EKS avec Terraform et Ansible

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
