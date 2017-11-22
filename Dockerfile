## -*- docker-image-name: "xjdr/proxygen-base" -*-
FROM debian:jessie
MAINTAINER Jeff Rose <jeff.rose12@gmail.com>

# ===== Use the "noninteractive" debconf frontend =====
ENV DEBIAN_FRONTEND noninteractive

# ===== Update apt-get =====
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get upgrade -y

# ===== Install sudo  =====
RUN apt-get -y install sudo locales ca-certificates

# ==== Set locales and Timezones and whatnot =====
RUN sudo echo "America/Los_Angeles" > /etc/timezone
RUN sudo dpkg-reconfigure -f noninteractive tzdata
RUN sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN sudo echo 'LANG="en_US.UTF-8"'>/etc/default/locale
RUN sudo dpkg-reconfigure --frontend=noninteractive locales
RUN sudo update-locale LANG=en_US.UTF-8

# ===== Installing packages =====
RUN apt-get install -y \
    git-core \
    g++ \
    gperf \
    wget \
    unzip \
    curl \
    cmake \
    automake \
    autoconf \
    autoconf-archive \
    libtool \
    libboost-all-dev \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libgtest-dev \
    libgflags-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    make \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    pkg-config \
    libunwind8-dev \
    libelf-dev \
    libdwarf-dev \
    libiberty-dev \
    libcurl4-openssl-dev \
--no-install-recommends

# ===== Install folly =====
RUN git clone https://github.com/facebook/folly

WORKDIR /folly/folly

RUN autoreconf -ivf && \
    ./configure && \
    make -j4 && \
    sudo make install

# ===== Install wangle =====
WORKDIR /
RUN git clone https://github.com/facebook/wangle

WORKDIR /wangle/wangle
RUN cmake . && \
make && \
sudo make install

# ===== Install proxygen =====
WORKDIR /
RUN git clone https://github.com/facebook/proxygen

WORKDIR /proxygen/proxygen

RUN autoreconf -ivf && \
    ./configure && \
    make -j4 && \
    sudo make install

WORKDIR /

# ===== Clean Up Apt-get =====
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean
