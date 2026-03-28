Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"

  # --- VM1 : PASSERELLE (Firewall/NAT/Router) ---
  config.vm.define "passerelle" do |p|
    # Redirection de port : Windows (8080) -> Passerelle (80)
    p.vm.network "forwarded_port", guest: 80, host: 8080
    p.vm.network "private_network", ip: "192.168.100.1" # Vers le Web
    p.vm.network "private_network", ip: "192.168.10.1"  # Vers la DB
    
    p.vm.provision "shell", inline: <<-SHELL
      echo "Configuration de la Passerelle..."
      sysctl -w net.ipv4.ip_forward=1
      iptables -F
      iptables -t nat -F
      # NAT : Redirection port 80 vers le port 3000 du Serveur Web
      iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.100.10:3000
      iptables -t nat -A POSTROUTING -p tcp -d 192.168.100.10 --dport 3000 -j MASQUERADE
      iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
      iptables -A FORWARD -p tcp -d 192.168.100.10 --dport 3000 -j ACCEPT
    SHELL
  end

  # --- VM2 : SERVEUR WEB (Node.js) ---
  config.vm.define "serveur-web" do |w|
    w.vm.network "private_network", ip: "192.168.100.10"
    
    # MODIFICATION : Synchronise ton dossier local avec la VM
    w.vm.synced_folder "./sama_web", "/home/vagrant/sama_web"

    w.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get install -y nodejs npm
      # Correction de la route par défaut pour le retour NAT
      ip route del default
      ip route add default via 192.168.100.1
      
      # Installation automatique des dépendances du projet
      cd /home/vagrant/sama_web
      npm install express mysql2
    SHELL
  end

  # --- VM3 : SERVEUR DB (MySQL Natif) ---
  config.vm.define "serveur-db" do |d|
    d.vm.network "private_network", ip: "192.168.10.10"
    d.vm.provision "shell", inline: <<-SHELL
      apt-get update
      # Installation MySQL sans interaction (pour éviter les blocages)
      export DEBIAN_FRONTEND=noninteractive
      apt-get install -y mysql-server
      
      # Ouverture réseau : Bind address à 0.0.0.0
      sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
      systemctl restart mysql
      
      # Création auto de la DB et de l'utilisateur mbene avec accès distant
      mysql -e "CREATE DATABASE IF NOT EXISTS appdb;"
      mysql -e "CREATE USER IF NOT EXISTS 'mbene'@'%' IDENTIFIED BY 'ton_mot_de_passe';"
      mysql -e "GRANT ALL PRIVILEGES ON appdb.* TO 'mbene'@'%';"
      mysql -e "FLUSH PRIVILEGES;"
    SHELL
  end
end