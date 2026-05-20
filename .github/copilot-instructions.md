<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Copilot instructions — dotfiles-nixos](#copilot-instructions--dotfiles-nixos)
  - [Build / test / lint commands](#build--test--lint-commands)
  - [High-level architecture](#high-level-architecture)
  - [Key conventions](#key-conventions)
  - [Useful files to reference](#useful-files-to-reference)
  - [When generating changes or PRs](#when-generating-changes-or-prs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Copilot instructions — dotfiles-nixos

This file gives Copilot sessions repository-specific pointers so suggestions are accurate and actionable.

## Build / test / lint commands

- Build & switch the NixOS configuration (alias `nxs`):

  - Alias: `nxs` (home shell alias) -> `/home/<user>/.local/bin/nix-rebuild-wrapper /etc/nixos#<hostname>`
  - Direct: `sudo nixos-rebuild switch --flake .#<hostname>`
  - Build-only (no switch): `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel`

- Build / switch the standalone home-manager configuration (alias `hms`):

  - Alias: `hms` -> `/home/<user>/.local/bin/home-manager-wrapper /etc/nixos#<hostname>-<username>`
  - Direct: `home-manager switch --flake .#<hostname>-<username>`
  - Build-only: `nix build .#homeConfigurations.<hostname>-<username>.activationPackage`

- Flake input updates: `nix flake update` or `nix flake update <input>` then rebuild (`nxs` / `hms`).

- Tests / linters: this repository does not include a unit test suite or centralized lint tasks. Formatting config exists (e.g., `.stylua.toml`), but no repository-level lint commands are defined.

## High-level architecture

- Flake-based monorepo: `flake.nix` defines `nixosConfigurations` (per-host) and `homeConfigurations` (per-host-user) using `modules/*`, `configs/<hostname>/`, and `homes/<hostname>/<username>.nix`.
- Inputs include `home-manager`, `sops-nix`, `impermanence`, and other flakes; secrets are managed with `sops-nix` and live under `configs/*/secrets.yaml` and `configs/common/secrets.yaml`.
- Modules are split into `modules/nixos` (system-level) and `modules/home-manager` (user-level). Reusable pieces (toolchains, software, utils, scripts) live under `modules/home-manager/*`.
- Persistence / impermanence: some modules declare `persistence."/persist".directories` to keep generated or runtime data (see modules for details). `impermanence` is used to manage what is persisted outside the immutable Nix store.

## Key conventions

- Naming: flake outputs use hostnames and host-user pairs:

  - NixOS: `.#nixosConfigurations.<hostname>`
  - Home: `.#homeConfigurations.<hostname>-<username>`
    Copilot should use these exact attribute names when generating flake build or nix build commands.

- Wrapper scripts and aliases:

  - Aliases defined in `modules/home-manager/aliases.nix`: `nxs` and `hms` map to wrapper scripts in `modules/home-manager/scripts/`.
  - Wrapper scripts (e.g. `nix-rebuild-wrapper.sh`, `home-manager-wrapper.sh`) temporarily disable suspend/lock and log output.
    When suggesting interactive workflows, prefer the wrapper aliases unless explicit `sudo` is required.

- Feature flags & module options:

  - Modules expose `*.enable` options (via `lib.mkEnableOption`) — e.g. `utils.copilot.enable` (see `modules/home-manager/utils/copilot.nix`) to opt-in packages/persistence.
  - Persistence keys (e.g. `.copilot`, `.config/TagStudio`) are declared in modules; preserve them when proposing changes.

- Secrets & sops:

  - Secrets are encrypted with `sops` and configured via `sops-nix` (`.sops.yaml` present). Avoid exposing decrypted secrets in suggestions or example code.

- Commits:

  - All commits follow a conventional commits specification

## Useful files to reference

- `README.md` — installation notes and available `nxs` / `hms` commands
- `flake.nix` — flake outputs and inputs (how `nixosConfigurations` and `homeConfigurations` are constructed)
- `modules/home-manager/scripts/` — wrapper scripts used by aliases
- `configs/<hostname>/` and `homes/<hostname>/` — host/home specific entrypoints

## When generating changes or PRs

- Make minimal, surgical edits to relevant modules or host configs.
- Respect existence of `sops-nix` and do not suggest committing plaintext secrets.
- If recommending new persistent files, add them to the appropriate `persistence."/persist".directories` entry so they survive reboots.

______________________________________________________________________

If anything here should be expanded (for example detailed examples for building specific hosts or adding new modules), say which host(s) or areas to cover and Copilot will produce a follow-up update.
