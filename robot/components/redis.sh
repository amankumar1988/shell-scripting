#!/bin/bash

set -e
COMPONENT="redis"
LOGFILE="/tmp/redis"

# Validting whether the executed user is a root user or not 
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then 
    echo -e "\e[31m You should execute this script as a root user or with a sudo as prefix \e[0m" 
    exit 1
fi 

stat()
{
if [ $1 -eq 0 ]; then
    echo -e "\e[32mSuccess \e[0m"
else
    echo -e "\e[32mFailure \e[0m"
    exit 2
fi
}

echo -n "Configuring $COMPONENT repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT : "
yum install redis-6.2.11 -y &>> $LOGFILE
stat $? &>> $LOGFILE

echo -n "Updating the $COMPONENT visibility: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $? 

echo -n "Performing daemon-reload :"
systemctl daemon-reload &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
stat $?