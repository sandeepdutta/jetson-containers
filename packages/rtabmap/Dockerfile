#---
# name : rtabmap
# group : jeeves
# depends: []
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ENV LANG=en_US.UTF-8
ENV ROS_PYTHON_VERSION=3
ENV ROS_DISTRO=humble
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

RUN git clone https://github.com/RainerKuemmerle/g2o.git && \
    mkdir -p ./g2o/build && cd ./g2o/build && \
    cmake .. && make -j10 install

RUN  add-apt-repository ppa:borglab/gtsam-release-4.0 &&\
     apt-get update  && \
     apt-get install -y libgtsam-dev libgtsam-unstable-dev

RUN git clone https://github.com/ethz-asl/libnabo.git && \
    mkdir -p ./libnabo/build && cd ./libnabo/build && \
    cmake .. && make -j10 install

RUN git clone https://github.com/norlab-ulaval/libpointmatcher.git && \
    mkdir -p ./libpointmatcher/build && cd ./libpointmatcher/build && \
    cmake .. && make -j10 install

RUN git clone --branch ros2 https://github.com/OctoMap/octomap.git octomap &&\
    mkdir -p ./octomap/build && cd ./octomap/build && \
    cmake  -DCMAKE_BUILD_TYPE=Release .. && make -j10 install

RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git &&\
    cd Pangolin &&\
#    ./scripts/install_prerequisites.sh recommended &&\
    mkdir build && cd build && cmake .. &&\
    make -j10 install

#RUN git clone https://github.com/sandeepdutta/ORB_SLAM3.git &&\
#    cd ORB_SLAM3 &&\
#    git fetch origin pull/970/head:noetic-devel &&\
#    git checkout noetic-devel &&\
#    wget https://gist.githubusercontent.com/matlabbe/c10403c5d44af85cc3585c0e1c601a60/raw/48adf04098960d86ddf225f1a8c68af87bfcf56e/orbslam2_f2e6f51_marchnative_disabled.patch &&\
#    git apply orbslam2_f2e6f51_marchnative_disabled.patch &&\
#    ./build.sh

RUN git clone https://github.com/sandeepdutta/rtabmap.git rtabmap &&\
    cd ./rtabmap && git checkout master && cd .. &&\
    mkdir -p ./rtabmap/build && cd ./rtabmap/build && \
    cmake .. && make -j10 install

# Pre requisites
RUN mkdir -p ${ROS_ROOT}/src && \
    cd ${ROS_ROOT}/src && \
    git clone --branch ros2 https://github.com/ros-perception/perception_pcl && \
    git clone --branch ros2  https://github.com/ros-perception/pcl_msgs.git


RUN mkdir -p ${ROS_ROOT}/src && \
    source ${ROS_ROOT}/install/setup.bash && \
    cd ${ROS_ROOT} && \
    rosdep update && \ 
    rosdep install --from-paths src --ignore-src -r -y  \ 
    --skip-keys "fastcdr rti-connext-dds-6.0.1 rti-connext-dds-5.3.1" && \
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo --packages-select pcl_msgs pcl_conversions pcl_ros 