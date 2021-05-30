#!/bin/bash

# Set path
echo '::group::Copying $WORKPATH to /tmp/gh-action'
WORKPATH=$GITHUB_WORKSPACE/$INPUT_PATH
# Set path permision
sudo -u builder cp -rfv $WORKPATH /tmp/gh-action
cd /tmp/gh-action
echo '::endgroup::'

# Update checksums
echo '::group::Updating checksums on PKGBUILD'
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    sudo -u builder updpkgsums
    git diff PKGBUILD
fi
echo '::endgroup::'

# Generate .SRCINFO
echo '::group::Generating new .SRCINFO based on PKGBUILD'
if [[ $INPUT_SRCINFO == true ]]; then
    sudo -u builder makepkg --printsrcinfo > .SRCINFO
    git diff .SRCINFO
fi
echo '::endgroup::'

# Validate with namcap
echo '::group::Validating PKGBUILD with namcap'
if [[ $INPUT_NAMCAP == true ]]; then
    namcap -i PKGBUILD
fi
echo '::endgroup::'

# Run makepkg
echo '::group::Running makepkg with flags'
if [[ -n "$INPUT_FLAGS" ]]; then
    sudo -u builder makepkg $INPUT_FLAGS
fi
echo '::endgroup::'

echo '::group::Copying /tmp/gh-action to $WORKPATH'
rsync -avh --delete /tmp/gh-action/ $WORKPATH/
cd $WORKPATH
echo '::endgroup::'
