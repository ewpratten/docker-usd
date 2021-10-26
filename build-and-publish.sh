#! /bin/bash
set -e

docker build -t usd .
docker tag usd ewpratten/usd:latest
docker push ewpratten/usd:latest
