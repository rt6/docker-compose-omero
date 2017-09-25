## Omero v.5.2.3 in a container

## How to deploy omero in 3 steps:

```sh
# 1) first download the omero v5.2.3 and ice 3.6 pacakge into this directory (omero-5.2)
wget http://downloads.openmicroscopy.org/latest/omero5.2/server-ice36.zip

# 2) build image
docker build -t omero-v5.2 omero-5.2/

# 3) start container
docker run -dit --name omero52 -p 4064:4064 -p 80:80 -p 443:443  omero-v5.2

# or

# 3) start container (you may wish to pipe the output to a log file)
# remember to press ctrl+p,q to exit container without terminating it
docker run -it --name omero52 -p 4064:4064 -p 80:80 -p 443:443  omero-v5.2 > omero-5.2/log 
```
## Store TLS/SSL certificate and private in nginx-ssl directory
If you do not have a certificate from CA, then you can generate unsigned SSL certificate and private key for test server:
```sh
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout omero.key -out omero.crt -batch
````



## After the container has start, you can enter the container to manage the omero server, web server and postgres server

```sh
# enter the container to do stuff with bash shell
docker exec -it omero52 bash

# once inside container you do things like...

    # inspect postgres db
    su postgress -c 'psql'
    
    # start stop omero
    su - omero
    ./bin/omero/admin status
    ./bin/omero/admin start
    ./bin/omero/admin stop
    ./bin/omero/web status
    ./bin/omero/web start
    ./bin/omero/web stop
    
```
