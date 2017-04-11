#!/bin/bash
# param1: network name
# param2: container name
# param3: image name
# To create the network: docker network create --driver bridge $1
docker run --expose 8443 --expose 8080 -P  --network=$1 -e INITIAL_PASS=admin --device   /dev/dri --env="DISPLAY" --env QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw -d -i -t --name $2 $3
