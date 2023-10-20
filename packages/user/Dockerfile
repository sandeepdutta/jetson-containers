#---
# name : user
# group : jeeves
# depends: [ros:humble-desktop]
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

RUN pip3 install jetson-stats p

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
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
    
RUN pip3 install soundfile pyaudio wave
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
    && adduser ${USERNAME} staff && adduser ${USERNAME} root

# Copy scripts
RUN mkdir -p /usr/local/bin/scripts
COPY scripts/*entrypoint.sh /usr/local/bin/scripts/
RUN  chmod +x /usr/local/bin/scripts/*.sh

# PATCH to enable building isaac_ros_nitros
RUN wget https://raw.githubusercontent.com/NVIDIA-ISAAC-ROS/isaac_ros_common/main/docker/patches/libcudacxx_aarch64_cuda_11_4.diff -P /tmp && \
sudo patch -i /tmp/libcudacxx_aarch64_cuda_11_4.diff /usr/local/cuda-11.4/targets/aarch64-linux/include/cuda/std/detail/libcxx/include/cmath


# Copy middleware profiles
RUN mkdir -p /usr/local/share/middleware_profiles
COPY middleware_profiles/*profile.xml /usr/local/share/middleware_profiles/
RUN chown -R admin /usr/local
ENV USERNAME=${USERNAME}
ENV USER_GID=${USER_GID}
ENV USER_UID=${USER_UID}
