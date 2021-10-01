#!/bin/bash
set -e

# Set path
echo "::group::Copying file from $WORKPATH to /tmp/gh-action"
WORKPATH=$GITHUB_WORKSPACE/$INPUT_PATH
# Set path permision
sudo -u builder mkdir /tmp/gh-action
sudo -u builder cp -rfv "$WORKPATH"/.git /tmp/gh-action/.git
sudo -u builder cp -fv "$WORKPATH"/PKGBUILD /tmp/gh-action/PKGBUILD
cd /tmp/gh-action
echo "::endgroup::"

# Update pkgver
if [[ -n $INPUT_PKGVER ]]; then
    echo "::group::Updating pkgver on PKGBUILD"
    sed -i "s:^pkgver=.*$:pkgver=$INPUT_PKGVER:g" PKGBUILD
    git diff PKGBUILD
    echo "::endgroup::"
fi

# Update checksums
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    echo "::group::Updating checksums on PKGBUILD"
    sudo -u builder updpkgsums
    git diff PKGBUILD
    echo "::endgroup::"
fi

# Generate .SRCINFO
if [[ $INPUT_SRCINFO == true ]]; then
    echo "::group::Generating new .SRCINFO based on PKGBUILD"
    sudo -u builder makepkg --printsrcinfo > .SRCINFO
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
    sudo -u builder makepkg $INPUT_FLAGS
    echo "::endgroup::"
fi

echo "::group::Copying files from /tmp/gh-action to $WORKPATH"
cp -fv /tmp/gh-action/PKGBUILD "$WORKPATH"/PKGBUILD
if [[ -e /tmp/gh-action/.SRCINFO ]]; then
    cp -fv /tmp/gh-action/.SRCINFO "$WORKPATH"/.SRCINFO
fi
echo "::endgroup::"
