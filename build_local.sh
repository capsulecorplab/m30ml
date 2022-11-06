# !/usr/bin/env bash

# build script for generating unified schema definition for m30ml

if [ ! -r ./dist ]; then
    mkdir dist
fi

gen-yaml src/linkml/m30ml.yaml --mergeimports > dist/m30ml.yaml

# remove imports to work around issue running gen-yaml
yq 'del(.imports)' -i dist/m30ml.yaml
