#!/bin/bash
set -e

# Set path
HOME=/home/builder
echo "::group::Copying files from $GITHUB_WORKSPACE to $HOME/gh-action"
# Set path permision
cd $HOME
mkdir gh-action
cd gh-action

if [[ -n $INPUT_PGPKEYS ]]; then
  echo "::group::Loading PGP keys"
  for key in ${INPUT_PGPKEYS//,/$'\n'}; do
    gpg --keyserver $INPUT_PGPKEYSERVER --recv-keys $key
  done
  echo "::endgroup::"
fi

# If there is a custom path, we need to copy the whole repository
# because we run "git diff" at several stages and without the entire
# tree the output will be incorrect.
if [[ -n $INPUT_PATH ]]; then
  cp -rTfv "$GITHUB_WORKSPACE"/ ./
  cd $INPUT_PATH
else
  # Without a custom path though, we can just grab the .git directory and the PKGBUILD.
  cp -rfv "$GITHUB_WORKSPACE"/.git ./
  cp -fv "$GITHUB_WORKSPACE"/PKGBUILD ./
fi
echo "::endgroup::"

# Update archlinux-keyring
if [[ $INPUT_ARCHLINUX_KEYRING == true ]]; then
    echo "::group::Updating archlinux-keyring"
    sudo pacman -Syu --noconfirm archlinux-keyring
    echo "::endgroup::"
fi

# Update pkgver
if [[ -n $INPUT_PKGVER ]]; then
    echo "::group::Updating pkgver on PKGBUILD"
    sed -i "s:^pkgver=.*$:pkgver=$INPUT_PKGVER:g" PKGBUILD
    git --no-pager diff PKGBUILD
    echo "::endgroup::"
fi

# Update pkgrel
if [[ -n $INPUT_PKGREL ]]; then
    echo "::group::Updating pkgrel on PKGBUILD"
    sed -i "s:^pkgrel=.*$:pkgrel=$INPUT_PKGREL:g" PKGBUILD
    git --no-pager diff PKGBUILD
    echo "::endgroup::"
fi

# Update checksums
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    echo "::group::Updating checksums on PKGBUILD"
    updpkgsums
    git --no-pager diff PKGBUILD
    echo "::endgroup::"
fi

# Generate .SRCINFO
if [[ $INPUT_SRCINFO == true ]]; then
    echo "::group::Generating new .SRCINFO based on PKGBUILD"
    makepkg --printsrcinfo >.SRCINFO
    git --no-pager diff .SRCINFO
    echo "::endgroup::"
fi

# Validate with namcap
if [[ $INPUT_NAMCAP == true ]]; then
    echo "::group::Validating PKGBUILD with namcap"
    namcap -i PKGBUILD
    echo "::endgroup::"
fi

# Install depends using paru from aur
if [[ $INPUT_AUR == true ]]; then
    echo "::group::Installing depends using paru"
    source PKGBUILD
    paru -Syu --removemake --needed --noconfirm "${depends[@]}" "${makedepends[@]}"
    echo "::endgroup::"
fi

# Run makepkg
if [[ -n $INPUT_FLAGS ]]; then
    echo "::group::Running makepkg with flags"
    makepkg $INPUT_FLAGS
    echo "::endgroup::"
fi

WORKPATH=$GITHUB_WORKSPACE/$INPUT_PATH
WORKPATH=${WORKPATH%/} # Remove trailing slash if $INPUT_PATH is empty
echo "::group::Copying files from $HOME/gh-action to $WORKPATH"
sudo cp -fv PKGBUILD "$WORKPATH"/PKGBUILD
if [[ -e .SRCINFO ]]; then
    sudo cp -fv .SRCINFO "$WORKPATH"/.SRCINFO
fi
echo "::endgroup::"
