FROM nvidia/opengl:base-ubuntu20.04
ARG DEBIAN_FRONTEND=noninteractive

# Select needed PPAs
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN add-apt-repository -y ppa:beineri/opt-qt-5.15.2-focal
RUN apt-get update

# Install Python 3.6 (version must match nvidia release version)
RUN apt-get install -y python3.6
RUN apt-get install -y python3.6-dev
RUN apt-get install -y python3-pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1

# Install dependencies
RUN apt-get install -y curl
RUN apt-get install -y p7zip-full

# Pull in Nvidia's build of USD
RUN mkdir -p /usr/local/nvidia/usd 
RUN curl -L https://developer.nvidia.com/usd-21-05-binary-linux-python-3.6 -o /tmp/usd.7z
RUN 7z x /tmp/usd.7z -o/usr/local/nvidia/usd -y
RUN rm /tmp/usd.7z

# Install graphics libraries
RUN apt-get install -y libgl1-mesa-glx mesa-utils
RUN apt-get install -y qt5-default
RUN apt-get install -y libpyside2-dev  python3-pyside2.qtcore

# Configure the environment
ENV USDROOT /usr/local/nvidia/usd

# Load commonly used python libraries
RUN pip install PySide2
RUN pip install PyOpenGL

# Set the entrypoint (this will auto-config all env vars before launch)
COPY ./entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]