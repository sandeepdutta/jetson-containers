export CONTAINER_NAME=jeeves
# Re-use existing container.
if [ "$(docker ps -a --quiet --filter status=running --filter name=$CONTAINER_NAME)" ]; then
    echo "Attaching to running container: $CONTAINER_NAME"
    docker exec -i -t -u admin --workdir /workspaces/isaac_ros-dev $CONTAINER_NAME /bin/bash $@
    exit 0
fi
~/workspaces/jetson-containers/run_admin.sh --name "$CONTAINER_NAME"  --entrypoint "/usr/local/bin/scripts/workspace-entrypoint.sh" $(~/workspaces/jetson-containers/autotag jeeves:r35.4.1) /bin/bash $@
