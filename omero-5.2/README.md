## Omero v.5.2.3 in a container

## How to use:

```sh
# first download the omero v5.2.3 and ice 3.6 pacakge into this directory (omero-5.2)
wget http://downloads.openmicroscopy.org/latest/omero5.2/server-ice36.zip

# build image
docker build -t omero-v5.2 omero-5.2/

# start container
docker run -dit --name omero52 -p 4064:4064 -p 80:80 -p 443:443  omero-v5.2

# start container (you may wish to pipe the output to a log file)
# remember to press ctrl+p,q to exit container without terminating it
docker run -it --name omero52 -p 4064:4064 -p 80:80 -p 443:443  omero-v5.2 > omero-5.2/log 

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
