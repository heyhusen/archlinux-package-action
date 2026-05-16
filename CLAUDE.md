# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作时提供指导。

## 项目概述

一个基于 Docker 的 GitHub Action，用于在容器化环境中运行 Arch Linux 打包工具（makepkg、namcap、updpkgsums 等）。用户指向一个 PKGBUILD 文件，该 Action 可以更新 pkgver/pkgrel、重新生成校验和、生成 .SRCINFO、使用 namcap 验证以及运行 makepkg。

## 架构

三个核心文件：

- **`action.yml`** — Action 元数据：定义输入参数，并将其作为位置参数映射到 Docker 入口点。GitHub Actions 自动将 inputs 转换为 `INPUT_*` 环境变量。
- **`Dockerfile`** — 基于 `archlinux:multilib-devel`。安装 pacman-contrib、namcap、git 和 yay-bin。以非特权用户 `builder` 运行，具有 sudo 权限。
- **`entrypoint.sh`** — 主逻辑。读取 `INPUT_*` 环境变量并按顺序执行：加载 PGP 密钥 → 拷贝工作区文件 → 更新 keyring → 更新 pkgver/pkgrel → 更新校验和 → 生成 .SRCINFO → namcap 验证 → 安装 AUR 依赖 → 运行 makepkg。结果拷贝回 `$GITHUB_WORKSPACE`。

输入流：`action.yml` inputs → Docker `args`（位置参数） → GitHub 自动设置 `INPUT_*` 环境变量 → `entrypoint.sh` 读取。

## CI 流水线

工作流（`.github/workflows/main.yml`）包含四个 job：

1. **pretest** — 本地构建 Dockerfile，使用 Spotify PKGBUILD 样例测试（PGP 密钥、pkgrel、校验和、srcinfo）
2. **publish** — 使用 Buildah 构建 OCI 镜像并推送到 `ghcr.io`，打标签（edge、semver、sha）
3. **test** — 拉取已发布的 OCI 镜像，使用另一个 PKGBUILD（plenti-bin）测试
4. **release** — 版本标签（`v*.*.*`）触发，从 CHANGELOG.md 创建 GitHub Release

## 关键约定

- Bash 脚本使用 `set -e`（出错即退出）
- 所有 `INPUT_*` 变量遵循 GitHub Actions 环境变量命名约定
- 工作区文件先拷贝到容器的 `$HOME/gh-action/` 目录，修改后再拷贝回 `$GITHUB_WORKSPACE`
- 设置 `path` 输入时拷贝整个仓库；否则仅拷贝 `.git` 和 `PKGBUILD`
- Shell 风格：4 空格缩进，LF 换行符
- YAML 风格：2 空格缩进
