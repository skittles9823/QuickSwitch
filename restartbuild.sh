#!/bin/bash

curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
chmod +x drone

BUILD_NUMBER=$(./drone build ls $DRONE_REPO --limit 1 --format="{{ .Number }}")
./drone build restart $DRONE_REPO $BUILD_NUMBER
