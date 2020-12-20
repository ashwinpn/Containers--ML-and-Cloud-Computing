Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vagrant.plugins = "vagrant-docker-compose"

  # install docker and docker-compose
  config.vm.provision :docker
  config.vm.provision :docker_compose

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--memory", "8000"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

end
