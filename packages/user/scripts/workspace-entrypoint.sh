#!/bin/bash
#
# Copyright (c) 2021, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

# Build ROS dependency
echo "source /opt/ros/${ROS_DISTRO}/install/setup.bash" >> ~/.bashrc
echo "alias ros2build='colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo'" >> ~/.bashrc
echo "source /workspaces/isaac_ros-dev/install/setup.bash" >> ~/.bashrc
echo "export CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda"
source /opt/ros/${ROS_DISTRO}/install/setup.bash

#sudo apt-get update
#rosdep update

# Restart udev daemon
sudo service udev restart

$@
