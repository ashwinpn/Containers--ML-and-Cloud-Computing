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
