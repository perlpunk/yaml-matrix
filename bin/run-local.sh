#!/bin/bash

# example of running this:
# set -xe ; ( cd ~/proj/yaml-runtimes ; make clean ; for proc in cpp-rapidengine cpp-rapidyaml ; do make $proc list-images ; make testv LIBRARY=$proc ; done ) ; ~/proj/yaml-test-matrix/bin/run-local.sh

set -xe

#procs="${1:-cpp-rapidengine.event cpp-rapidyaml.event cpp-rapidyaml.json cpp-rapidyaml.yaml}"
procs="${1:-cpp-rapidengine.event cpp-rapidyaml.event cpp-rapidyaml.json}"

ROOTDIR=$(dirname $(cd $(dirname $0) ; pwd))

cd $ROOTDIR

cpanm -l local YAML::XS
cpanm -l local HTML::Template::Compiled
export PERL5LIB=$PWD/local/lib/perl5

make data
make matrix
make yaml-test-suite

cp -fv ../yaml-runtimes/list.yaml .
./bin/expected

./bin/run-framework-tests -l
for proc in $procs ; do
    echo "processor: $proc"
    ./bin/run-framework-tests --view $proc
    ./bin/compare-framework-tests --view $proc
done

./bin/create-matrix
./bin/highlight
