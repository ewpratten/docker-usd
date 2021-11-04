#! /bin/bash
set -e

docker build -t usd .
docker build -t usd-devcontainer - < devcontainer.dockerfile
docker tag usd ewpratten/usd:latest
docker tag usd-devcontainer ewpratten/usd-devcontainer:latest
docker push ewpratten/usd:latest
docker push ewpratten/usd-devcontainer:latest
