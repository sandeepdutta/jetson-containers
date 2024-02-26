#---
# name : bmi160_imu
# group : jeeves
# depends: []
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ENV LANG=en_US.UTF-8
ENV ROS_PYTHON_VERSION=3
ENV ROS_DISTRO=humble
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

RUN source ${ROS_ROOT}/install/setup.sh && \
    mkdir -p ${ROS_ROOT}/src &&\
    cd ${ROS_ROOT}/src &&\
    git clone https://github.com/robofoundry/aws-deepracer-imu-pkg.git && \
    cd aws-deepracer-imu-pkg && . imu_pkg/scripts/load_ros2_imu_tools_repo.sh && \
    cd ${ROS_ROOT} && colcon build --merge-install 
