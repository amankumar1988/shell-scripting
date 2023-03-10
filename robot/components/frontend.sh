#!/bin/bash

set -e
#validting user

USERID=$(id -u)

if [ "$USERID" -ne 0 ];then
    echo -e "\e[31m You should execute this script as root user or with sudo as prefix \e[0m"
    exit 1
fi

echo -n "Installing Nginx"
yum install nginx -y &>> "/tmp/frontend.log"
if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess \e[0m"
else
    echo -e "\e[32mFailure \e[0m"
    exit 2
fi

echo -n "Downloading the Frontend component :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess \e[0m"
else
    echo -e "\e[32mFailure \e[0m"
    exit 2
fi


echo -n "Performing Cleanup of Old Frontend Content :"
cd /usr/share/nginx/html
rm -rf * &>> "/tmp/frontend.log"
if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess \e[0m"
else
    echo -e "\e[32mFailure \e[0m"
    exit 2
fi

echo -n "Copying the downloaded frontend content: "
unzip /tmp/frontend.zip  &>> "/tmp/frontend.log"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md &>> "/tmp/frontend.log"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> "/tmp/frontend.log"
if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess \e[0m"
else
    echo -e "\e[32mFailure \e[0m"
    exit 2
fi

echo -n "Starting the service: "
systemctl enable nginx
systemctl start nginx

if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess \e[0m"
else
    echo -e "\e[32mFailure \e[0m"
    exit 2
fi