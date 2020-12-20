# Containers
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
- I initially used ```bash alpine ``` for my dockerfile, but ran into a lot of issues when I started building the docker image. 
Specifically, I faced networking issues, memory errors and had to spend a lot of time with the ```bash pip install ``` commands because they were not running smoothly. 
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

## Troubleshooting

# Kubernetes

## Troubleshooting
