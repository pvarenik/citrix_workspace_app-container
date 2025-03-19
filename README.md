# Docker Hub

Docker hub (`https://hub.docker.com/r/pvarenik/citrix_workspace`)

Run the command below to start container
```
docker run -d -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime --name citrix_workspace pvarenik/citrix_workspace
```

# Docker container for the Citrix Workspace App local installation

This is a simple container to run the Citrix Workspace App using the firefox browser.

## Features

- Ubuntu latest base image
- Citrix Workspace app for Linux
- Firefox browser
- SSH server for remote access
- X11 applications for GUI support

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

## Environment Variables

- `DEBIAN_FRONTEND=noninteractive`: Set to avoid interactive prompts during package installation.

## License

This project is licensed under the MIT License.