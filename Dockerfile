FROM ubuntu:bionic

#
# Make it possible to change UID/GID in the entrypoint script. The docker
# container usually runs as root user on Linux hosts. When the Docker container
# mounts a folder on the host and creates files there, those files would be
# owned by root instead of the current user. Thus we create a user here who's
# UID will be changed in the entrypoint script to match the UID of the current
# host user.
#
ARG USER_UID=1000
ARG USER_NAME=devel
RUN apt-get update -qq && \
    apt-get install -qq -y \
        ca-certificates \
        gosu \
        sudo && \
    groupadd -g ${USER_UID} ${USER_NAME} && \
    useradd -s /bin/bash -u ${USER_UID} -g ${USER_NAME} -o -c "" -m ${USER_NAME} && \
    usermod -a -G sudo ${USER_NAME} && \
    echo "%devel         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN apt-get update -qq \
    && apt-get -y install --no-install-recommends \
        autoconf \
        automake \
        binutils \
        build-essential \
        curl \
        libtool \
        mingw-w64 \
        pkg-config \
        unzip

#RUN wget -nv --continue --tries=20 --waitretry=10 --retry-connrefused \
#        --no-dns-cache --timeout 300 \
#        "http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/simplelink-openocd/latest/exports/simplelink_openocd_1_0.zip"

#RUN unzip -q -o -d sources "simplelink_openocd_1_0.zip"
#RUN cd sources && tar -xzf master.gz

#RUN wget -nv --continue --tries=20 --waitretry=10 --retry-connrefused \
#        --no-dns-cache --timeout 300 \
#        http://software-dl.ti.com/dsps/forms/self_cert_export.html?prod_no=ti_xds110_setup_7.0.100.1_linux_x86_64.bin&ref_url=http://software-dl.ti.com/dsps/dsps_public_sw/sdo_ccstudio/emulation

#ADD ti_xds110_setup_7.0.100.1_linux_x86_64.bin /xds110_setup.bin
#RUN /xds110_setup.bin --mode unattended --prefix /opt/ti/xds110

#RUN mkdir build-mingw-w64
#RUN cd /build-mingw-w64 && mkdir install-root
#RUN cd /build-mingw-w64 && CPPFLAGS="-m64" /sources/sdo-emu-openocd/openocd/configure --enable-xds110 --host="x86_64-w64-mingw32" --prefix="/build-mingw-w64/install-root"
