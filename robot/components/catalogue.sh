#!/bin/bash

echo "this is catalogue"

COMPONENT="catalogue"

source components/common.sh #load the file
NODEJS

# LOGFILE="/tmp/catalogue"
# APPUSER=roboshop

# #validting user
# USERID=$(id -u)

# if [ "$USERID" -ne 0 ];then
#     echo -e "\e[31m You should execute this script as root user or with sudo as prefix \e[0m"
#     exit 1
# fi

# stat()
# {
# if [ $1 -eq 0 ]; then
#     echo -e "\e[32mSuccess \e[0m"
# else
#     echo -e "\e[32mFailure \e[0m"
#     exit 2
# fi
# }

# echo -n "Downloading the $COMPONENT component :"
# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
# stat $?

# echo -n "Installing nodejs : "
# yum install nodejs -y &>> $LOGFILE
# stat $?

# id $APPUSER
# if [ $? -ne 0 ];then
#     echo -n "Create user :"
#     useradd $APPUSER &>> $LOGFILE
#     stat $?
# fi

# echo -n "Downloading the $COMPONENT zip :"
# curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
# stat $?

# echo -n "Extracting $COMPONENT for $APPUSER :"
# cd /home/$APPUSER
# rm -rf /home/$APPUSER/$COMPONENT
# unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
# stat $?

# echo -n "Configuring the permission :"
# mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
# chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
# stat $?

# echo -n "Installing teh $COMPONENT application: "
# cd /home/$APPUSER/$COMPONENT
# npm install &>> $LOGFILE
# stat $?

# echo -n "Updating the systemd file with DB details :"
# sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
# mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
# stat $?

# echo -n "Start service: "
# systemctl daemon-reload &>> $LOGFILE
# systemctl restart catalogue &>> $LOGFILE
# systemctl enable catalogue&>> $LOGFILE
# stat $?