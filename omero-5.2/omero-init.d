#!/bin/bash
#
# /etc/init.d/omero
# Subsystem file for "omero" server
#
### BEGIN INIT INFO
# Provides:             omero
# Required-Start:       $local_fs $remote_fs $network $time postgresql
# Required-Stop:        $local_fs $remote_fs $network $time postgresql
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    OMERO.server
### END INIT INFO
#
### Redhat
# chkconfig: - 98 02
# description: Init script for OMERO.server
###

RETVAL=0
prog=omero

# Read configuration variable file if it is present
[ -r /etc/default/$prog ] && . /etc/default/$prog

OMERO_SERVER=${OMERO_SERVER:-/opt/omero/OMERO.server}
OMERO_USER=${OMERO_USER:-omero}
OMERO=${OMERO_SERVER}/bin/omero

START_LOG=${OMERO_SERVER}/var/log/${prog}-start.log
STOP_LOG=${OMERO_SERVER}/var/log/${prog}-stop.log

start() {
    echo -n $"Starting OMERO.server... "
    su - ${OMERO_USER} -c "${OMERO} admin start" &> ${START_LOG}
    RETVAL=$?
    if [[ "${RETVAL}" == "0" ]]; then
        echo "started."
    else
        echo "failed. see ${START_LOG} for details."
    fi
    return ${RETVAL}
}

stop() {
    echo -n $"Stopping OMERO.server... "
    su - ${OMERO_USER} -c "${OMERO} admin stop" &> ${STOP_LOG}
    RETVAL=$?
    if [[ "${RETVAL}" == "0" ]]; then
        echo "stopped."
    else
        echo "failed. see ${STOP_LOG} for details."
    fi
    return ${RETVAL}
}

status() {
    echo -n "OMERO.server status... "
    su - ${OMERO_USER} -c "${OMERO} admin status"
    RETVAL=$?
    if [[ "${RETVAL}" == "0" ]]; then
        echo "[RUNNING]"
    else
        echo "[NOT STARTED]"
    fi
    return ${RETVAL}
}

diagnostics() {
    su - ${OMERO_USER} -c "${OMERO} admin diagnostics"
}

case "$1" in
    start)
        start
        RETVAL=$?
        ;;
    stop)
        stop
        RETVAL=$?
        ;;
    restart)
        stop
        start
        RETVAL=$?
        ;;
    status)
        status
        RETVAL=$?
        ;;
    diagnostics)
        diagnostics
        RETVAL=$?
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status|diagnostics}"
        RETVAL=1
esac
exit $RETVAL

