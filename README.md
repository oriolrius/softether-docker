# Build docker images for SoftEtherVPN and push them to hub.docker.com

When everything is done the images will be avaible at:
https://hub.docker.com/repositories/oriolrius

Platforms (architectures) generated: amd64 and arm64.

- Docker Hub repository: https://hub.docker.com/repositories
- Public git repository: https://github.com/oriolrius/softether-docker
- Private git repository: https://git.oriolrius.cat/oriolrius/softether-docker


## Requirements

docker buildx is required for cross compiling.


Check if you have support for amd64 and arm64 platforms:
```
$ sudo docker buildx inspect --bootstrap
Name:   mybuilder
Driver: docker-container

Nodes:
Name:      mybuilder0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Platforms: linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/386, linux/arm64, linux/ppc64le, linux/s390x
```

If the command fails with a D-BUS and X11 error go to: https://anto.online/guides/cannot-autolaunch-d-bus-without-x11-display/

If it works,pay attention in the list of platforms, it has to be amd64 and arm64 compatible. If it isn't follow these instructions:

Installing docker buildx from binaries if it's necessary:
```
# run next commands from the host machine:
mkdir -p ~/.docker/cli-plugins

# download the latest version available for your host architecture from:
# https://github.com/docker/buildx/releases
# in my case:
wget https://github.com/docker/buildx/releases/download/v0.9.0/buildx-v0.9.0.linux-amd64 -O ~/.docker/cli-plugins/docker-buildx
# giving execution permissions
chmod 755 ~/.docker/cli-plugins/docker-buildx

# check if it runs with:
docker builx --help

# register binfmt binaries to be run with qemu
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3

# project info at https://github.com/docker/binfmt

# check if it works:
cat /proc/sys/fs/binfmt_misc/qemu-aarch64
# out it's somthing like:
enabled
interpreter /usr/bin/qemu-aarch64
flags: OCF
offset 0
magic 7f454c460201010000000000000000000200b7
mask ffffffffffffff00fffffffffffffffffeffff
```

### Creating a builder instance

```
docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx inspect --bootstrap
```

## Instructions for building images

Followoing next steps you can build the docker images.

```
git clone ssh://git@git.oriolrius.cat:222/oriolrius/softether-docker.git
cd softether-docker
docker login
chmod 755 build-and-push.sh
./build-and-push.sh
```

## Before running the client or server

... go to the config/ directory and rename the files *.config.sample to *.config, or create your own config files.

My recommendation is to use the sample files and then modify the configurations using GUI managers.

## Run the VPN client

```
docker-compose up -d softether-vpnclient
```

Remember that you have VPN Client manager for configuring the client, or you can use vpncmd.

## Run the VPN server

```
docker-compose up -d softether-vpnserver
```

Remember that you have VPN Server manager for configuring the client, or you can use vpncmd.

## Run the vpncmd

```
docker-compose exec softether-vpnserver /usr/local/bin/vpncmd
# or
docker-compose exec softether-vpnclient /usr/local/bin/vpncmd
```

## Troubleshooting

### How To Fix The “Cannot Autolaunch D-Bus Without X11 $DISPLAY” Error

```
sudo apt-get install pass gnupg2

sudo gpg --gen-key
# pay attention and look up for the key_id

# then you have to do that, for instance:
pass init "Oriol Rius <oriol@joor.net>"
```

Try again the command:
```
sudo docker buildx inspect --bootstrap
```
and now it has to run without issues.

## References

* https://community.arm.com/arm-community-blogs/b/tools-software-ides-blog/posts/getting-started-with-docker-for-arm-on-linux
* https://anto.online/guides/cannot-autolaunch-d-bus-without-x11-display/
* https://anto.online/guides/cannot-autolaunch-d-bus-without-x11-display/
