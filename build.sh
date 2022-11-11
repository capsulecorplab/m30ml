# !/usr/bin/env bash

if [ ! -r ./dist ]; then
    mkdir dist
fi

# build script for generating unified schema definition for m30ml
# for docker command usage, see https://hub.docker.com/r/linkml/linkml

clitool="gen-yaml"
cmdargs="src/linkml/m30ml.yaml --mergeimports"
cmd="$clitool $cmdargs"
dockercmd="docker run --rm -v $PWD:/work -w /work linkml/linkml:v1.3.0rc1 $cmd"
condition="$clitool --help | grep 'Validate input and produce fully resolved yaml equivalent' > /dev/null"
dest="dist/m30ml.yaml"

if ! eval $condition; then
    eval $(echo $dockercmd) > $dest
else
    eval $cmd > $dest
fi

# remove imports to work around issue running gen-yaml
# for docker command usage, see https://github.com/mikefarah/yq#oneshot-use

clitool="yq"
cmdargs="'del(.imports)' -i dist/m30ml.yaml"
cmd="$clitool $cmdargs"
dockercmd="docker run --rm --user="root" -v $PWD:/workdir mikefarah/yq $cmdargs"
condition="$clitool --help | grep 'yq is a portable command-line YAML processor' > /dev/null"

if ! eval $condition; then
    eval $dockercmd
else
    eval $cmd
fi

# run linkml linter on merged m30ml schema
# for docker command usage, see https://hub.docker.com/r/linkml/linkml
# continue execution on error for linkml-lint, as per https://stackoverflow.com/a/11231970

clitool="linkml-lint"
cmdargs="--format markdown dist/m30ml.yaml"
cmd="$clitool $cmdargs"
dockercmd="docker run --rm -v $PWD:/work -w /work linkml/linkml:v1.3.0rc1 $cmd || true"
condition="$clitool --help | grep 'Show this message and exit.' > /dev/null"
dest="dist/linter-results.md"

if ! eval $condition; then
    eval $(echo $dockercmd) > $dest
else
    eval $cmd > $dest
fi
