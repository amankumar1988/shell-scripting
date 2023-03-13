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

}

NPM_INSTALL(){
    echo -n "Installing teh $COMPONENT application: "
    cd /home/$APPUSER/$COMPONENT
    npm install &>> $LOGFILE
    stat $?
}

CONFIG_SV(){
    
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

}

