FROM ubuntu:latest

LABEL "io.containers.capabilities"="CHOWN,DAC_OVERRIDE,FOWNER,FSETID,KILL,NET_BIND_SERVICE,SETFCAP,SETGID,SETPCAP,SETUID,CHOWN,DAC_OVERRIDE,FOWNER,FSETID,KILL,NET_BIND_SERVICE,SETFCAP,SETGID,SETPCAP,SETUID,SYS_CHROOT"

# When building for multiple-architectures in parallel using emulation
# it's really easy for one/more apt processes to timeout or mis-count
# the minimum download rates. Bump both to be extremely forgiving of
# an overworked host.
RUN echo 'APT::Acquire::Retries "5";' >> /etc/apt/apt.conf.d/99retries && \
    echo 'Acquire::http::Timeout "60";' >> /etc/apt/apt.conf.d/99timeout

ARG INSTALL_DEBS="buildah fuse-overlayfs vim"

# Install required packages based on the selected flavor
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common buildah fuse-overlayfs

RUN ln -s /usr/bin/cpp /usr/local/bin/cpp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create necessary directories
RUN mkdir -p /etc/containers /var/lib/shared
ADD ./containers.conf /etc/containers/
ADD ./storage.conf /etc/containers/
# Setup internal Buildah to pass secrets/subscriptions down from host to internal container
RUN printf '/run/secrets/etc-pki-entitlement:/run/secrets/etc-pki-entitlement\n/run/secrets/rhsm:/run/secrets/rhsm\n' > /etc/containers/mounts.conf

# Copy & modify the defaults to provide reference if runtime changes needed.
# Changes here are required for running with fuse-overlay storage inside container.
RUN cp /etc/containers/storage.conf /etc/containers/storage.conf.orig && \
    sed -e 's|^#mount_program|mount_program|g' \
        -e '/additionalimage.*/a "/var/lib/shared",' \
        -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
        /etc/containers/storage.conf.orig \
        > /etc/containers/storage.conf && \
    chmod 644 /etc/containers/storage.conf && \
    chmod 644 /etc/containers/containers.conf

RUN mkdir -p /var/lib/shared/overlay-images \
             /var/lib/shared/overlay-layers \
             /var/lib/shared/vfs-images \
             /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock



