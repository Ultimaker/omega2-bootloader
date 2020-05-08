#!/bin/sh

set -eu

TEST_DIR=$(mktemp -d)

COMMANDS=" \
gcc \
git \
make \
wget \
"


result=0

echo_line(){
    echo "--------------------------------------------------------------------------------"
}


check_command_installation()
{
    for pkg in ${COMMANDS}; do
        PATH="${PATH}:/sbin:/usr/sbin:/usr/local/sbin" command -V "${pkg}" || result=1
    done
}

cleanup()
{
       if [ "$(dirname "${TEST_DIR}")" != "/tmp" ]; then
               exit 1
       fi
       rm -rf "${TEST_DIR}"
}

trap cleanup EXIT

echo_line
echo "Verifying build environment commands:"
check_command_installation
echo_line

if [ "${result}" -ne 0 ]; then
    echo "ERROR: Missing preconditions, cannot continue."
    exit 1
fi

echo_line
echo "Build environment OK"
echo_line

exit 0
