# Deploy Omero on Docker

## Requirements
- Docker
- Docker-Compose

## Instructions

### Install

Note: All images will be built the first time you run. This will take a some time > 10 minutes.

```sh
git clone git@github.com:rt6/docker-compose-omero.git
mkdir omero-data
cd docker-compose-omero
sudo make build-base
sudo make build-start
```

### Stop and Restart containers
```sh
sudo make stop-containers
sudo make start-containers
```

### List status of running/stopped containers
```
sudo make status
```
