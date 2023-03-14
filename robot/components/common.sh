LOGFILE="/tmp/$COMPONENT.log"
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


CREATE_USER(){
id $APPUSER
    if [ $? -ne 0 ];then
        echo -n "Create user :"
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi
}

DOWNLOAD_AND_EXTRACT(){
    echo -n "Downloading the $COMPONENT zip :"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
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

}

NPM_INSTALL(){
    echo -n "Installing teh $COMPONENT application: "
    cd /home/$APPUSER/$COMPONENT
    npm install &>> $LOGFILE
    stat $?
}

CONFIG_SVC(){
    echo -n "Updating the systemd file with DB Details :"
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/'  -e  's/CARTHOST/cart.roboshop.internal/' -e  's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $? 

    echo -n "Starting the $COMPONENT service : "
    systemctl daemon-reload &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $?

}

MVN_PACKAGE() {
    echo -n "Creating the $COMPONENT Package :"
    cd /home/$APPUSER/$COMPONENT/ 
    mvn clean package  &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    stat $?   
}

PYTHON() {
    echo -n "Installing Python and dependencies :"
    yum install python36 gcc python3-devel -y  &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    echo -n "Installing $COMPONENT :"
    cd /home/roboshop/$COMPONENT/ 
    pip3 install -r requirements.txt   &>> $LOGFILE 
    stat $? 

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    
    echo -n "Updating the $COMPONENT.ini file :"
    sed -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/$APPUSER/$COMPONENT/$COMPONENT.ini 

    # Calling Config-Svc Function
    CONFIG_SVC

}

JAVA() {
    echo -n "Installing Maven  :" 
    yum install maven -y &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    # Calling Maven Package Functon
    MVN_PACKAGE

    # Calling Config-Svc Function
    CONFIG_SVC

}


NODEJS() {

    echo -n "Configuring the nodejs repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>> $LOGFILE
    stat $?  

    echo -n "Installing NodeJS :"
    yum install nodejs -y &>> $LOGFILE
    stat $?

    # Calling Create-User Functon 
    CREATE_USER

    # Calling Download_And_Extract Function
    DOWNLOAD_AND_EXTRACT

    # Calling NPM Install Function
    NPM_INSTALL

    # Calling Config-Svc Function
    CONFIG_SVC

}

    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $? 

    echo -n "Starting the $COMPONENT service : "
    systemctl daemon-reload &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $?
}



MVN_PACKAGE(){
    echo -n "Creating the $COMPONENT Package :"
    cd /home/$APPUSER/$COMPONENT/
    mvn clean package 
    mv target/shipping-1.0.jar shipping.jar
    stat $?
}


PYTHON(){
    echo -n "Installing Python :"
    yum install python36 gcc python3-devel -y  &>> $LOGFILE
    stat $?
    
    echo -n "Creating user :"
    CREATE_USER
    stat $?

    #Calling download and extract function
    DOWNLOAD_AND_EXTRACT 

    echo -n "Installing $COMPONENT :"
    cd /home/roboshop/$COMPONENT
    pip3 install -r requirements.txt  &>> $LOGFILE
    stat $?

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    echo -n "Updating the $COMPONENT.ini file :"
    sed -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/$APPUSER/$COMPONENT/$COMPONENT.ini 
    stat $?

    echo -n "Configure service :"
    CONFIG_SVC
    stat $?

}

JAVA(){
    echo -n "Installing Maven :"   
    yum install maven -y &>>  $LOGFILE
    stat $?
    
    echo -n "Creating user :"
    CREATE_USER
    stat $?

    #Calling download and extract function
    DOWNLOAD_AND_EXTRACT

    #Calling Maven package function
    MVN_PACKAGE

    #Calling config svc
    CONFIG_SVC

}

NODEJS(){
    echo -n "Downloading the $COMPONENT component :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
    stat $?

    echo -n "Installing nodejs : "
    yum install nodejs -y &>> $LOGFILE
    stat $?

    #Calling create-user Function
    CREATE_USER
    
    #Calling download and extract function
    DOWNLOAD_AND_EXTRACT

    #Calling npm install
    NPM_INSTALL

    #calling config-svc Function
    CONFIG_SVC

}