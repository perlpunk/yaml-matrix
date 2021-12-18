#!/bin/ash

set -x

if [[ ! -d /yaml-test-suite-data ]]; then
    echo "/yaml-test-suite-data needed"
    exit 1
fi

view="$1"
bulk=$2
timeout=${3:-10}

cd /yaml-test-suite-data

if [[ ! -d /matrix/tmp ]]; then
    echo "/matrix/tmp does not exist"
    exit 1
fi

echo "Running tests in docker..."
if $bulk; then

    export BULK=/matrix/tmp
#    view=/matrix/bin/perl-pp-event
    view=/matrix/bin/perl-refparser-event
    find [A-Z0-9]* -name in.yaml | timeout "$timeout" "$view"

else

for id in [A-Z0-9]*
#for id in 229Q
do
    [[ ! -f $id/in.yaml ]] && continue
    echo -n "Running $id"$'\r'
    # echo "timeout 3 $view < $id/in.yaml > /matrix/tmp/$id.error 2>&1"
    touch /matrix/tmp/$id.error
    timeout 3 $view < $id/in.yaml > /matrix/tmp/$id.stdout 2>/matrix/tmp/$id.stderr
    if [[ $? -eq 0 ]]; then
        rm /matrix/tmp/$id.error
    fi
    [[ -f core ]] && rm core
done

fi

echo "Done        "

