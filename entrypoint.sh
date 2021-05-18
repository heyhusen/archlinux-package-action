#!/bin/sh -l

# Set path
WORKPATH=$GITHUB_WORKSPACE
if [[ -n "$INPUT_PATH" ]]; then
    WORKPATH=$INPUT_PATH
fi

# Set path permision
sudo chown -R builder $WORKPATH
cd $WORKPATH

# Update checksums
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    echo "Update checksums on PKGBUILD"
    sudo -u builder updpkgsums
    git diff PKGBUILD
fi

# Generate .SRCINFO
if [[ $INPUT_SRCINFO == true ]]; then
    echo "Generate new .SRCINFO based on PKGBUILD"
    sudo -u builder makepkg --printsrcinfo > .SRCINFO
    git diff .SRCINFO
fi

# Run makepkg
if [[ -n "$INPUT_FLAGS" ]]; then
    echo "Run makepkg with flags"
    sudo -u builder makepkg $INPUT_FLAGS
fi

# Validate with namcap
if [[ $INPUT_NAMCAP == true ]]; then
    echo "Validate PKGBUILD with namcap"
    namcap -i PKGBUILD
fi
