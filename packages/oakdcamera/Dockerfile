#---
# name: oakdcamera
# group: sensors
# depends: [python]
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN git clone https://github.com/luxonis/depthai-core.git && \
    cd depthai-core && git submodule update --init --recursive && \
    cmake -S. -Bbuild -D'BUILD_SHARED_LIBS=ON' && \
    cmake --build build --parallel 10 && cmake --install ./build --prefix /usr/local


#RUN git clone --recursive https://github.com/luxonis/depthai.git && \
#    cd depthai/depthai_sdk && python3 -m pip install depthai-sdk
