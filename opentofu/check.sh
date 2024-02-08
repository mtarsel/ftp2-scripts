#!/bin/bash

source /home/ubuntu/tools.sh

PROJECT_NAME="opentofu"
PROJECT_HOME="/home/ubuntu/$PROJECT_NAME"

echo ""
echo ""
echo $(date +"%m-%d-%Y  %T")

cd $PROJECT_HOME
python3 $PROJECT_HOME/ftp-checker.py

github_version=$(cat $PROJECT_HOME/github_version.txt)
ftp_version=$(cat $PROJECT_HOME/ftp_version.txt)
#ftp_version="1.6.0"

echo $github_version
echo $ftp_version

if [ $github_version != $ftp_version ]; then
	#send-email "Updating" ${PROJECT_NAME} "Starting to build docker images now..." ${ftp_version} ${github_version};
	build $PROJECT_HOME $PROJECT_NAME $github_version
	#move $PROJECT_HOME $PROJECT_NAME $github_version
	clean $PROJECT_HOME $PROJECT_NAME

else
	echo "No update needed"
	send-email "No Update Needed" ${PROJECT_NAME} "Got the following info..." ${ftp_version} ${github_version};
	rm $PROJECT_HOME/github_version.txt
	rm $PROJECT_HOME/ftp_version.txt
	
	#TODO clean it up anyways cause of weirdness with cache?
	#clean $PROJECT_HOME $PROJECT_NAME
fi
