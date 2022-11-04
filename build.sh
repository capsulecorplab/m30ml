# !/usr/bin/env bash

# build script for generating unified schema definition for m30ml

if [ ! -r ./dist ]; then
    mkdir dist
fi

docker run --rm -v $PWD:/work -w /work linkml/linkml gen-yaml src/linkml/m30ml.yaml --mergeimports > dist/m30ml.yaml
