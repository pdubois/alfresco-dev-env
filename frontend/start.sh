#!/bin/bash
# param1: network name
# param2: container name
# param3: image name
# To create the network: docker network create --driver bridge $1
docker run --network=$1  -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro   -d -i -t --name $2 $3

