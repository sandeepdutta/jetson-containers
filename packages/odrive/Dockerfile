#---
# name : odrive
# group : jeeves
# depends: [ros:humble-desktop]
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ENV LANG=en_US.UTF-8

RUN pip3 install matplotlib
RUN pip3 install --upgrade odrive
RUN pip3 install --upgrade pyserial