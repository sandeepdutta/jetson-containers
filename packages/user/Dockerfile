#---
# name : user
# group : jeeves
# depends : [python]
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Setup non-root admin user
ARG USERNAME=admin
ARG USER_UID=1000
ARG USER_GID=1000

# Install prerequisites
RUN apt-get update && apt-get install -y \
        sudo \
        udev \
        sox \
        libsndfile1 \
        ffmpeg \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

RUN pip3 install jetson-stats 

################################################################
## install some audio stuff
################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		alsa-base \
        libasound2-dev \
        alsa-utils \
        portaudio19-dev \
		libsndfile1 \
		unzip \
        usbutils \
        python3-rospkg \
        vim \
        libomp-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean *

#RUN wget https://repo.download.nvidia.com/jetson/common/pool/main/libo/libopencv-dev/libopencv-dev_4.5.4-8-g3e4c170df4_arm64.deb
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends \
#        libopencv-dev \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean

RUN pip3 install soundfile pyaudio wave pyusb smbus
# Reuse triton-server user as 'admin' user if exists
RUN if [ $(getent group triton-server) ]; then \
        groupmod -o --gid ${USER_GID} -n ${USERNAME} triton-server ; \
        usermod -l ${USERNAME} -u ${USER_UID} -m -d /home/${USERNAME} triton-server ; \
        mkdir -p /home/${USERNAME} ; \
        sudo chown ${USERNAME}:${USERNAME} /home/${USERNAME} ; \
    fi

# Create the 'admin' user if not already exists
RUN if [ ! $(getent passwd ${USERNAME}) ]; then \
        groupadd --gid ${USER_GID} ${USERNAME} ; \
        useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} ; \
    fi

# Update 'admin' user
RUN echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && adduser ${USERNAME} video && adduser ${USERNAME} plugdev && adduser ${USERNAME} sudo && adduser ${USERNAME} dialout \
    && adduser ${USERNAME} staff && adduser ${USERNAME} root && adduser ${USERNAME} audio && adduser ${USERNAME} i2c \
    && adduser ${USERNAME} rtkit

# Copy scripts
RUN mkdir -p /usr/local/bin/scripts
COPY scripts/*entrypoint.sh /usr/local/bin/scripts/
RUN  chmod +x /usr/local/bin/scripts/*.sh

# PATCH to enable building isaac_ros_nitros
RUN wget https://raw.githubusercontent.com/NVIDIA-ISAAC-ROS/isaac_ros_common/main/docker/patches/libcudacxx_aarch64_cuda_11_4.diff -P /tmp && \
sudo patch -i /tmp/libcudacxx_aarch64_cuda_11_4.diff /usr/local/cuda-11.4/targets/aarch64-linux/include/cuda/std/detail/libcxx/include/cmath

# Install xtl
RUN git clone https://github.com/xtensor-stack/xtl.git && \
    cd xtl && mkdir -p build && cd build && \
    cmake .. && make install 

# Install xsimd
RUN git clone https://github.com/xtensor-stack/xsimd.git && \
    cd xsimd && mkdir -p build && cd build && \
    cmake .. && make install 
# Install xtensor
RUN git clone https://github.com/xtensor-stack/xtensor.git && \
    cd xtensor && mkdir -p build && cd build && \
    cmake .. && make install 
    

# Copy middleware profiles
RUN mkdir -p /usr/local/share/middleware_profiles
COPY middleware_profiles/*profile.xml /usr/local/share/middleware_profiles/
RUN chown -R admin /usr/local
COPY 99-gpio.rules /etc/udev/rules.d/99-gpio.rules 
ENV USERNAME=${USERNAME}
ENV USER_GID=${USER_GID}
ENV USER_UID=${USER_UID}
