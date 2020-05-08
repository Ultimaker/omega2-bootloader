#!/bin/bash

set -eu

SRC_DIR="$(pwd)"
BUILD_DIR_TEMPLATE="_build"
BUILD_DIR="${SRC_DIR}/${BUILD_DIR_TEMPLATE}"

# Debian package information
PACKAGE_NAME="${PACKAGE_NAME:-omega2-bootloader}"
RELEASE_VERSION="${RELEASE_VERSION:-0.0.0}"

build() {
    make
}

cleanup()
{
    # Remove old build files if they exist
    rm -f "*.ipk"
    rm -rf "${BUILD_DIR}"
}

create_ipk_package()
{
    ######################################################
    # Building an IPK package
    # For reference: https://raymii.org/s/tutorials/Building_IPK_packages_by_hand.html
    IPK_DIR="${BUILD_DIR}/ipk_build"
    mkdir -p "${IPK_DIR}"

    ######################################################
    # First step, make a file called debian-binary
    echo "2.0" > "${IPK_DIR}/debian-binary"

    ######################################################
    # Second step, make the control archive
    mkdir -p "${IPK_DIR}/control"
    sed -e 's|@ARCH@|'"all"'|g' \
        -e 's|@PACKAGE_NAME@|'"${PACKAGE_NAME}"'|g' \
        -e 's|@RELEASE_VERSION@|'"${RELEASE_VERSION}-S1"'|g' \
        "${SRC_DIR}/ipkcontrol/control.in" > "${IPK_DIR}/control/control"

    cp "${SRC_DIR}"/ipkcontrol/p* "${IPK_DIR}"/control/

    # Packaging
    pushd "${IPK_DIR}/control"
    tar --numeric-owner --group=0 --owner=0 -pczf ../control.tar.gz ./*
    popd

    ######################################################
    # Third step, make the data archive
    mkdir -p "${IPK_DIR}/data/"
    cp "uboot.bin" "${IPK_DIR}/data/"

    # Packaging
    pushd "${IPK_DIR}/data"
    tar --numeric-owner --group=0 --owner=0 -pczf ../data.tar.gz ./*
    popd

    ######################################################
    # Last step, packaging it all up
    IPK_PACKAGE_NAME="${PACKAGE_NAME}_${RELEASE_VERSION}.ipk"

    pushd "${IPK_DIR}"
    tar --numeric-owner --group=0 --owner=0 -czf "../${IPK_PACKAGE_NAME}" ./debian-binary ./data.tar.gz ./control.tar.gz
    popd
}

cleanup

build

create_ipk_package

exit 0
