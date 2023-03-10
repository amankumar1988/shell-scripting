#!/bin/bash

echo "this is mongodb"

#!/bin/bash

set -e
COMPONENT="mongodb"
LOGFILE="/tmp/mongodb"

#validting user
USERID=$(id -u)

if [ "$USERID" -ne 0 ];then
    echo -e "\e[31m You should execute this script as root user or with sudo as prefix \e[0m"
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

echo -n "Downloading the mongodb component :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing mongodb-org: "
yum install -y mongodb-org -y &>> $LOGFILE
stat $?

echo -n "Start mongodb: "
systemctl start mongod
systemctl enable mongod
stat $?

echo -n "Updating the $COMPONENT visibility: "
sed -i -e "s/127.0.0.1/0.0.0.0/' /etc/mongod.conf"
stat $?

echo -n "Performing daemon-reload :"
systemctl daemon-reload $>> $LOGFILE
systemctl restart mongod

echo -n "Downloading $COMPONENT schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting $COMPONENT schema :"
unzip $COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Injecting the schema :"
cd /tmp/$COMPONENT-main
mongo < catalogue.js   &>> $LOGFILE
mongo < users.js      &>> $LOGFILE
stat $?