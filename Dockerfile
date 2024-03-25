#syntax=docker/dockerfile:labs
FROM ubuntu:22.04

RUN --security=insecure apt-get update && apt-get install -y wget kmod && cd /root &&\
    VERSION=$(cat /proc/driver/nvidia/version | sed -n 's/.*NVIDIA UNIX x86_64 Kernel Module  \([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p') &&\
    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/$VERSION/NVIDIA-Linux-x86_64-$VERSION.run && \
    chmod +x NVIDIA-Linux-x86_64-$VERSION.run && ./NVIDIA-Linux-x86_64-$VERSION.run -x && rm NVIDIA-Linux-x86_64-$VERSION.run &&\
    /root/NVIDIA-Linux-x86_64-$VERSION/nvidia-installer -a -s --skip-depmod --no-dkms --no-nvidia-modprobe --no-questions --no-systemd --no-x-check --no-kernel-modules --no-kernel-module-source &&\
    rm -rf /root/NVIDIA-Linux-x86_64-$VERSION

RUN --security=insecure mknod --mode 666 /dev/nvidiactl c 195 255 &&\
     mknod --mode 666 /dev/nvidia-uvm c 235 0 &&\
     mknod --mode 666 /dev/nvidia-uvm-tools c 235 1 &&\
     mknod --mode 666 /dev/nvidia0 c 195 0 &&\
     nvidia-smi