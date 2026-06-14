# NixOS Configuration

Personal NixOS setup managed with flakes and Home Manager.

- **System changes** (require sudo): `sudo nixos-rebuild switch --flake .`
- **User changes** (no sudo): `home-manager switch --flake .`

## Cheat-sheet

### Day-to-day

| Command | What it does |
|---|---|
| `hms` | Apply home-manager changes (alias) |
| `hmn` | Show home-manager changelog |
| `sudo nixos-rebuild switch --flake /home/cyprien/nix#nixos` | Apply system changes |
| `sudo nixos-rebuild test --flake ...` | Apply without making it the boot default |
| `sudo nixos-rebuild boot --flake ...` | Stage for next boot only |
| `nix flake update` | Update all inputs to latest (nixpkgs, home-manager…) |
| `nix flake update nixpkgs` | Update a single input |

### Packages

| Command | What it does |
|---|---|
| `nix search nixpkgs#<name>` | Search for a package |
| `nix shell nixpkgs#<name>` | Temporarily add a package to PATH |
| `nix run nixpkgs#<name>` | Run a package without installing it |
| `nix eval nixpkgs#<name>.version` | Check the version in nixpkgs |

### Generations & cleanup

| Command | What it does |
|---|---|
| `nixos-rebuild list-generations` | List system generations |
| `home-manager generations` | List home-manager generations |
| `sudo nix-collect-garbage -d` | Delete all old system generations and GC |
| `nix-collect-garbage -d` | Delete old home-manager generations and GC |
| `nix store gc` | GC without deleting generations |

### Debugging

| Command | What it does |
|---|---|
| `nix flake check` | Validate the flake |
| `home-manager build --flake .#"cyprien@nixos"` | Build without activating |
| `nix log <drv-path>` | Show build log for a derivation |
| `nix why-depends nixpkgs#foo nixpkgs#bar` | Why does foo pull in bar? |
| `nix-store -q --references <path>` | List runtime dependencies of a store path |


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
