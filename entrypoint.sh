#! /bin/bash
# This file defines all the env vars that shall be set before launching a python interpreter
set -e

# Set the env
export PATH=$USDROOT/bin:$USDROOT/lib:$PATH
export PYTHONPATH=$USDROOT/lib/python:$PYTHONPATH
export LD_LIBRARY_PATH=/usr/local/lib/python3.6/dist-packages/PySide2/Qt/lib:$LD_LIBRARY_PATH

# Run whatever the user wants
$@