# Arch Linux's package tools action

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/hapakaien/archlinux-package-action/CI?label=CI&style=flat-square)](https://github.com/hapakaien/archlinux-package-action/actions) [![GitHub release (latest by date)](https://img.shields.io/github/v/release/hapakaien/archlinux-package-action?style=flat-square)](https://github.com/hapakaien/archlinux-package-action/releases) [![GitHub](https://img.shields.io/github/license/hapakaien/archlinux-package-action?style=flat-square)](./LICENSE)

This action allows running tools needed for creating Arch Linux (and AUR) package. 
Here's what this action can do:

- Update `pkgver`, `pkgrel`, or checksums on PKGBUILD file
- Validate PKGBUILD with [namcap](https://wiki.archlinux.org/title/namcap)
- Generate [.SRCINFO](https://wiki.archlinux.org/title/.SRCINFO) based on your PKGBUILD
- Run [makepkg](https://wiki.archlinux.org/title/Makepkg) with custom flags (rather than default)

## Usage

### Requirement

- [PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) file inside your repository.
- Use [actions/checkout](https://github.com/actions/checkout) in previous step. This is important, unless you want your [$GITHUB_WORKSPACE](https://docs.github.com/en/actions/reference/environment-variables#default-environment-variables) folder to be empty.

### Customizing

Following inputs can be used as `step.with` keys

| Name              | Type      | Default                       | Required  | Description                           |
|-------------------|-----------|-------------------------------|-----------|---------------------------------------|
| `path`            | String    |                               | `false`   | Path where PKGBUILD is located. This path always located under $GITHUB_WORKSPACE |
| `pkgver`          | String    |                               | `false`   | Update `pkgver` on your PKGBUILD |
| `pkgrel`          | Integer   |                               | `false`   | Update `pkgrel` on your PKGBUILD |
| `updpkgsums`      | Boolean   | `false`                       | `false`   | Update checksums on your PKGBUILD     |
| `srcinfo`         | Boolean   | `false`                       | `false`   | Generate new .SRCINFO                 |
| `namcap`          | Boolean   | `true`                        | `false`   | Validate PKGBUILD                     |
| `flags`           | String    | `-cfs --noconfirm`            | `false`   | Flags after `makepkg` command. Leave this empty will disable this command. |

### Examples

#### 1. Basic

This action will run `makepkg -cfs --noconfirm` command, then validate PKGBUILD with namcap.

```yaml
name: CI

on:
  push:
    branches: main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Validate package
        uses: hapakaien/archlinux-package-action@v2
```

#### 2. Only generate .SRCINFO

```yaml
name: CI

on:
  push:
    branches: main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Validate package
        uses: hapakaien/archlinux-package-action@v2
        with:
          flags: ''
          namcap: false
          srcinfo: true
```

#### 3. Only update checksums on PKGBUILD

```yaml
name: CI

on:
  push:
    branches: main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Validate package
        uses: hapakaien/archlinux-package-action@v2
        with:
          flags: ''
          namcap: false
          updpkgsums: true
```

#### 4. Custom path & custom flags

```yaml
name: CI

on:
  push:
    branches: main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Validate package
        uses: hapakaien/archlinux-package-action@v2
        with:
          path: package
          flags: '-si --noconfirm'
          namcap: false
```

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE)
