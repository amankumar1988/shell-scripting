#!/bin/bash

# Types of commands:
# Binary, Aliases, Built-in commands, Functions

sample()
{
    echo "test function"
}

stat()
{
    echo "Total number of sessions: $(who | wc -l)"
    echo "Today date is $(date +%F)"
    echo "Load Average on the system is $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1})'"
}

echo "calling stat function"
stat