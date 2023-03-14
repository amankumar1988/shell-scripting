#!/bin/bash

COMPONENT=rabbitmq

source components/common.sh


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


rabbitmqctl list_users | grep $APPUSER  &>> $LOGFILE
if [ $? -ne 0 ];then

    echo -n "Creating $COMPONENT Application user :"
    rabbitmqctl add_user roboshop roboshop123   &>> $LOGFILE
    stat $?
fi

echo -n "Adding privilges to $COMPONENT user :"
rabbitmqctl set_user_tags roboshop administrator  &>> $LOGFILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
stat $?