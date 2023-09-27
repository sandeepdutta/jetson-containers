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

RUN apt-get update && apt-get install libacl1-dev -y 

RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT} && \
    rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ros2_control ros2_controllers | vcs import src 

RUN ls -al ${ROS_ROOT}
# This takes a few hours to build
RUN source ${ROS_ROOT}/setup.bash && \
    cd ${ROS_ROOT} && \
    apt-get update && \
    rosdep install -y \
      --ignore-src \
      --from-paths src \
      --rosdistro ${ROS_DISTRO} \
      --skip-keys "fastcdr rti-connext-dds-6.0.1 rti-connext-dds-5.3.1 urdfdom_headers libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" &&\
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo  --packages-skip cyclonedds rmw_cyclonedds_cpp gmock && \
    rm -Rf src build log 

RUN mkdir -p ${ROS_ROOT}/src && \
    source ${ROS_ROOT}/setup.bash && \
    cd ${ROS_ROOT} && \
    rosinstall_generator --rosdistro ${ROS_DISTRO} xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters | vcs import src && \
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo --packages-select xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters && \
    rm -Rf src build log 

RUN apt-get update && apt-get install net-tools usbutils libpcl-dev gdb -y