#!/bin/bash
docker build . --target "basic" -t "azureml/basic"
docker build . --target "jupyter" -t "azureml/jupyter"
docker build . --target "aio" -t "azureml/kitchensink"
docker build . --target "pytorch" -t "azureml/pytorch"
docker build . --target "tensorflow" -t "azureml/tensorflow"
docker build . --target "scikit-learn" -t "azureml/scikitlearn"