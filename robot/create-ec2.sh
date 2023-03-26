#!/bin/bash 

# This is a script created to launch EC2 Servers and create the associated Route53 Record 

if [ -z "$1" ]; then 
    echo -e "\e[31m Component Name is required \e[0m \t\t"
    echo -e "\t\t\t \e[32m Sample Usage is : $ bash create-ec2.sh user \e[0m"
    exit 1
fi 

HOSTEDZONEID="Z03162902ZBUWVJLMZQNI"
COMPONENT=$1 

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b53-allow-all-sg | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
echo "Ami ID is $AMI_ID"

echo -n "Launching the instance with $AMI_ID as AMI :"

create_server() {
    
    echo "*** Launching $COMPONENT Server ***"

    IPADDRESS=$(aws ec2 run-instances --image-id $AMI_ID \
                    --instance-type t3.micro \
                    --security-group-ids ${SGID} \
                    --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
                    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

    sed -e "s/COMPONENT/${COMPONENT}/" -e  "s/IPADDRESS/${IPADDRESS}/" robot/record.json > /tmp/record.json
    aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/record.json | jq

    echo "*** $COMPONENT Server Completed ***"

}

if [ "$1" == "all" ] ; then 
    for component in frontend mongodb catalogue cart user mysql redis rabbitmq shipping payment ; do  
        COMPONENT=$component 
        create_server
    done
else 
        create_server
fi 