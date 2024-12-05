#!/bin/bash

echo "Exécution de SSH"
exec /usr/sbin/sshd -D >> /var/log/sshd.log 2>&1

echo "Exécution de first load"
exec /usr/bin/fist-load.sh
exit 1


