#!/usr/bin/env bash
# pass-through commands to 'docker run' with some defaults
# https://docs.docker.com/engine/reference/commandline/run/
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check for V4L2 devices
V4L2_DEVICES=""

for i in {0..9}
do
	if [ -a "/dev/video$i" ]; then
		V4L2_DEVICES="$V4L2_DEVICES --device /dev/video$i "
	fi
done

# check for display
DISPLAY_DEVICE=""

if [ -n "$DISPLAY" ]; then
	# give docker root user X11 permissions
	sudo xhost +si:localuser:root
	
	# enable SSH X11 forwarding inside container (https://stackoverflow.com/q/48235040)
	XAUTH=/tmp/.docker.xauth
	xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
	chmod 777 $XAUTH

	DISPLAY_DEVICE="-e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH"
fi

# check if sudo is needed
if id -nG "$USER" | grep -qw "docker"; then
	SUDO=""
else
	SUDO="sudo"
fi

# run the container
ARCH=$(uname -i)

if [ $ARCH = "aarch64" ]; then

	# this file shows what Jetson board is running
	# /proc or /sys files aren't mountable into docker
	cat /proc/device-tree/model > /tmp/nv_jetson_model

	set -x

	$SUDO docker run --runtime nvidia -it --rm --network host \
		--volume /tmp/argus_socket:/tmp/argus_socket \
		--volume /etc/enctune.conf:/etc/enctune.conf \
		--volume /etc/nv_tegra_release:/etc/nv_tegra_release \
		--privileged \
		--volume /tmp/nv_jetson_model:/tmp/nv_jetson_model \
		-v /home/sandeep/workspaces:/workspaces \
    		-v /dev/*:/dev/* \
    		-v /etc/localtime:/etc/localtime:ro \
		--volume $ROOT/data:/data \
		--device /dev/snd \
		--device /dev/bus/usb \
		--user="admin" \
		--entrypoint /usr/local/bin/scripts/workspace-entrypoint.sh \
		--workdir /workspaces/isaac_ros-dev \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $HOME/.Xauthority:/home/admin/.Xauthority:rw \
		-e DISPLAY \
		-e NVIDIA_VISIBLE_DEVICES=all \
		-e NVIDIA_DRIVER_CAPABILITIES=all \
		-e FASTRTPS_DEFAULT_PROFILES_FILE=/usr/local/share/middleware_profiles/rtps_udp_profile.xml \
		-e ROS_DOMAIN_ID \
		$DATA_VOLUME $V4L2_DEVICES \
		"$@"

elif [ $ARCH = "x86_64" ]; then

	set -x

	$SUDO docker run --gpus all -it --rm --network=host \
		--shm-size=8g \
		--ulimit memlock=-1 \
		--ulimit stack=67108864 \
		--env NVIDIA_DRIVER_CAPABILITIES=all \
		--volume $ROOT/data:/data \
		$DATA_VOLUME $DISPLAY_DEVICE $V4L2_DEVICES \
		"$@"	
fi
