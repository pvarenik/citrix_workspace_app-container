# IMPORTANT

## From original author
This repo and the container provided via Docker hub (`https://hub.docker.com/r/eddyhub/citrix_receiver-docker`) IS NO LONGER MAINTAINED by me. Please use the new repo `https://github.com/eddyhub/citrix_workspace_app-container` and the the container `https://hub.docker.com/r/eddyhub/citrix_workspace_app-container`

## Updates from me
1) Citrix Receiver -> Citrix Workspace app
2) Dependencies were updated

# Docker container for the Citrix Workspace App

This is a simple container to run the Citrix Workspace App using the firefox browser.

## How to build this docker image
```
docker build -t citrix_workspace .
```

## Start the container
```
docker run -d -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime --name citrix_workspace citrix_workspace
```

## Connect to the container via ssh and X-Forward
Please set the WEB_URL_TO_LOGIN to your specific login url
```
ssh -f -X workspace@$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' citrix_workspace) -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /usr/bin/firefox <WEB_URL_TO_LOGIN> > /dev/null 2>&1
```