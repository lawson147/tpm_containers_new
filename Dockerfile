FROM minimum2scp/systemd:latest


# RUN apt update && apt install net-tools

ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
CMD ["/sbin/init"]

COPY tpm-server.service /lib/systemd/system/tpm-server.service


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
  libglib2.0-dev

RUN apt-get install -y wget

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

RUN echo $PATH
RUN touch /usr/local/bin/tpm2_server

COPY tpm2-tss /tpm2-tss
WORKDIR /tpm2-tss
RUN ./bootstrap
RUN ./configure --enable-unit
RUN make check
RUN make install && ldconfig


COPY tpm2-abrmd /tpm2-abrmd
WORKDIR /tpm2-abrmd
RUN ./bootstrap
RUN ./configure --with-dbuspolicydir=/etc/dbus-1/system.d --with-systemdsystemunitdir=/lib/systemd/system
RUN make && make install
RUN cp /usr/local/share/dbus-1/system-services/com.intel.tss2.Tabrmd.service /usr/share/dbus-1/system-services/
COPY tpm2-abrmd.service /lib/systemd/system/tpm2-abrmd.service
RUN systemctl enable tpm2-abrmd

COPY tpm2-tools /tpm2-tools
WORKDIR /tpm2-tools
RUN ./bootstrap && ./configure && make && make install

WORKDIR /
RUN apt-get install -y dd

RUN dd if=/dev/zero of=1g_file.bin bs=1G count=1
RUN dd if=/dev/zero of=5g_file.bin bs=1G count=5
RUN dd if=/dev/zero of=10g_file.bin bs=1G count=10

COPY compute.sh /compute.sh