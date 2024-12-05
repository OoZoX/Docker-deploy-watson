#!/bin/bash

echo "Exécution de first load"
exec /usr/local/bin/first-load.sh

echo "Exécution de SSH"
exec /usr/sbin/sshd -D



