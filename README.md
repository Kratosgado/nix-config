# README.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Building and Deploying

- `sudo nixos-rebuild switch --flake .#nixos` - Rebuild and switch to new NixOS configuration
- `nixos-rebuild switch --flake .#nixos --use-remote-sudo` - Rebuild with remote sudo (if needed)
- home-manager is loaded as a NixOS module here, so `nixos-rebuild switch` also applies home-manager changes (no separate `home-manager switch` needed)
- `nix flake update` - Update flake inputs (updates flake.lock)
- `nix run .` - Test nixvim configuration standalone

### Development and Validation

- `nix flake check` - Validate flake syntax and configuration
- `nix eval .#nixosConfigurations.nixos.config.system.build.toplevel` - Check configuration evaluation
- `nix-store --gc` - Garbage collect old generations
- `nixos-option <option>` - Query NixOS configuration options

## Architecture Overview

This is a NixOS flake-based configuration with integrated home-manager setup for user `kratosgado`.

### Core Structure

- **flake.nix**: Main flake configuration defining nixosConfigurations.nixos system
- **configuration.nix**: System-level NixOS configuration (services, hardware, users)
- **home.nix**: User-level home-manager configuration (packages, dotfiles, user services)
- **hardware-configuration.nix**: Hardware-specific configuration (auto-generated)

### Module Organization

- **packages/**: Modularized home-manager package configurations
  - `packages/default.nix`: Imports all package modules
  - `packages/neovim.nix`: Neovim/nixvim configuration
  - `packages/apps.nix`: Application packages
  - `packages/devtools.nix`: Development tools
  - `packages/zsh.nix`: Zsh shell configuration
- **overlays/**: Nix package overlays for pinning specific package versions
  - `overlays/pinned-packages.nix`: Pins specific packages to commit `8eaee110344796db060382e15d3af0a9fc396e0e`
- **nixvim/**: Standalone nixvim configuration (legacy, see README.md)
- **vscode/**: VS Code configuration module
- **files/**: Static files (wallpapers, icons) copied to home directory

### Key Configuration Patterns

#### Flake Integration

- Uses nixos-unstable channel
- Home-manager integrated as NixOS module (not standalone)
- Single system configuration: `nixosConfigurations.nixos`
- Home-manager user: `kratosgado`

#### Package Management

- System packages in `configuration.nix` environment.systemPackages
- User packages in `home.nix` home.packages
- Development environment variables extensively configured in home.sessionVariables
- Support for Prisma, Android SDK, Node.js, Java development environments

#### Desktop Environment

- GNOME desktop with GDM display manager
- Custom GNOME extensions (dash-to-dock, hide-top-bar, gsconnect)
- Andromeda GTK theme
- Custom wallpaper and user avatar setup

#### Development Setup

- Docker with rootless configuration
- Android development (ADB enabled)
- Multiple language toolchains (Node.js, Java, Kotlin, etc.)
- Direnv and nix-direnv integration
- Git with libsecret credential helper

### Important Notes

- System uses flakes and nix-command experimental features
- Allows unfree packages globally (nixpkgs.config.allowUnfree)
- Home-manager backups files with ".backup" extension
- Uses JetBrainsMono Nerd Font
- Timezone: Africa/Accra, Locale: en_GB.UTF-8

### Overlay Usage

The pinned-packages overlay pins specific problematic packages to a known working nixpkgs commit. Currently pins:

- android-studio
- jetbrains.idea-community

When adding new packages that may need pinning, add them to `overlays/pinned-packages.nix` and uncomment the overlay line in `flake.nix`.

### Bootstrap (non-Nix tools)

Not everything is packaged in nixpkgs. After the first `nixos-rebuild switch`, run:

```
./bootstrap.sh
```

That script installs nvm, sdkman, opencode, claude-code, cursor-agent, composio, and prompts for the ones (caa, kiro) that must be fetched manually.

### User Parameterization

Username and hostname are set in one place — `flake.nix`:

```nix
user = "kratosgado";
userDescription = "Kratosgado";
hostName = "nixos";
```

They are threaded into `configuration.nix`, `home.nix`, and `packages/zsh.nix` via `specialArgs` / `extraSpecialArgs`.
