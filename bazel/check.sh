#!/bin/bash

source /home/${USER}/tools.sh

UBUNTU_VERSIONS=("20.04" "22.04")
PROJECT_NAME="bazel"
echo $(date +"%m-%d-%Y  %T")

for ubu_ver in ${UBUNTU_VERSIONS[@]}; do
	echo "================="
	echo "ubuntu version: "
	echo $ubu_ver
	PROJECT_HOME="/home/ubuntu/bazel/$ubu_ver"
	
	cd $PROJECT_HOME
	python3 $PROJECT_HOME/ftp-checker.py $ubu_ver

	github_version=$(cat $PROJECT_HOME/github_version.txt)
	ftp_version=$(cat $PROJECT_HOME/ftp_version.txt)
	#test:ftp_version="6.0.0"

	if [ $github_version != $ftp_version ]; then

		#send-email "Updating" ${PROJECT_NAME} "Starting to build docker images now..." ${ftp_version} ${github_version};
		build $PROJECT_HOME $PROJECT_NAME $github_version
		#move $PROJECT_HOME $PROJECT_NAME $github_version
		clean $PROJECT_HOME $PROJECT_NAME
		#send-email "Finished building" ${PROJECT_NAME} "New Version is ready to move to /latest" ${ftp_version} ${github_version};		
	else
		echo "No update needed"
        	rm $PROJECT_HOME/github_version.txt
        	rm $PROJECT_HOME/ftp_version.txt
	fi
done
