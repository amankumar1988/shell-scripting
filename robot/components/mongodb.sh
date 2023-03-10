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
yum install mongodb-org -y &>> $LOGFILE
stat $?

echo -n "Start mongodb: "
systemctl start mongod
systemctl enable mongod
stat $?





# echo -n "Performing Cleanup of Old $COMPONENT Content :"
# cd /usr/share/nginx/html
# rm -rf * &>> $LOGFILE
# stat $?

# echo -n "Copying the downloaded $COMPONENT content: "
# unzip /tmp/frontend.zip  &>> $LOGFILE
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md &>> $LOGFILE
# mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
# stat $?

# echo -n "Starting the service: "
# systemctl enable nginx
# systemctl start nginx

# stat $?

