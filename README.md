# Deploy Omero on Docker

### Requirements
- Docker
- Docker-Compose

### Instructions
```sh
git clone git@github.com:rt6/docker-compose-omero.git
mkdir omero-data
cd docker-compose-omero
sudo sh build-base-image.sh
sudo docker-compose up
```
