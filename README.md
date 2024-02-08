# ftp2-scripts
Scripts to build software and maintain ftp2.

***Credit goes to Unicamp developers for the bash template and provdiing previously built binaries. Thank you.***

# Summary
1. Check if ftp2 version matches latest Github release. If versions are not the same, build a new version.

```bash
if github_version != ftp_version : 
    send-email("New build")
    build
    move
    clean
else:
    send-email("No update needed")
```

2. Download latest GitHub release version for project
3. Build project's binary in a Docker container
4. Copy binary from container to host machine
5. Send Email to double check new binary
6. Publish to ftp2

This is accomplished with the following files...

## ftp-checker.py
Crawls ftp2 and Github to grab versions. Saves versions to .txt file in the project directory

## check.sh
The "core logic" of this proejct. The script executes ftp-checker.py and then checks if package needs to update. If update is needed, build(), move(), clean().

## Dockerfile
Installs the dependices and builds the binary. The last step of this file is to copy the binary from a directory named "/buildah" in the container to the "$project_name/binary" directory on the build machine's filesystem.

## tools.sh
The main script containing all the functions used by every project. Outline of ech function below

### build()
This is the bash function that builds the Docker image (via Dockerfile).
The last step is docker cp the binary to the project's binary/ directory on the host.

### move()
scp the binary to ftp2. In the future this could ssh into ftp2 and execute remote commands however I think the manual check is better to make sure it worked.

### send-email()
Send an email via curl to let you know there is a version mismatch between the ftp2 version and github's latest release. Alert to verify the build and docker cache.

### clean()
Remove docker cache. Ideally sqwitch to Alpine Linux image

## Logging
The bash scripts have echos for logging. Put this in your cron file to run every Wednesday at 2pm PST

```
0 21 * * 3 /home/ubuntu/bazel/check.sh >> /home/ubuntu/logs/bazel.txt 2>&1
0 21 * * 3 /home/ubuntu/opentofu/check.sh >> /home/ubuntu/logs/opentofu.txt 2>&1
```
