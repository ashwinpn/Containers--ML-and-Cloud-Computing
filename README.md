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
## Running on GCP with Google Kubernetes Engine
![k8s](https://github.com/ashwinpn/Containers-and-Cloud-Computing/blob/main/resources/hw4_16.JPG)

## Troubleshooting

# Vagrant v/s Docker Comparison

Setting up the project to work in vagrant and docker for the fist time took a while for both docker and
vagrant, but for the subsequent times, starting up and running our project in docker was much more
faster than vagrant - however, setting up the project workflow was better in vagrant. Both vagrant
and docker have dedicated communities if you require any help for troubleshooting any issues, but the
docker documentation and forums are more user friendly and docker in general has many resources,
tutorials, and guides available. For instance, one major disadvantage with vagrant is that there is a
lesser scope for collaboration [even with Vagrant Cloud] - when working with docker, we can easily
push our docker images to our Docker Hub repo, and your teammates/others can pull the container
and run the application. Docker also has support for functions similar to git, where we can track
different versions of a container, see the changes (diff) between the versions, and provides support for
updating via commits. While provisioning can potentially get messy in both vagrant and docker [e.g.
pip install instructions - need to check conflicting dependencies and updates to eliminate probable
errors], vagrant based provisioning can be a big headache because I personally had to spend about half
an hour for debugging the provisioner shell in the vagrantfile, making sure that all packages had the
suitable versions to enable working with each other. Regarding vagrant, while a completely virtualized
system provides more isolation, it also comes at the cost of more resources being allocated to it [it
is heavier], and has minimum sharing capability. With docker we have less isolation [it has sufficient
support to isolate processes from each other though], but the containers are lightweight (require fewer
resources, and they share the same kernel). We cannot run completely different operating systems in
containers like we do in virtual machines, however it is possible to run different distros [distributions] of
Linux since they do share the same kernel. Talking about booting times, when we load a container we
don’t have to start a new copy of the operating system like in a virtual machine, so booting times are
smaller. Unlike virtual machines, we also do not have to pre-allocate a considerable amount of memory
and hardware resources when working with containers.

## Summary
- Docker containers are faster to start (and also to stop). One of the reasons behind this is probably
the fact that docker leverages the existing host OS [which already has major system processes
initialized], whereas with vagrant we have to load a whole vm image [and also initialize major
system processes].

- With regards to isolation, vagrant fares better. But with docker we can still get isolation at the
user level since a docker container runs as an isolated process. Also, we can collaborate better by
using Docker Hub.

- Vagrant in general is heavy, as compared to docker which is lightweight because it includes only
those libraries which are extremely necessary to the application as a part of the container image.

- Docker will require fewer amount of resources than vagrant, since we only need to load the libraries
which are necessary/essential for the application. Therefore, for a given value for computing
capacity, we can have more applications which are running. On the other hand, vagrant has to
load a whole OS in the memory, and thus it will always lead to more consumption of resources.

## Case Study
```We derive insights on performance by using the profile, cProfile, and pstats modules for profiling purposes.```

- With docker it took seconds to start up, whereas for vagrant it took minutes.

- The total execution time on docker was ```24m 38s 19ms```, compared to the total execution time on
vagrant, which was ```27m 08s 34ms```, and thus on docker it was smaller.

- Average training time per epoch on docker was ```2m 27s 78ms```, while the average training time per
epoch on vagrant was ```2m 42s 79ms```. Best of 3 average training time on docker was ```2m 25s 41ms```,
and on vagrant it was ```2m 41s 07ms```.

- Average memory usage per epoch on docker was ```peak memory: 450.03 MiB```, whereas for vagrant
it was ```peak memory: 448.63 MiB```. The difference here was negligible.

- Regarding line-by-line analysis for the application code: for docker we had ```4616095 function calls (4612290 primitive calls) in 11.988 seconds```, and for vagrant we had ```4616095 function calls (4612290 primitive calls) in 16.632 seconds```.


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
4. Install <ins>cuda, nvcc, gcc, and g++</ins>:
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
