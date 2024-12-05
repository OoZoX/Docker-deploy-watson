#!/bin/bash

docker run -d -it -p 9998:9998 -p 2222:22 --name data secure-data

USER="bob"
HOST="10.10.1.21"
PORT=2222
PASSWORD="root123"
ssh-keyscan -p 2222 10.10.1.21 >> /home/docker-ecole/.ssh/known_hosts
sshpass -p "$PASSWORD" ssh -p "$PORT" "$USER@$HOST" "/usr/local/bin/first-load.sh"

