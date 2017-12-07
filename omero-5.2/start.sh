#!/bin/bash

echo
echo 'OMERO user environment variables'
echo '******************************************'
source /etc/omero/omero-setup.sh
echo "source /etc/omero/omero-setup.sh" >> /opt/omero/.bashrc
su omero -c 'printenv'
echo '******************************************'
echo

##Create omero data directory
mkdir -p "$OMERO_DATA_DIR"
chown -R omero:omero "$OMERO_DATA_DIR"

#################
## OMERO server
#################
su omero -c 'cd /opt/omero &&  unzip OMERO.server*.zip'
su omero -c 'rm /opt/omero/OMERO.server*.zip'
#RUN rm OMERO.server-ice36.zip

service postgresql start
#sleep 5

# Wait for postgre server to be up
#while ! pg_isready -h $HOST -p $PORT -d omero -U omero --quiet; do
while ! pg_isready -h localhost -p 5432; do
    echo "Waiting for database server to be up."
    sleep 5s;
done

echo
echo 'create OMERO database user'
echo '******************************************'
mkdir -p /data/omero-tmp/omero-volatile/tmp
chown omero:omero /data/omero-tmp/omero-volatile/tmp
echo "CREATE USER $OMERO_DB_USER PASSWORD '$OMERO_DB_PASS'" | su - postgres -c psql
su - postgres -c "createdb -E UTF8 -O '$OMERO_DB_USER' '$OMERO_DB_NAME'"
su postgres -c 'psql -P pager=off -h localhost -U "$OMERO_DB_USER" -l'

##Configure OMERO server
echo
echo 'configure omero server'
echo '******************************************'
cd /opt/omero
su omero -c 'ln -s OMERO.server-* OMERO.server'
su omero -c 'OMERO.server/bin/omero config set omero.data.dir "$OMERO_DATA_DIR"'
su omero -c 'OMERO.server/bin/omero config set omero.db.name "$OMERO_DB_NAME"'
su omero -c 'OMERO.server/bin/omero config set omero.db.user "$OMERO_DB_USER"'
su omero -c 'OMERO.server/bin/omero config set omero.db.pass "$OMERO_DB_PASS"'
su omero -c 'OMERO.server/bin/omero db script -f OMERO.server/db.sql --password "$OMERO_ROOT_PASS"'

su postgres -c 'psql -h localhost -U "$OMERO_DB_USER" "$OMERO_DB_NAME" <OMERO.server/db.sql'

# install django and gunicorn
pip install -r OMERO.server/share/web/requirements-py27-nginx.txt

##Configure web server
echo
echo 'configure omero web server'
echo '******************************************'
su omero -c 'OMERO.server/bin/omero web config nginx --http "$OMERO_WEB_PORT"> OMERO.server/nginx.conf.tmp'
#cp ~omero/OMERO.server/nginx.conf.tmp /etc/nginx/sites-available/omero-web
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/omero-web /etc/nginx/sites-enabled/
#echo "daemon off;" >> /etc/nginx/nginx.conf
#service nginx start

# ubuntu 16.04 requires enabling the postgresql.service so postgres automatically starts when rebooted
systemctl enable postgresql.service
#service supervisor start
#supervisorctl start all

# start omero server before omero web
#su omero -c 'OMERO.server/bin/omero admin start --foreground'
#su - omero -c 'OMERO.server/bin/omero web start'

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

 #exec "$@";
