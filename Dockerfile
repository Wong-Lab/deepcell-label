FROM ubuntu:16.04

# System maintenance
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  python3-tk \
  python3-dev \
  python3-pip \
  mesa-utils \
  autoconf \
  automake \
  libtool \
  libffi-dev \
  git \
  libssl-dev \
  xorg-dev \
  libvncserver-dev \
  libglu1-mesa libgl1-mesa-dev \
  x11vnc \
  xvfb \
  fluxbox \
  wmctrl \
  libsm6 && \
  rm -rf /var/lib/apt/lists/* && \
  pip3 install --upgrade pip

# download  source code
RUN cd /root && mkdir src && cd src && git clone https://github.com/LibVNC/x11vnc

# compile and install , default install path /usr/local/bin/x11vnc
RUN apt-get remove -y x11vnc \
  && cd /root/src/x11vnc \
  && autoreconf -fiv \
  && ./configure \
  && make \
  && make install

# clean source code and some tools
RUN rm -rf /root/src/ \
  && apt-get remove --purge -y autoconf automake libtool libffi-dev git libssl-dev xorg-dev libvncserver-dev

WORKDIR /usr/src/app

# Copy the requirements.txt and install the dependencies
COPY setup.py requirements.txt ./
RUN pip3 install -r requirements.txt

# Copy the rest of the package code and its scripts
COPY . .

# Install via setup.py
RUN pip3 install .

CMD "bin/entrypoint.sh"
