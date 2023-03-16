#!/bin/bash

set -e
COMPONENT="frontend"
LOGFILE="/tmp/frontend"

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

echo -n "Installing Nginx: "
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Downloading the Frontend component :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"

stat $?


echo -n "Performing Cleanup of Old $COMPONENT Content :"
cd /usr/share/nginx/html
rm -rf * &>> $LOGFILE
stat $?

echo -n "Copying the downloaded $COMPONENT content: "
unzip /tmp/frontend.zip  &>> $LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md &>> $LOGFILE
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
stat $?

for component in catalogue cart user shipping payment;do
    echo -n "Updating the proxy details in the reverse proxy file :"
    sed -i /$component/s/localhost/$component.roboshop.internal/" /etc/nginx/roboshop.conf
done


echo -n "Starting the service: "
systemctl enable nginx
systemctl start nginx
stat $?

