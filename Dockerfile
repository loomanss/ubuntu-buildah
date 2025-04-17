FROM part1:latest

# Define uid/gid ranges for our user https://github.com/containers/buildah/issues/3053
RUN useradd -U -m -d /home/build build && \
    echo -e "build:1:999\nbuild:1001:64535" > /etc/subuid && \
    echo -e "build:1:999\nbuild:1001:64535" > /etc/subgid && \
    mkdir -p /home/build/.local/share/containers && \
    mkdir -p /home/build/.config/containers && \
    chown -R build:build /home/build
# See:  https://github.com/containers/buildah/issues/4669
# Copy & modify the config for the `build` user and remove the global
# `runroot` and `graphroot` which current `build` user cannot access,
# in such case storage will choose a runroot in `/var/tmp`.

RUN cp /etc/containers/storage.conf /home/build/.config/containers/storage.conf 
RUN cat /home/build/.config/containers/storage.conf
RUN sed -i 's|^#mount_program|mount_program|g' /home/build/.config/containers/storage.conf && \
    sed -i 's|^graphroot|#graphroot|g' /home/build/.config/containers/storage.conf && \
    sed -i 's|^runroot|#runroot|g' /home/build/.config/containers/storage.conf && \
    chown build:build /home/build/.config/containers/storage.conf

VOLUME /var/lib/containers
VOLUME /home/build/.local/share/containers

# Set an environment variable to default to chroot isolation for RUN
# instructions and "buildah run".
ENV BUILDAH_ISOLATION=chroot
