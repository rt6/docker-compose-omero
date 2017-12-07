#!/bin/bash
. /etc/omero/omero-setup.sh
$OMERO_SERVER/bin/omero admin start --foreground
