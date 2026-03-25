Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64" # Ubuntu 22.04 LTS

  # --- VM 1 : PASSERELLE ---
  config.vm.define "passerelle" do |p|
    p.vm.hostname = "passerelle"
    # Carte 1 : NAT (Internet) - automatique dans Vagrant
    # Carte 2 : DMZ
    p.vm.network "private_network", ip: "192.168.100.1", virtualbox__intnet: "dmz-net"
    # Carte 3 : LAN
    p.vm.network "private_network", ip: "192.168.10.1", virtualbox__intnet: "lan-net"
  end

  # --- VM 2 : SERVEUR WEB ---
  config.vm.define "web" do |w|
    w.vm.hostname = "serveur-web"
    w.vm.network "private_network", ip: "192.168.100.10", virtualbox__intnet: "dmz-net"
  end

  # --- VM 3 : SERVEUR BD ---
  config.vm.define "db" do |d|
    d.vm.hostname = "serveur-db"
    d.vm.network "private_network", ip: "192.168.10.10", virtualbox__intnet: "lan-net"
  end
end
