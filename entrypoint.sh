#!/bin/bash

# Set path
echo '::group::Configuring path with permission'
WORKPATH=$GITHUB_WORKSPACE
if [[ -n "$INPUT_PATH" ]]; then
    WORKPATH=$INPUT_PATH
fi

# Set path permision
sudo chown -R builder $WORKPATH
cd $WORKPATH
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
