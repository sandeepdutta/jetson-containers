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
# Upgrade cmake to 3.23.2
#RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null 
#RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null 
#RUN apt-get update \
#    && rm /usr/share/keyrings/kitware-archive-keyring.gpg \
#    && apt-get install -y kitware-archive-keyring \
#    && apt-get remove -y cmake && apt-get purge cmake && apt-get remove -y cmake-data && apt-get purge cmake \
#    && apt-get install -y cmake=3.23.2-0kitware1ubuntu20.04.1 cmake-data=3.23.2-0kitware1ubuntu20.04.1 \
#    && cmake --version 

RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT} && \
    cmake --version && \
    rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ros2_control ros2_controllers | vcs import src 
RUN pip3 install Jinja2 typeguard
RUN ls -al ${ROS_ROOT} /usr/local/
# This takes a few hours to build
RUN source ${ROS_ROOT}/install/setup.bash && \
    cd ${ROS_ROOT} && \
    apt-get update && \
    colcon build --merge-install --packages-up-to ros2_control ros2_controllers
    # rm -Rf src build log 

RUN mkdir -p ${ROS_ROOT}/src && \
    source ${ROS_ROOT}/install/setup.bash && \
    cd ${ROS_ROOT} && \
    rosinstall_generator --rosdistro ${ROS_DISTRO} xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters diagnostics diagnostic_updater | vcs import src && \
    colcon build --merge-install --packages-select xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters diagnostics diagnostic_updater
    #rm -Rf src build log 

RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT} && \
    source ${ROS_ROOT}/install/setup.bash && \
    apt-get install g++ && \
    rosinstall_generator --rosdistro ${ROS_DISTRO} nmea_msgs geographic_msgs  | vcs import src && \
    apt-get update && \
    colcon build --merge-install --packages-select nmea_msgs geographic_msgs 


# Set Python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Python basics
RUN apt-get update && apt-get install -y \
        python3-dev \
        python3-flake8 \
        python3-pip \
        python3-pytest-cov 


# Install OpenCV dependencies
RUN apt-get update && apt-get install -y \
    libavformat-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    libpng-dev \
    libpq-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libtiff-dev \
    pkg-config \
    yasm 

# Install additional packages needed for ROS 2 dependencies
RUN apt-get update && apt-get install -y \
    python3-distutils \
    libboost-all-dev \
    libboost-dev \
    libpcl-dev \
    libode-dev \
    lcov \
    python3-zmq \
    libxaw7-dev \
    libgraphicsmagick++1-dev \
    graphicsmagick-libmagick-dev-compat \
    libceres-dev \
    libsuitesparse-dev \
    libncurses5-dev \
    libassimp-dev \
    libyaml-cpp-dev \
    libpcap-dev 

# sklearn dependencies
RUN apt-get update && apt-get install -y \
    gfortran \
    libatlas-base-dev \
    python3-scipy 

# sklearn Python dependencies
RUN python3 -m pip install -U \
    Cython \
    wheel

# Install sklearn
RUN python3 -m pip install -U \
    scikit-learn
    
# Install Git-LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
        apt-get update && apt-get install -y \
        git-lfs 

RUN apt-get update && apt-get install net-tools usbutils libpcl-dev libgeographic-dev gdb libpcap-dev iputils-ping -y