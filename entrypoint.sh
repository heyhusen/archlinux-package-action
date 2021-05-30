#!/bin/bash

# Set path
echo '::group::Changing directory to $PATH'
cd ./$INPUT_PATH
echo '::endgroup::'

# Update checksums
echo '::group::Updating checksums on PKGBUILD'
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    sudo -u builder updpkgsums
    sudo -u builder git diff PKGBUILD
fi
echo '::endgroup::'

# Generate .SRCINFO
echo '::group::Generating new .SRCINFO based on PKGBUILD'
if [[ $INPUT_SRCINFO == true ]]; then
    sudo -u builder makepkg --printsrcinfo > .SRCINFO
    sudo -u builder git diff .SRCINFO
fi
echo '::endgroup::'

# Validate with namcap
echo '::group::Validating PKGBUILD with namcap'
if [[ $INPUT_NAMCAP == true ]]; then
    sudo -u builder namcap -i PKGBUILD
fi
echo '::endgroup::'

# Run makepkg
echo '::group::Running makepkg with flags'
if [[ -n "$INPUT_FLAGS" ]]; then
    sudo -u builder makepkg $INPUT_FLAGS
fi
echo '::endgroup::'
