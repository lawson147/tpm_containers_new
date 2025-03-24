FROM ubuntu:22.04


RUN apt-get update && apt-get install -y \
    apt-utils \ 
    wget \
    make \
    gcc \
    libssl-dev \
    libglib2.0-dev \
    pkg-config \
    libdbus-1-dev \
    dbus-x11 \
    libcmocka-dev \
    uthash-dev

# 安装TPM模拟器
COPY ibmtpm1682.tar.gz /
WORKDIR /
RUN mkdir -p /ibmtpm && \
    cd /ibmtpm && \
    tar -zxvf ../ibmtpm1682.tar.gz && \
    cd src && \
    make && \
    cp tpm_server /usr/local/bin/

ENTRYPOINT [ "tpm_server" ]


