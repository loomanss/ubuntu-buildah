# ubuntu-buildah

## Introduction
Based on the fedora [ContainerFile](https://github.com/containers/image_build/blob/main/buildah/Containerfile) i've rewritten the Dockerfile to an ubuntu based image.

This in combination with info on this [discussion](https://github.com/containers/podman/discussions/18944#discussioncomment-6243939) to add correct (?) Environment variables.
See also the buildah [README.md](https://github.com/containers/image_build/tree/main/buildah).

## build base image

```shell
buildah build -t ubuntu-buildah-base:1.0.0 -f base/Dockerfile
```

## build ubuntu-buildah image

```shell
buildah build -t ubuntu-buildah .
```

## running container

```shell
podman run -e BUILDAH_FORMAT=docker -e BUILDAH_ISOLATION=chroot -e STORAGE_DRIVER=vfs -v /share/github-ep/shared-workflows:/src -it ubuntu-buildah:latest /bin/bash
```

```shell
cd /src/
cd test_files 
buildah build -t test:latest .
buildah images
```


## TO-DO

how to use container with rootless user 'build' 

```shell
podman -u build ....
```

