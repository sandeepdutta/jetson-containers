#---
# name : jeeves
# group : jeeves
# depends: [ros:humble-desktop]
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ENV LANG=en_US.UTF-8
ENV ROS_PYTHON_VERSION=3
ENV ROS_DISTRO=humble
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

RUN apt-get update && apt-get install libacl1-dev libfmt-dev librange-v3-dev -y 

RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT} && \
    rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ros2_control ros2_controllers | vcs import src 
RUN pip3 install Jinja2 typeguard
RUN ls -al ${ROS_ROOT} /usr/local/
# This takes a few hours to build
RUN source ${ROS_ROOT}/install/setup.bash && \
    cd ${ROS_ROOT} && \
    apt-get update && \
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo  --packages-up-to ros2_control ros2_controllers
    # rm -Rf src build log 

RUN mkdir -p ${ROS_ROOT}/src && \
    source ${ROS_ROOT}/install/setup.bash && \
    cd ${ROS_ROOT} && \
    rosinstall_generator --rosdistro ${ROS_DISTRO} xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters diagnostics diagnostic_updater | vcs import src && \
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo --packages-select xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters diagnostics diagnostic_updater
    #rm -Rf src build log 

RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT} && \
    source ${ROS_ROOT}/install/setup.bash && \
    apt-get install g++ && \
    rosinstall_generator --rosdistro ${ROS_DISTRO} nmea_msgs geographic_msgs  | vcs import src && \
    apt-get update && \
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo --packages-select nmea_msgs geographic_msgs 


RUN apt-get update && apt-get install net-tools usbutils libpcl-dev libgeographic-dev gdb libpcap-dev iputils-ping -y