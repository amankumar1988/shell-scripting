#!/bin/bash 


# Each and every action will have an EXIT Code in Linux, which helps us in determining the status of the task
# Exit Code ranges from 0 to 255 

# 0        : Successful 
# 1 - 255  : partial failure or complete failure or partial success
  
# While 0 is Success ; rest of them may be 1) partial failure 2) complete failure 3) partial success

# How to fetch the exit status of the previous executed command ?
# --> $? : This is going to print the exit code of the previous executed command only .

# Exit code plays an important role in debugging some sciprts which are lengthy. follow the 12th example for better insights.