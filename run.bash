#!/bin/bash

IMAGE_NAME=docker_control_simulation
IMAGE_TAG=0.1

chmod +rw ~/.bash_history
chmod o+w ~/.bash_history

WORKSPACE=sim_framework

# Create /tmp/.docker.xauth if it does not already exist.
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    touch $XAUTH
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
fi

xhost +

docker run \
    --net=host \
    -it \
    -v $(pwd):/home/ros/$WORKSPACE \
    --env="HISTFILE=/home/ros/.bash_history" \
    --env="HISTFILESIZE=2000" \
    -v ~/.bash_history:/home/ros/.bash_history \
    --device=/dev/dri:/dev/dri \
    --privileged -v /dev/input:/dev/input \
    --rm \
    --env="DISPLAY=$DISPLAY" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --name docker_simulation \
    -w /home/ros/$WORKSPACE \
    $IMAGE_NAME:$IMAGE_TAG \
    /bin/bash
