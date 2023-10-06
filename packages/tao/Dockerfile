#---
# name : tao
# group : jeeves
# depends: [ros:humble-desktop]
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN  apt-get update && apt-get install -y nlohmann-json3-dev
RUN mkdir -p /opt/nvidia/tao 
COPY tao-converter-aarch64-tensorrt8.4.zip /opt/nvidia/tao
RUN cd /opt/nvidia/tao && \
    unzip -j ./tao-converter-aarch64-tensorrt8.4.zip -d /opt/nvidia/tao/jp5 && \
    chmod 755 $(find /opt/nvidia/tao -name "tao-converter") && \
    ln -sf $(find /opt/nvidia/tao -name "tao-converter")  /opt/nvidia/tao/tao-converter && \
    rm ./tao-converter-aarch64-tensorrt8.4.zip

ENV PATH="${PATH}:/opt/nvidia/tao"