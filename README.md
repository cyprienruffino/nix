# NixOS Configuration

Personal NixOS setup managed with flakes and Home Manager.

- **System changes** (require sudo): `sudo nixos-rebuild switch --flake .`
- **User changes** (no sudo): `home-manager switch --flake .`

## Fresh install setup

After a fresh NixOS install, clone this repo and run these steps once.

### 1. Fix /etc/nixos symlinks

The default `/etc/nixos` files must point to this repo:

```bash
sudo ln -sf /path/to/repo/system/configuration.nix /etc/nixos/configuration.nix
sudo ln -sf /path/to/repo/system/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
```

> `hardware-configuration.nix` is machine-specific and not tracked in git.
> Copy the generated one from `/etc/nixos/` into `system/` before symlinking:
> `cp /etc/nixos/hardware-configuration.nix /path/to/repo/system/hardware-configuration.nix`

### 2. Rebuild the system (enables flakes and installs git)

```bash
sudo nixos-rebuild switch
```

### 3. Track all files with git

Nix flakes only see files tracked by git:

```bash
git add -A
```

### 4. Bootstrap Home Manager

```bash
mkdir -p ~/.local/state/nix/profiles
nix shell nixpkgs#home-manager --command home-manager switch --flake .
```

Home Manager now manages itself — no need to repeat this step.

## Directory structure

```
.
├── flake.nix               # Defines system and home-manager outputs
├── system/
│   └── configuration.nix   # System-wide config (sudo required to apply)
└── home-manager/
    └── home.nix            # User environment, packages, and configs
```
