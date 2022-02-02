#!/bin/bash
set -e

# Set path
WORKPATH=$GITHUB_WORKSPACE/$INPUT_PATH
HOME=/home/builder
echo "::group::Copying files from $WORKPATH to $HOME/gh-action"
# Set path permision
cd $HOME
mkdir gh-action
cd gh-action
cp -rfv "$GITHUB_WORKSPACE"/.git ./
cp -fv "$WORKPATH"/PKGBUILD ./
echo "::endgroup::"

# Update pkgver
if [[ -n $INPUT_PKGVER ]]; then
    echo "::group::Updating pkgver on PKGBUILD"
    sed -i "s:^pkgver=.*$:pkgver=$INPUT_PKGVER:g" PKGBUILD
    git diff PKGBUILD
    echo "::endgroup::"
fi

# Update pkgver
if [[ -n $INPUT_PKGREL ]]; then
    echo "::group::Updating pkgrel on PKGBUILD"
    sed -i "s:^pkgrel=.*$:pkgrel=$INPUT_PKGREL:g" PKGBUILD
    git diff PKGBUILD
    echo "::endgroup::"
fi

# Update checksums
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    echo "::group::Updating checksums on PKGBUILD"
    updpkgsums
    git diff PKGBUILD
    echo "::endgroup::"
fi

# Generate .SRCINFO
if [[ $INPUT_SRCINFO == true ]]; then
    echo "::group::Generating new .SRCINFO based on PKGBUILD"
    makepkg --printsrcinfo > .SRCINFO
    git diff .SRCINFO
    echo "::endgroup::"
fi

# Validate with namcap
if [[ $INPUT_NAMCAP == true ]]; then
    echo "::group::Validating PKGBUILD with namcap"
    namcap -i PKGBUILD
    echo "::endgroup::"
fi

# Run makepkg
if [[ -n $INPUT_FLAGS ]]; then
    echo "::group::Running makepkg with flags"
    makepkg $INPUT_FLAGS
    echo "::endgroup::"
fi

echo "::group::Copying files from $HOME/gh-action to $WORKPATH"
sudo cp -fv PKGBUILD "$WORKPATH"/PKGBUILD
if [[ -e .SRCINFO ]]; then
    sudo cp -fv .SRCINFO "$WORKPATH"/.SRCINFO
fi
echo "::endgroup::"
