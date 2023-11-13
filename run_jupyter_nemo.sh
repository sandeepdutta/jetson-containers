# Re-use existing container.
if [ "$(docker ps -a --quiet --filter status=running --filter name=$CONTAINER_NAME)" ]; then
    echo "Attaching to running container: $CONTAINER_NAME"
    docker exec -i -t -u admin --workdir /workspaces/isaac_ros-dev $CONTAINER_NAME /bin/bash $@
    exit 0
fi
~/workspaces/jetson-containers/run_sandeep.sh   --name "$CONTAINER_NAME" --entrypoint "/usr/local/bin/scripts/jupyter_nemo-entrypoint.sh" jupyter_nemo:r35.4.1 $@
