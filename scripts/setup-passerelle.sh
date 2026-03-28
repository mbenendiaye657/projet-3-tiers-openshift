#!/bin/bash

# 1. Nettoyage des anciennes règles
sudo iptables -F
sudo iptables -P FORWARD DROP

# 2. Activation du forwarding IPv4
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 3. NAT pour l'accès Internet (Masquerade)
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# 4. RÈGLE : La DB (192.168.10.10) peut accéder au WEB (192.168.100.10) et à Internet
sudo iptables -A FORWARD -s 192.168.10.10 -j ACCEPT

# 5. RÈGLE : Le WEB (192.168.100.10) peut accéder à Internet
# On autorise le WEB vers l'interface WAN (eth0) uniquement
sudo iptables -A FORWARD -s 192.168.100.10 -o eth0 -j ACCEPT

# 6. RÈGLE : Internet peut pinger le WEB
# On autorise l'ICMP (ping) entrant vers l'IP du Web
sudo iptables -A FORWARD -p icmp -d 192.168.100.10 -j ACCEPT
sudo iptables -A FORWARD -p icmp -d enp0s9 -j ACCEPT
# Autorise la DB (192.168.10.10) à pinger le Web (192.168.100.10)
sudo iptables -A FORWARD -p icmp -s 192.168.10.10 -d 192.168.100.10 -j ACCEPT

# 7. RÈGLE : Sécurité pour le WEB -> DB (INTERDIT)
# Cette règle est déjà couverte par le "POLICY DROP", mais on peut l'expliciter :
sudo iptables -A FORWARD -s 192.168.100.10 -d 192.168.10.10 -j REJECT

# 8. Autoriser les réponses aux connexions déjà établies
# (Pour que le Web puisse répondre à la DB quand elle le contacte)
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT