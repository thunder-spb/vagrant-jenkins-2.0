# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bento/centos-6.7"
  config.vm.box_check_update = false
  
  ## autoupdater for VirtualBox guest additions
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = false
  end
  
  config.vm.define "Jenkins-2.0_1.1_Alpha", primary: true do |vmdev|
    vmdev.vm.hostname = "jenkins2-alpha.local"	
    # Publish guest port 8080 on host port 8080
    vmdev.vm.network "forwarded_port", guest: 8080, host: 8080

    vmdev.vm.network "private_network", ip: "10.0.0.5"
    vmdev.vm.provider "virtualbox" do |vb|
    #   # Don't boot with headless mode. Use for debugging
    #   vb.gui = true
    
      # Use VBoxManage to customize the VM.
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      # The following line is needed for 2 CPUs to be recognized internally
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.name = "Jenkins-2.0-1.1-Alpha"
    end

    # Provision the box using a shell script
    # This script is copied into the box and then run
    vmdev.vm.provision :shell, :privileged => true, :path => "provision.sh"
  end
  puts " *** Jenkins instance available at http://10.0.0.5:8080/"
  puts " *** SSH Credentials: vagrant/vagrant"
end