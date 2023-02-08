#
# RcloneBrowser Dockerfile
#

FROM jlesage/baseimage-gui:debian-11-v4
LABEL org.opencontainers.image.authors="xxx@163.com"

# Set environment variables.
ENV APP_NAME    "RcloneBrowser"

# Define build arguments
ARG RCLONE_VERSION=current

# Define environment variables
ENV ARCH=amd64

# Define working directory.
WORKDIR /tmp

# Install Rclone Browser dependencies
RUN add-pkg \
      ca-certificates fonts-wqy-zenhei locales \
      fuse wget \
      libgl1 libglib2.0-0 \

    && cd /tmp \
    && wget -q http://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
    && unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
    && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
    && rm -r /tmp/rclone* && \

# Compile RcloneBrowser
    git clone https://github.com/kapitainsky/RcloneBrowser.git /tmp && \
    mkdir /tmp/build && \
    cd /tmp/build && \
    cmake .. && \
    cmake --build . && \
    ls -l /tmp/build && \
    cp /tmp/build/build/rclone-browser /usr/bin  && \

# cleanup
    rm -rf /tmp/*
    
RUN sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8

# Add files.
COPY rootfs/ /
COPY VERSION /
COPY main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc


# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]

