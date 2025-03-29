FROM minimum2scp/systemd:latest

# COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y build-essential \
  autoconf-archive \
  libcmocka0 \
  libcmocka-dev \
  procps \
  iproute2 \
  git \
  pkg-config \
  gcc \
  libtool \
  automake \
  libssl-dev \
  uthash-dev \
  autoconf \
  doxygen \
  libjson-c-dev \
  libini-config-dev \
  libcurl4-openssl-dev \
  libltdl-dev \
  libglib2.0-dev \
  wget

# openssl降级
# COPY openssl-3.0.2.tar.gz /openssl-3.0.2.tar.gz
# WORKDIR /
# RUN tar -zxvf openssl-3.0.2.tar.gz && \
#  cd openssl-3.0.2 && \
#  ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib && \
# make && make install && \
# mv /usr/bin/openssl /usr/bin/openssl.bak && \
# ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl && \
# ln -s /usr/local/ssl/include/openssl /usr/include/openssl && \
# echo "/usr/local/ssl/lib" | sudo tee /etc/ld.so.conf.d/openssl.conf && ldconfig

# RUN ln -s /usr/local/ssl/lib64/libcrypto.so.3 /usr/lib64/libcrypto.so.3 && ln -s /usr/local/ssl/lib64/libssl.so.3 /usr/lib64/libssl.so.3

# RUN echo "/usr/local/ssl/lib64" | sudo tee /etc/ld.so.conf.d/openssl.conf && ldconfig
# RUN rm -rf /usr/include/openssl && ln -s /usr/local/ssl/include/openssl /usr/include/openssl


# COPY ibmtpm1682.tar.gz /ibmtpm1682.tar.gz
# WORKDIR /
# RUN mkdir ibmtpm1682 && cd ibmtpm1682 && tar -zxvf ../ibmtpm1682.tar.gz

# RUN openssl version
# RUN cd ibmtpm1682/src && make && cp ./tpm_server /usr/local/bin/

# libtpm (as the role of simulator)
COPY v0.10.0.tar.gz /v0.10.0.tar.gz
WORKDIR /
# RUN apt-get install -y libtool pkg-config fuzz
RUN tar -zxvf v0.10.0.tar.gz && \
cd libtpms-0.10.0/ && \
./autogen.sh --prefix=/usr/local --with-tpm2 --with-openssl --disable-dependency-tracking && \
make && make install

WORKDIR /tpm2-tss
COPY tpm2-tss /tpm2-tss
RUN ./bootstrap && ./configure --enable-unit --enable-tcti-libtpms=yes && make check && make install && ldconfig

# abrmd
WORKDIR /tpm2-abrmd
COPY tpm2-abrmd /tpm2-abrmd 
RUN ./bootstrap && \
./configure --with-dbuspolicydir=/etc/dbus-1/system.d && \
make && make install && \
cp /usr/local/share/dbus-1/system-services/com.intel.tss2.Tabrmd.service /usr/share/dbus-1/system-services/
COPY tpm2-abrmd.service /usr/local/lib/systemd/system/tpm2-abrmd.service
RUN systemctl enable tpm2-abrmd

# tools
WORKDIR /tpm2-tools
COPY tpm2-tools /tpm2-tools
RUN ./bootstrap && ./configure && make && make install

WORKDIR /


# VOLUME [ "/data" ]
# RUN dd if=/dev/zero of=1g_file.bin bs=1G count=1 && \
# dd if=/dev/zero of=1m_file.bin bs=1M count=1 && \
# dd if=/dev/zero of=100mg_file.bin bs=1M count=100

COPY compute* /
COPY create_ddfiles.sh /
# RUN ./create_ddfiles.sh
# process /tpm_state file
# sudo dd if=/dev/zero of=./tpm_state bs=1M count=5
# COPY NVChip /NVChip 
# RUN chown tss /NVChip && chgrp tss /NVChip

# RUN apt update && apt install net-tools
# COPY tpm-server.service /lib/systemd/system/tpm-server.service


# abrmd daemon process counting tool
COPY notifier.service /usr/local/lib/systemd/system/notifier.service
RUN systemctl enable notifier.service

ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
CMD ["/sbin/init"]
