#!/bin/bash

COMPONENT=rabbitmq


USERID=$(id -u)
if [ "$USERID" -ne 0 ];then
    echo -e "\e[31m You should execute this script as root user or with sudo as prefix \e[0m"
    exit 1
fi

echo -n "Download dependencies of $COMPONENT repo : "
curl -s https://packagecloud.io/install/repositories/$COMPONENT/erlang/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "Configuring the $COMPONENT repo : "
curl -s https://packagecloud.io/install/repositories/$COMPONENT/$COMPONENT-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT: "
yum install rabbitmq-server -y  &>> $LOGFILE
stat $?

echo -n "Starting $COMPONENT :"
systemctl enable rabbitmq-server   &>> $LOGFILE  
systemctl start rabbitmq-server    &>> $LOGFILE  
stat $?

echo -n "Create appuser :"
CREATE_USER(){
id $APPUSER
    if [ $? -ne 0 ];then
        echo -n "Create user :"
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi
}
