shell-scripting
This is a repository created to publish all the Bash Bascis and project automation

This repo is created to share all the linux basics
Along with Linux Bash Syntax
Then we will automate the infrastructure provisioning
And then Configuration Management.
Bash Scripting Agenda
Follwoing are the shell scripting topics which we discuss as a part of our project

1. SheBang Notation and Comments
2. Printing
3. Variables
    - Local Variables.
    - Environment Variables.
    - Command Substitution.
4. Inputs
    - Special Variables
    - Prompts
5. Functions
6. Redirectors & Quotes & Exit status 
7. Conditions
8. Loops
9. Basis of SED Command
10. Commands

Output :


    1) Standard Output ( > or 1> )
    2) Standard Error ( 2> or 2>> ) 
    3) Both Standard Output & Error ( &> or &>> )

Redirectors :
>   : Standard Output to a file : ( This will override the existing content on the file : > = 1> )
>>  : Standard Output to a file : ( But, this will not override, just appends on the top of the file )

2>  : Standard Error to a file  

&>  : Redirects both standard output and standard error
&>> : Redirects both standard output and standard error, but appends on the top of the exiting content.

<   : This is to read something from a file and do an action

Exit Status : Every command that you execute will return some status code and based on that code we can decide whether the command is success / failure /partially completed and the command to see the exit code of the previous command is $?

In Linux, exit codes range from 0 to 255.

0      : Exit Code means, command completed successfully
1-255  : Either partially completed or failed 

Conditions
1. Simple If
2. If Else 
3. Else If
Simple If
    if [ expression ]; then
        command1
        command2
        command3
    fi 
    
If expression is true then it executes the commands
NOTE: If the expression is false, then it will not perform any thing
If Else
    if [ expression ]; then
        command1
        command2
        command3
    else 
        commandx
        commandy
    fi 

If expression is true then it executes the commands
NOTE: If the expression is false, then it will perform the conditions in else
Else If
    if [ expression1 ]; then
        command1
    
    elif [expression2 ]; then
        command2

    elif  [expression3 ]; then
        command3

    else
        command-x
    fi 

### Expressions are categorized in to three
1. Numbers
2. Strings
3. Files

Operators on numbers:
-eq , -ne , -gt, -ge, -lt, -le

[ 1 -eq 1 ] 
[ 1 -ne 1 ]

Operators on Strings:
    = , == , !=

    [ abc = abc ]

    -z , -n 

    [ -z "$var" ] -> This is true if var is not having any data
    [ -n "$var" ] _> This is true if var is having any data

    -z and -n are inverse proportional options


Operators on files:
    Lot of operators are available and you can check them using man pages of bash 

    [ -f file ] -> True of file exists and file is a regular file 

    [ -d xyz ]  -> True if file exists and it is a directory

    ### Explore the file types, There are 7 types on files in Linux.


COMMENT

ACTION=$1
 
if [ -z "$ACTION" ]; then 
    echo Argument is needed, Either start/stop
    
else 
    echo Thanks

fi  -->