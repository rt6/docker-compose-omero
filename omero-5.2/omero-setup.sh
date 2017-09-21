#!/bin/bash

source /etc/omero/omero.conf

export OMERO_SERVER OMERO_ADMIN OMERO_DB_NAME OMERO_DB_USER OMERO_DB_PASS OMERO_ROOT_PASS OMERO_DATA_DIR OMERO_TMPDIR OMERO_WEB_PORT PGPASSWORD

export PATH=$PATH:${OMERO_SERVER}/bin