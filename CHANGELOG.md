# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.4.0] - 2025-06-01

### Added

- Loading PGP Key support - by @dcelasun

## [2.3.0] - 2025-05-27

### Added

- Copy all package files, not just PKGBUILD - by @dcelasun
- Multilib support - by @dcelasun

### Fixed

- Keryring is not updated - by @cilki

## [2.2.1] - 2024-02-19

### Fixed

- Can't pull docker image, so sorry guys

## [2.2.0] - 2022-08-05

### Added

- Option to update archlinux-keyring - by @ReenigneArcher
- Make repository name lowercase - by @ReenigneArcher

## [2.1.1] - 2022-05-15

### Fixed

- Wrong conditional using paru

## [2.1.0] - 2022-05-05

### Added

- Option to resolve deps using paru (from AUR) - by @kamack38

## [2.0.3] - 2022-02-02

### Fixed

- Copied PKGBUILD file has wrong permission

## [2.0.2] - 2022-02-02

### Fixed

- CI can not read changelog

## [2.0.1] - 2022-02-02

### Fixed

- Wrong OCI image tag at action.yml

## [2.0.0] - 2022-02-02

### Changed

- Move repo from hapakaien to hapakaien
- `builder` user is added to sudoers directly instead of via the wheel group
- Replace Docker with Buildah in CI

### Fixed

- `builder` is not in the sudoers file

## [1.1.1] - 2021-10-26

### Fixed

- Wrong `.git` folder when using `path` parameter

## [1.1.0] - 2021-10-02

### Added

- Update `pkgver` on PKGBUILD
- Update `pkgrel` on PKGBUILD

### Fixed

- Missing `set -e` on bash 

## [1.0.3] - 2021-05-30

### Fixed

- $GITHUB_WORKSPACE permission in step after using this action

## [1.0.2] - 2021-05-26

### Fixed

- Docker runner syntax
- Path sntax

## [1.0.1] - 2021-05-19

### Fixed

- Missing documentation

## [1.0.0] - 2021-05-19

### Added

- Initial release

[Unreleased]: https://github.com/hapakaien/archlinux-package-action/compare/v2.4.0...HEAD
[2.4.0]: https://github.com/hapakaien/archlinux-package-action/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/hapakaien/archlinux-package-action/compare/v2.2.1...v2.3.0
[2.2.1]: https://github.com/hapakaien/archlinux-package-action/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/hapakaien/archlinux-package-action/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/hapakaien/archlinux-package-action/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/hapakaien/archlinux-package-action/compare/v2.0.3...v2.1.0
[2.0.3]: https://github.com/hapakaien/archlinux-package-action/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/hapakaien/archlinux-package-action/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/hapakaien/archlinux-package-action/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/hapakaien/archlinux-package-action/compare/v1.1.1...v2.0.0
[1.1.1]: https://github.com/hapakaien/archlinux-package-action/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/hapakaien/archlinux-package-action/compare/v1.0.3...v1.1.0
[1.0.3]: https://github.com/hapakaien/archlinux-package-action/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/hapakaien/archlinux-package-action/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/hapakaien/archlinux-package-action/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/hapakaien/archlinux-package-action/releases/tag/v1.0.0
