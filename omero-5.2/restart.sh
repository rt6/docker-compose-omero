docker stop $(docker ps -a -q)
docker rm omero52
docker rmi omero-v5.2
docker build -t omero-v5.2 omero-5.2/
docker run -it --name omero52 -p 4064:4064 -p 80:80 -p 443:443  omero-v5.2 > omero-5.2/log

