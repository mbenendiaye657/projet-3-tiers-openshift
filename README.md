# ☁️ Projet Infrastructure 3-Tiers Automatisée (Vagrant & Shell)

Ce projet implémente une infrastructure réseau virtualisée, segmentée et sécurisée à l'aide de **Vagrant** et de scripts de provisioning **Shell**. L'objectif est de simuler un environnement Cloud avec une séparation stricte des couches applicatives.

## 🏗️ Architecture Réseau
L'infrastructure repose sur 3 machines virtuelles Debian interconnectées :

1.  **VM1 : Passerelle (Gateway / Firewall)**
    - **Interface Externe** : NAT avec redirection de port (Host:8080 -> Guest:80).
    - **Interface Interne 1** (DMZ) : `192.168.100.1`
    - **Interface Interne 2** (LAN DB) : `192.168.10.1`
    - **Services** : Routage IP (`ip_forward`), NAT (DNAT/MASQUERADE) via `iptables`.

2.  **VM2 : Serveur Web (Application Layer)**
    - **IP** : `192.168.100.10`
    - **Techno** : Node.js & Express.
    - **Sécurité** : Route par défaut forcée vers la passerelle pour tout flux sortant.

3.  **VM3 : Serveur DB (Database Layer)**
    - **IP** : `192.168.10.10`
    - **Techno** : MySQL (Écoute sur toutes les interfaces `0.0.0.0`).
    - **Accès** : Utilisateur `mbene` autorisé pour les connexions distantes (`%`).

## 🚀 Déploiement

### 1. Prérequis
- VirtualBox installé.
- Vagrant installé.
- Git installé.

### 2. Lancement
Clonez le dépôt et lancez l'orchestration :
```bash
git clone [https://github.com/mbenendiaye657/Sama_Web_Projet.git](https://github.com/mbenendiaye657/Sama_Web_Projet.git)
cd Sama_Web_Projet
vagrant up
