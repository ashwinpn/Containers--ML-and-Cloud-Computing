# Containers and Cloud Computing

- Containers have become very important to deep learning as it is critical to leverage them to ensure scalability, now that computer scientists are capable of developing ML applications which can run seamlessly on smartphones too.

![cont](https://github.com/ashwinpn/Containers/blob/main/resources/cool.png)

# Docker

## Troubleshooting
- Docker Daemon Permission Denied :
  ```bash
  sudo usermod -aG docker ${USER}
  su -${USER}
  ```
- Cannot connect to the docker daemon :
  ```bash
  systemctl start docker
  ```
- Error processing Tar / No space left on device:
  ```bash
  docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")
  OR
  docker system prune, docker image prune
  ```
- Conflict => already in use:
  ```bash
  Find CONTAINER_ID using docker ps -a
  
  Use docker start <CONTAINER_ID> instead of docker run
  ```
- I initially used ```alpine ``` for my dockerfile, but ran into a lot of issues when I started building the docker image. 
Specifically, I faced networking issues, memory errors and had to spend a lot of time with the ```pip install ``` commands because they were not running smoothly. 
Thus, I decided against using alpine as I felt that the issues that came up due to its use defeated the purpose of using containers in the first place - 
which is to make our job easier while building environments and running code. Also, I felt that the time spent debugging and dealing with errors does not 
compensate for the small docker image size which alpine provides.
## Cases

### <ins>pytorch_mnist</ins>
- Run
```bash
docker build -t asn/pyt .

docker run -i -t asn/pyt:latest
```
- Check container status using
```bash
docker ps -a
```

# Vagrant
- Starting up a vagrant environment via a virtualbox.
Run
```bash
vagrant up

vagrant ssh

[If it says "Machine already provisioned"]

vagrant provision
```
- Configuring the vagrantfile [vagrantfiles are written in Ruby]. Here, we provision docker - which means that we can start working with docker as soon as we start up using ``` vagrant up``` and ```vagrant ssh``` command.

```ruby
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
```

- Provisioning in vagrant using the shell.

Use the ```-y``` option with ```apt-get``` to enable non-interactive installation. That is, no more "X amount of data would be downloaded on installing Y. Do you still want to continue? [Y|N]"
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  
   config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = false

     # Customize the amount of memory on the VM:
     vb.memory = "2048"
   end
 
   config.vm.provision "shell", inline: <<-SHELL
     sudo apt-get -y upgrade apt-get update
     sudo apt-get -y install python3.8 python3.8-dev python3.8-distutils python3.8-venv
     sudo apt-get -y install git-all python-dev 
     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
     python3.8 get-pip.py
     pip install future nose mock coverage numpy flake8  
     pip --no-cache-dir install torch torchvision
   SHELL
end

```

## Troubleshooting

# Kubernetes

```bash
kubectl create -f dply.yaml

kubectl get pods

kubectl get deployments

kubectl expose deployment sentiment-inference-service --type=LoadBalancer --port 80 --target-port 8080
```

## Troubleshooting


# Machine Learning
## Running GPU profilers on the cloud [Google Colab Pro]
1. Change runtime type selecting GPU as hardware accelerator
2. Git clone this repository:
```
!git clone https://github.com/ashwinpn/imgnet.git
```
3. Change permissions:
```
!chmod 755 imgnet/INSTALL.sh
``` 
4. Install cuda, nvcc, gcc, and g++:
```
!./imgnet/INSTALL.sh
```
5. Add `/usr/local/cuda/bin` to `PATH`:
```python
import os
os.environ['PATH'] += ':/usr/local/cuda/bin'
```
6. Run [Example, imagenet]
```
!nvprof python main.py -a alexnet -b 8 --epochs 1 --lr 0.01 <Training and Validation folders parent directory>
```
