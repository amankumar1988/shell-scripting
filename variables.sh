#!/bin/bash

# special chr : $0 to $9 , $*, $#, $@, $$

echo "Name of the script is $0"

echo $1
echo $2
echo $3

#bash script.sh 100 200 300

echo "all passed variables are : $*"
echo "total no of variables are : $#"
echo $@ #print used variable
echo $$ #process id
