#!/bin/bash

set -e
COMPONENT="mongodb"
source components/common.sh  


echo -n "Downloading the mongodb component :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing mongodb-org: "
yum install mongodb-org -y &>> $LOGFILE
stat $?

echo -n "Start mongodb: "
systemctl start mongod  &>> $LOGFILE
systemctl enable mongod &>> $LOGFILE
stat $?

echo -n "Updating the $COMPONENT visibility: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Performing daemon-reload :"
systemctl daemon-reload &>> $LOGFILE
systemctl restart mongod
stat $?
echo -n "Downloading $COMPONENT schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting $COMPONENT schema :"
cd /tmp
unzip -o $COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Injecting the schema :"
cd /tmp/$COMPONENT-main
mongo < catalogue.js   &>> $LOGFILE
mongo < users.js      &>> $LOGFILE
stat $?