#!/bin/bash

echo $0    # Prints Script Name 
echo $1    # Takes the first value from the command line 
echo $2    # Takes the second value from the command line 

echo $*    # $* is going to print the used variables  
echo $@    # $@ is going to print the used variables  
echo $$    # $$ is going to print the PID of the current proces 
echo $#    # $# is going to pring the number of arguments
echo $?    # $? is going to print the exit code of the last command.

# $* or $@ both of the prints the used variables in the scirpt