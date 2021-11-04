# Universal Scene Description in Docker
![Docker Pulls](https://img.shields.io/docker/pulls/ewpratten/usd)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/ewpratten/usd)

This project aims to build an easy to use Docker container that contains everything needed for me to experiment with Pixar's [Universal Scene Description (USD)](http://openusd.org/) in a safe and reproducible environment.

Currently, the container is built on top of NVIDIA's [pre-built USD packages](https://developer.nvidia.com/usd), targeting [USD `21.5`](https://github.com/PixarAnimationStudios/USD/blob/release/CHANGELOG.md#2105---2021-04-12) and Python `3.6`. These versions can be changed by cloning this repository, editing the `Dockerfile`, and building the container yourself.

## Basic usage

The entire USD toolset is available, and on the `$PATH` inside the container (handled by the entrypoint script automatically). This means that you can simply run one of the pre-built USD commands, such as `usdview`, `usdcat`, or `usdwrite`, and it will be run inside the container. For example, we can `cat` one of the example USD files in the container:

```sh
docker run --rm ewpratten/usd usdcat /usr/local/nvidia/usd/share/usd/tutorials/convertingLayerFormats/Sphere.usd
```

**Note:** Inside the container, USD is installed in `/usr/local/nvidia/usd`. This location is stored in the environment variable `$USDROOT`, accessible from any scripts run in the container.

## X11 passthrough

Some USD utilities (for example, `usdview`) require an OpenGL context, and a display to draw to. This is usually not possible in a regular Docker container (at least not without a lot of extra work). To get around this, the USD Docker container is built on NVIDIA's [`nvidia/opengl:base-ubuntu20.04`](https://hub.docker.com/r/nvidia/opengl) base image, and due to which, can be run via the [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker). To view the example `HelloWorld.usd` file used in Pixar's [*Referencing Layers*](https://graphics.pixar.com/usd/docs/Referencing-Layers.html) tutorial, we can run the following command (on a Linux host):

```sh
nvidia-docker run -it \
    --user=$(id -u $USER):$(id -g $USER) \
    --env DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --env QT_X11_NO_MITSHM=1 \
    ewpratten/usd \
    usdview /usr/local/nvidia/usd/share/usd/tutorials/referencingLayers/HelloWorld.usda
```

## Running your own code 

Aside from a few modifications to the environment and package versions, this is essentially just a regular Ubuntu 20.04 Docker base image, and can be used as such.

To execute your own code in the container, either extend the image with our own `Dockerfile`, or mount your application as a volume to `ewpratten/usd`. Keep in mind, when doing either, that the USD Docker container uses a custom [`entrypoint.sh`](./entrypoint.sh) script, which does a bit of environment setup. Make sure to initialize the environment yourself if overriding the container entrypoint.

## VSCode Devcontainers

In order to get autocomplete for the `pxr` Python library in VSCode without building USD on my development machine, I have built a custom [devcontainer](https://code.visualstudio.com/docs/remote/containers) for USD development. Using it in your editor is as simple as creating a file at `.devcontainer/devcontainer.json` with the following contents:

```json
{
    "name": "USD Development",
    "image": "ewpratten/usd-devcontainer:latest",
    "extensions": [
        "ms-python.vscode-pylance",
        "ms-python.python"
    ],
    "remoteUser": "vscode"
}
```
