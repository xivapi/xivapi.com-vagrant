# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # ------------------------------------------------------------------------------------
  # Enter the url you want
  # ------------------------------------------------------------------------------------


  config.vm.hostname = "xivapi.local"


  # ------------------------------------------------------------------------------------
  # Config - Leave this stuff
  # ------------------------------------------------------------------------------------
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.vm.network "private_network", ip: "%d.%d.%d.%d" % [rand(10..250), rand(10..250), rand(10..250), rand(10..250)]
  config.vm.synced_folder "../xivapi.com-v3", "/xivapi", type: "nfs"
  config.vm.synced_folder "../mogboard", "/mogboard", type: "nfs"
  config.vm.synced_folder "./", "/stack", type: "nfs"
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision :shell, path: "./stack/build_stack.sh"
  config.hostmanager.aliases = %w(mysql.local mogboard.local)
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.memory = 2048
    vb.cpus = 2
  end
end
