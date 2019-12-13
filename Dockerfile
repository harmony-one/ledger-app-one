#Download base ubuntu image
FROM ubuntu:18.04
RUN apt-get update && \
    apt-get -y install build-essential git wget sudo udev zip curl cmake

RUN adduser --disabled-password --gecos "" -u 1000 test
RUN echo "test ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/test

# udev rules
ADD 20-hw1.rules /etc/udev/rules.d/20-hw1.rules

RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -y install libudev-dev libusb-1.0-0-dev && \
    apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386 -y > /dev/null && \
    apt-get -y install binutils-arm-none-eabi

# ARM compilers
ADD install_compiler.sh /tmp/install_compiler.sh
RUN /tmp/install_compiler.sh

# Python
RUN apt-get update && apt-get -y install python3 python3-pip
RUN pip3 install -U setuptools ledgerblue pillow

# ENV
RUN echo "export BOLOS_SDK=/opt/bolos/nanos-secure-sdk" >> /home/test/.bashrc
RUN ln -s /usr/bin/python3 /usr/bin/python


ENV BOLOS_ENV=/opt/bolos
ENV BOLOS_SDK=$BOLOS_ENV/nanos-secure-sdk
#ENV BOLOS_SDK=$BOLOS_ENV/blue-secure-sdk

RUN sudo git clone https://github.com/LedgerHQ/nanos-secure-sdk.git $BOLOS_ENV/nanos-secure-sdk
RUN sudo git clone https://github.com/ledgerhq/blue-secure-sdk $BOLOS_ENV/blue-secure-sdk
RUN sudo apt-get update && sudo apt-get install -y python3-pip

USER test
