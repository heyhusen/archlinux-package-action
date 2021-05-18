# Base image
FROM docker.io/library/archlinux:base-devel

# Install dependencies
RUN pacman -Syu --needed --noconfirm pacman-contrib namcap

# Setup user
RUN useradd -m builder \
    usermod -aG wheel builder \
    echo 'wheel  ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Copy files
COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
