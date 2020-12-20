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

## Troubleshooting

# Kubernetes

## Troubleshooting
