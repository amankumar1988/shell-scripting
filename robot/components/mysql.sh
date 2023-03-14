#!/bin/bash

COMPONENT=mysql

source components/common.sh

echo -n "Configuring the $COMPONENT repo : "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing $COMPONENT: "
yum install mysql-community-server -y &>> $LOGFILE
stat $?

echo -n "Starting $COMPONENT :"
systemctl enable mysqld  &>> $LOGFILE  
systemctl start mysqld   &>> $LOGFILE  
stat $?

echo -n "Grab $COMPONENT default pswd: "
DEFAULT_ROOT_PWD=$(grep "temporary pass" /var/log/mysqld.log | awk '{print $NF}')
stat $?


echo "show databases;" | mysql -uroot -pRoboShop@1  &>> $LOGFILE
if [ $? -ne 0 ];then

echo -n "Password Reset of root user :"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PWD} &>> $LOGFILE
stat $?

fi


echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password  &>> $LOGFILE
if [ $? -ne 0 ];then

echo -n "Uninstalling Paswd validation plugin :"
echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1  &>> $LOGFILE

fi

echo -n "Downloading the $COMPONENT zip :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Extracting $COMPONENT for $APPUSER :"
cd /tmp 
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "Injecting the schema"
cd $COMPONENT-main
mysql -u root -pRoboShop@1 < shipping.sql
stat $?