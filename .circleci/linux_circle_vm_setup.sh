#!/bin/bash

set -eu -o pipefail
set -x

# Get recent qemu to avoid constant qemu crashes on Ubuntu 20.04
# Incomprehensible discussions of the problem at
# https://bugs.launchpad.net/ubuntu/+source/qemu/+bug/1928075
sudo add-apt-repository ppa:jacob/virtualisation

sudo apt-get -qq update && sudo apt-get -qq install -y docker-ce-cli binfmt-support  qemu qemu-user qemu-user-static >/dev/null


# Get recent buildx
mkdir -p ~/.docker/cli-plugins && curl -sSL -o ~/.docker/cli-plugins/docker-buildx https://github.com/docker/buildx/releases/download/v0.6.3/buildx-v0.6.3.linux-arm64 && chmod +x ~/.docker/cli-plugins/docker-buildx

docker buildx version

if ! docker buildx inspect ddev-builder-multi --bootstrap >/dev/null; then docker buildx create --name ddev-builder-multi --use; fi
docker buildx inspect --bootstrap

# Install github's gh tool
wget -O /tmp/gh.deb https://github.com/cli/cli/releases/download/v2.1.0/gh_2.1.0_linux_arm64.deb && sudo dpkg -i /tmp/gh.deb >/dev/null