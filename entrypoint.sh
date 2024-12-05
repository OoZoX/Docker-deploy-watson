#!/bin/bash

echo "Exécution de first load"
exec /usr/bin/fist-load.sh

echo "Exécution de SSH"
exec /usr/sbin/sshd -D



