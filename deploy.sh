#!/bin/bash

docker pull oozox/my-cloud:latest
docker pull oozox/watson:latest

docker run -d -it -p 5000:5000 --name cloud oozox/my-cloud
docker run -d -it -p 9998:9998 -p 2222:22 --name data oozox/watson
docker exec -itd data /usr/sbin/sshd -D

USER="bob"
HOST="10.10.1.21"
PORT=2222
PASSWORD="root123"
PATH_SSH="/home/docker-ecole/.ssh/known_hosts"

ssh-keygen -R $HOST
ssh-keyscan -p $PORT $HOST >> $PATH_SSH
sshpass -p "$PASSWORD" ssh -p "$PORT" "$USER@$HOST" "/usr/local/bin/first-load.sh"

