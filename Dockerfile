#
# RcloneBrowser Dockerfile
#

FROM jlesage/baseimage-gui:alpine-3.12-glibc

# Define build arguments
ARG RCLONE_VERSION=current

# Define environment variables
ENV ARCH=amd64

# Define working directory.
WORKDIR /tmp

# Install Rclone Browser dependencies

RUN apk --no-cache add \
      ca-certificates \
      fuse \
      wget \
      qt5-qtbase \
      qt5-qtbase-x11 \
      libstdc++ \
      libgcc \
      dbus \
      xterm \
    && cd /tmp \
    && wget -q http://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
    && unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
    && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
    && rm -r /tmp/rclone* && \

    apk add --no-cache --virtual=build-dependencies \
        build-base \
        cmake \
        make \
        gcc \
        git \
        qt5-qtbase qt5-qtmultimedia-dev qt5-qttools-dev && \

# Compile RcloneBrowser
    git clone https://github.com/kapitainsky/RcloneBrowser.git /tmp && \
    mkdir /tmp/build && \
    cd /tmp/build && \
    cmake .. && \
    cmake --build . && \
    ls -l /tmp/build && \
    cp /tmp/build/build/rclone-browser /usr/bin  && \

    # cleanup
     apk del --purge build-dependencies && \
    rm -rf /tmp/*


# Add files.
COPY rootfs/ /
COPY VERSION /
COPY main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc

# Set environment variables.
ENV APP_NAME="RcloneBrowser" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]

