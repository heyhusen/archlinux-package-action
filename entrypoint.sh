#!/bin/sh -l

sudo chown -R builder $INPUT_PATH
cd $INPUT_PATH

if [[ $INPUT_UPDPKGSUMS == true ]]; then
    echo "Update checksums on PKGBUILD"
    sudo -u builder updpkgsums
    git diff PKGBUILD
fi

if [[ $INPUT_SRCINFO == true ]]; then
    echo "Generate new .SRCINFO based on PKGBUILD"
    sudo -u builder makepkg --printsrcinfo > .SRCINFO
    git diff .SRCINFO
fi

if [[ -n "$INPUT_FLAGS" ]]; then
    echo "Run makepkg with flags"
    sudo -u builder makepkg $INPUT_FLAGS
fi

if [[ $INPUT_NAMCAP == true ]]; then
    echo "Validate PKGBUILD with namcap"
    namcap -i PKGBUILD
fi
