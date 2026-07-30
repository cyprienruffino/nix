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
| `nrs` or `sudo nixos-rebuild switch --flake /home/cyprien/nix#nixos` | Apply system changes |
| `sudo nixos-rebuild test --flake ...` | Apply without making it the boot default |
| `sudo nixos-rebuild boot --flake ...` | Stage for next boot only |
| `nfu` or `nix flake update` | Update all inputs to latest (nixpkgs, home-manager…) |
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
sudo ln -sf /etc/nixos/hardware-configuration.nix /path/to/repo/system/hardware-configuration.nix 
```

> `hardware-configuration.nix` is machine-specific and not tracked in git.

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

## Work agents

Kolide and Twingate are enabled declaratively in [`system/work.nix`](system/work.nix), but
both keep their credentials outside the repo — the nix store is world-readable and
this repo is in git, so secrets must not be declared in nix. Each needs one manual
step per machine.

### Kolide

The launcher is not in nixpkgs; it comes from the `kolide-launcher` flake input
([kolide/nix-agent](https://github.com/kolide/nix-agent)). Drop in the enrollment secret:

```bash
sudo mkdir -p /etc/kolide-k2
printf %s '<enrollment-secret>' | sudo tee /etc/kolide-k2/secret
sudo chmod 600 /etc/kolide-k2/secret
sudo systemctl restart kolide-launcher
```

The secret is per-tenant, not per-device. Get it from `/etc/kolide-k2/secret` on an
existing enrolled Linux/macOS machine, or extract it from the tenant's `.deb`:

```bash
nix shell nixpkgs#dpkg --command dpkg-deb -x kolide-launcher.deb ./kolide && cat ./kolide/etc/kolide-k2/secret
```

Check enrollment with `systemctl status kolide-launcher` and
`journalctl -u kolide-launcher -f`. State lives in `/var/kolide-k2/`.

### Twingate

`services.twingate.enable` gives you the daemon plus the `twingate` CLI. Enroll against
the company network (the `<name>.twingate.com` subdomain), then start it:

```bash
sudo twingate setup       # asks for the network name, writes /etc/twingate/config.json
twingate start            # run as your user, not root, to get the desktop auth prompt
twingate status
```

`twingate start` opens a browser for SSO. Run it unprivileged: as root you get no
desktop notification and have to fall back to `twingate-notifier console`.

| Command | What it does |
|---|---|
| `twingate start` / `twingate stop` | Connect / disconnect |
| `twingate status` | Connection state |
| `twingate resources` | List resources you can reach |
| `sudo journalctl -u twingate -f` | Daemon logs |

> If internal hostnames fail to resolve while Twingate is up, suspect the hardcoded
> `networking.nameservers` (Quad9) in [`system/configuration.nix`](system/configuration.nix):
> Twingate needs to intercept DNS to resolve private resources. Dropping those and
> letting NetworkManager take DNS from the network is the fix.

## Directory structure

```
.
├── flake.nix               # Defines system and home-manager outputs
├── system/
│   └── configuration.nix   # System-wide config (sudo required to apply)
└── home-manager/
    └── home.nix            # User environment, packages, and configs
```
