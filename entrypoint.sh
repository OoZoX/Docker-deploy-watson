#!/bin/bash

echo "Exécution de SSH"
exec /usr/sbin/sshd -D

echo "Exécution de first load"
exec /usr/bin/fist-load.sh
exit 1


