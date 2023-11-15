#---
# name: jupyter_nemo
# group: core
# notes: will autostart Jupyter server on port 8888 unless container entry CMD is overridden
#---
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

################################################################
## from numpy
################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  python3-numpy \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
    
# https://github.com/numpy/numpy/issues/18131#issuecomment-755438271
ENV OPENBLAS_CORETYPE=ARMV8


RUN pip3 show numpy && python3 -c 'import numpy; print(numpy.__version__)'
RUN pip3 install --upgrade --no-cache-dir --verbose numpy==1.23.0
RUN pip3 show numpy && python3 -c 'import numpy; import matplotlib; print(numpy.__version__); print(matplotlib.__version__)'
#RUN pip3 uninstall -y setuptools
RUN pip3 install --upgrade --no-cache-dir --verbose setuptools
RUN pip3 show setuptools && python3 -c 'import setuptools; print(setuptools.__version__)' && \
    python3 -c "from setuptools import setup, Extension, distutils"

################################################################
## from jetson-voice
################################################################
################################################################
## ctc-decoders
################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  swig \
          libboost-all-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN git clone https://github.com/sandeepdutta/OpenSeq2Seq -b ctc-decoders  && \
    cd OpenSeq2Seq/decoders && \
    ./setup.sh
    
RUN pip3 install git+https://github.com/NVIDIA/dllogger
RUN pip3 install nltk
# jupyterlab<4 -- ModuleNotFoundError: No module named 'notebook.auth'
RUN pip3 install --no-cache-dir --verbose jupyter 'jupyterlab<4' && \
    pip3 install --no-cache-dir --verbose jupyterlab_widgets
    
RUN jupyter lab --version && jupyter lab --generate-config
RUN python3 -c "from notebook.auth.security import set_password; set_password('password', '/root/.jupyter/jupyter_notebook_config.json')"

################################################################
## Riva GRPC
################################################################
ARG RIVA_URL=https://nvidia.box.com/shared/static/cu8z4t1n6shkxl6z5nh9hpkpn9yxomcz.whl
ARG RIVA_WHL=riva_api-1.0.0ea-py3-none-any.whl

RUN wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${RIVA_URL} -O ${RIVA_WHL} && \
    pip3 install ${RIVA_WHL} --verbose && \
    rm ${RIVA_WHL}

# Install prerequisites
RUN apt-get update && apt-get install -y \
        sudo \
        udev \
        sox \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

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
    && apt-get clean

RUN pip3 install soundfile pyaudio wave pyusb

# Setup non-root admin user
ARG USERNAME=admin
ARG USER_UID=1000
ARG USER_GID=1000

# Create the 'admin' user if not already exists
RUN if [ ! $(getent passwd ${USERNAME}) ]; then \
        groupadd --gid ${USER_GID} ${USERNAME} ; \
        useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} ; \
    fi

# Update 'admin' user
RUN echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && adduser ${USERNAME} video && adduser ${USERNAME} plugdev && adduser ${USERNAME} sudo && adduser ${USERNAME} dialout \
    && adduser ${USERNAME} staff && adduser ${USERNAME} root && adduser ${USERNAME} audio

RUN pip3 install jetson-stats 

ENV USERNAME=${USERNAME}
ENV USER_GID=${USER_GID}
ENV USER_UID=${USER_UID}

# Copy scripts
RUN mkdir -p /usr/local/bin/scripts
COPY scripts/*entrypoint.sh /usr/local/bin/scripts/
RUN  chmod +x /usr/local/bin/scripts/*.sh
CMD /bin/bash -c "jupyter lab --ip 0.0.0.0 --port 8888 --allow-root &> /var/log/jupyter.log" & \
	echo "allow 10 sec for JupyterLab to start @ http://$(hostname -I | cut -d' ' -f1):8888 (password 19jan1996)" && \
	echo "JupterLab logging location:  /var/log/jupyter.log  (inside the container)" && \
	/bin/bash
