#!/bin/bash

# JOB (TO BE SUBMITTED) 
# Description: A generic Job script, which uses a dedicated interface to parametrize the task
# Interface:
#	- ID: Defines a certaine resource (project environment, isolated network)
#	- JOB_DESCRIPTION

MINWAIT=5
MAXWAIT=10
DELAY=$((MINWAIT+RANDOM % (MAXWAIT-MINWAIT)))

printf "\n   [ID:%3s] New Job for %2ss." $ID $DELAY
while [ $DELAY -gt 0 ]; do
   #echo -ne "$secs\033[0K\r"
   
   printf "\n   [ID:%3s] %2ss left." $ID $DELAY
   sleep 1
   : $((DELAY--))
done
printf "\n   [ID:%3s] Done." $ID
exit 0


