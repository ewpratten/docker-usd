# This is a modified version of ewpratten/usd for use as a VSCode devcontainer
FROM mcr.microsoft.com/vscode/devcontainers/python:3.6

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y curl
RUN apt-get install -y p7zip-full

# Pull in Nvidia's build of USD
RUN mkdir -p /usr/local/nvidia/usd 
RUN curl -L https://developer.nvidia.com/usd-21-05-binary-linux-python-3.6 -o /tmp/usd.7z
RUN 7z x /tmp/usd.7z -o/usr/local/nvidia/usd -y
RUN rm /tmp/usd.7z

# Configure the environment
ENV USDROOT /usr/local/nvidia/usd
ENV PATH=${USDROOT}/bin:${USDROOT}/lib:${PATH}
ENV PYTHONPATH=${USDROOT}/lib/python:${PYTHONPATH}
ENV LD_LIBRARY_PATH /usr/local/lib/python3.6/dist-packages/PySide2/Qt/lib:${LD_LIBRARY_PATH}

# Load commonly used python libraries
RUN pip install PySide2
RUN pip install PyOpenGL