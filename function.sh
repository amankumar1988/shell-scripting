#!/bin/bash

# Types of commands:
# Binary, Aliases, Built-in commands, Functions

sample()\
{
    echo "test function"
}

stat()
{
    echo "Total number of sessions: $(who | wc -l)"
    echo "Today date is $(date +%F)
}