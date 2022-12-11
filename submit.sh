#!/bin/bash

# JOB DISPATCHER 
# Description: Statemachine to modell a serving system without queuing (when limited resources are exhausted)
# call: (ID=0 ./submit.sh ./job.sh & disown)

RESOURCES_FILE=servers.ids
MAXID=25 #255

R='\033[0;31m'
G='\033[0;32m'
N='\033[0m'

case $1 in
	init)
		#RESET / INIT
		RANGE=$(eval echo {0..${MAXID}})
		echo -n ${RANGE} > ${RESOURCES_FILE}

		#init task: removing old jobs and reset all resources
		./init.sh
		
		exit $?
		;;
esac

#### start >>> atomic (state change / aquire server)
exec {fd}<${RESOURCES_FILE}
flock $fd
	
	SERVERS=($(cat ${RESOURCES_FILE}))

	if [ "$SERVERS" = "" ]
	  then
		echo -e "\n${R}Submission failt! No resources left.${N}"
		exit 1
	fi

	SELECT="${SERVERS[0]}"
	SERVERS=${SERVERS[@]:1}
	echo -n $SERVERS > ${RESOURCES_FILE}
	
flock -u $fd
#### end <<< atomic (state change)

#use server for a certain amount of time
#echo -e "\nUse ID ${G}${SELECT}${N}, Remaining ${SERVERS}"
#printf "[ID:%3s] %2ss left.\n" $ID $DELAY
printf "\nUse ID:${G}%3s${N}, Remaining %s" ${SELECT} "${SERVERS}"

#run job with ID as env. variable forwarded
( ID=${SELECT} $@ ) || true

#release server
echo -n " ${SELECT}" >> ${RESOURCES_FILE}
exit 0

