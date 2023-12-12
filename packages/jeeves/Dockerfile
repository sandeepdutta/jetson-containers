#---
# name : jeeves
# group : jeeves
# depends: []
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
    rosinstall_generator --rosdistro ${ROS_DISTRO} xacro joint_state_publisher topic_tools_interfaces topic_tools filters laser_filters diagnostics diagnostic_updater | vcs import src && \
    colcon build --merge-install --packages-select xacro joint_state_publisher topic_tools_interfaces topic_tools laser_filters diagnostics diagnostic_updater
    #rm -Rf src build log 

RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT} && \
    source ${ROS_ROOT}/install/setup.bash && \
    apt-get install g++ && \
    rosinstall_generator --rosdistro ${ROS_DISTRO} nmea_msgs geographic_msgs  | vcs import src && \
    apt-get update && \
    colcon build --merge-install --packages-select nmea_msgs geographic_msgs && \
    rm -Rf src build log


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
        git-lfs  python3-rosdep libbondcpp-dev

RUN apt-get update \     
    && cd ${ROS_ROOT} \
    && rm -Rf src build log \
    && mkdir -p ${ROS_ROOT}/src \
    && source ${ROS_ROOT}/install/setup.bash \
    && rosinstall_generator --rosdistro humble bond bond_core bondcpp bondpy smclib ompl | vcs import src \
    && colcon build --merge-install  \
    && rm -Rf src build log 


# Install nav2
RUN apt-get update && mkdir -p ${ROS_ROOT}/src && cd ${ROS_ROOT}/src \
    && git clone https://github.com/ros-planning/navigation2.git && cd navigation2 && git checkout ec49c2772a0926c86ca83a4933c664744712e2e9 && cd .. \
    && git clone https://github.com/BehaviorTree/BehaviorTree.CPP.git && cd BehaviorTree.CPP && git checkout a363bdcae88350bc748598a7d2950e300859469c && cd .. 

RUN source ${ROS_ROOT}/install/setup.bash && cd ${ROS_ROOT} \
#    && rosdep init \
    && rosdep update \
    && rosdep install -y -r --ignore-src --from-paths src --rosdistro ${ROS_DISTRO} src/navigation2

RUN source ${ROS_ROOT}/install/setup.bash && cd ${ROS_ROOT} \
    && colcon build --merge-install  --packages-up-to-regex nav2* --packages-ignore nav2_system_tests 
    
#    && rm -Rf src build log \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean

# Install vda5050_msgs
RUN apt-get update && mkdir -p ${ROS_ROOT}/src && cd ${ROS_ROOT}/src \
    && git clone https://github.com/ipa320/vda5050_msgs.git vda5050_root \
    && cd vda5050_root && git checkout ros2 && cd .. \
    && mv vda5050_root/vda5050_msgs/ vda5050_msgs \
    && rm -rf vda5050_root \
    && source ${ROS_ROOT}/install/setup.bash && cd ${ROS_ROOT} \
    && colcon build --merge-install --packages-up-to vda5050_msgs 
#    && rm -Rf src build log \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean

# Install rosbridge_library
RUN apt-get update && mkdir -p ${ROS_ROOT}/src && cd ${ROS_ROOT}/src \
    && git clone https://github.com/RobotWebTools/rosbridge_suite.git && cd rosbridge_suite && git checkout ros2 && cd .. \
    && source ${ROS_ROOT}/install/setup.bash && cd ${ROS_ROOT} \
    && rosdep install -y -r --ignore-src --from-paths src --rosdistro ${ROS_DISTRO} \
    && colcon build --merge-install --packages-up-to rosbridge_library rosbridge_server 
#    && rm -Rf src build log \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean

# Install patched image_proc package with backported resize node fix
# https://github.com/ros-perception/image_pipeline/pull/786
#RUN apt-get update && mkdir -p ${ROS_ROOT}/src && cd ${ROS_ROOT}/src \
#    && git clone https://github.com/ros-perception/image_pipeline.git && cd image_pipeline && git checkout humble \
#    && git config user.email "builder@nvidia.com" && git config user.name "NVIDIA Builder" \
#    && git remote add fork https://github.com/schornakj/image_pipeline.git && git fetch fork && git cherry-pick fork/pr-backport-693 \
#    && source ${ROS_ROOT}/install/setup.bash && cd ${ROS_ROOT} \
#    && rosdep install -y -r --ignore-src --from-paths src --rosdistro ${ROS_DISTRO} \
#    && colcon build --merge-install --packages-up-to image_proc \
#    && echo "image_pipeline https://github.com/ros-perception/image_pipeline/pull/786" >> ${ROS_ROOT}/VERSION 
#    && rm -Rf src build log \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean

RUN apt-get update && apt-get install net-tools usbutils libpcl-dev libgeographic-dev gdb libpcap-dev iputils-ping -y

RUN pip3 install Jetson.GPIO

