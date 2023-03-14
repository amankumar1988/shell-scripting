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

echo -n "Password reset of root user :"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PWD} &>> $LOGFILE 
stat $?



