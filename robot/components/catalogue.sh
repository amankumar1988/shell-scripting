#!/bin/bash

echo "this is catalogue"

#!/bin/bash

set -e
COMPONENT="catalogue"
LOGFILE="/tmp/catalogue"
APPUSER=roboshop

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

echo -n "Downloading the $COMPONENT component :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
stat $?

echo -n "Installing nodejs : "
yum install nodejs -y &>> $LOGFILE
stat $?

id $APPUSER
if [ $? -ne 0 ];then
    echo -n "Create user :"
    useradd $APPUSER &>> $LOGFILE
    stat $?
fi

echo -n "Downloading the $COMPONENT zip :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "Extracting $COMPONENT for $APPUSER :"
cd /home/$APPUSER
rm -rf /home/$APPUSER/$COMPONENT
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "Configuring the permission :"
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?