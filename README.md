

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
buldah build -t test:latest .
buildah images
```
