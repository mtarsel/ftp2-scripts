#!/bin/bash

send-email () {

    echo "Sending email..."

    subject_string="$1"
    project_name="$2"
    email_body="$3"
    ftp_version="$4"
    github_version="$5"

    curl --url 'smtps://${smtp_server}:465' --ssl-reqd \
  --mail-from '$email_address' \
  --mail-rcpt '$email_address' \
  --user '${email_address}:' \
  -T <(echo -e "From: ${email_address}\nTo: ${email_address}\nSubject: ${subject_string} ${project_name} \n\n ${email_body} FTP version: ${ftp_version} Github version: ${github_version} ")

}

build () {
    project_home=$1
    project_name=$2
    github_version=$3

    echo "Building docker image"
    docker build --no-cache -t ${project_name} --build-arg CACHEBUST=$(date +%s) --build-arg NAME="${project_name}" --build-arg VERSION="${github_version}" --file ${project_home}/Dockerfile .
    #TODO docker build --no-cache -t ${project_name} --build-arg NAME="${project_name}" --build-arg VERSION="${github_version}" --file ${project_home}/Dockerfile .

    docker run --name ${project_name} ${project_name}
    
    echo "copying binary"
    container_id=$(docker ps -aqf "name=^$project_name$")
    docker cp $container_id:/buildah/. $project_home/binary
}


move () {
   
    project_home=$1
    project_name=$2
    github_version=$3
    ssh_key_name=$4

    echo "scpin' it!"
    #TODO function to put on mirror if we know the right dir to put it in
    scp -i ${project_home}/${ssh_key_name} ${project_home}/binary/${project_name}-${github_version} username-${project_name}@${mirror}.org:~/
}

clean () {
    project_home=$1
    project_name=$2

    echo "Cleaning up build, removing images and containers"
    container_id=$(docker ps -aqf "name=^$project_name$")

    rm $project_home/*.txt
    docker rm $container_id
    docker rmi $project_name

    echo "Clearing cache"
    docker system df
    docker system prune --force
}
