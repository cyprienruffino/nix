# NixOS Configuration

Personal NixOS setup managed with flakes and Home Manager.

- **System changes** (require sudo): `sudo nixos-rebuild switch --flake . --impure`
- **User changes** (no sudo): `home-manager switch --flake .`

The machine's hostname selects the profile: `nixos` machines get the personal
profile, `nixos-work` machines the work one (compliance agents, work packages —
see [Work agents](#work-agents)). The same commands and aliases work everywhere.

`--impure` is deliberate: the machine-specific `hardware-configuration.nix` is
imported from `/etc/nixos/` rather than tracked here, so one repo works on any
machine (see [Fresh install setup](#fresh-install-setup)).

## Cheat-sheet

### Day-to-day

| Command | What it does |
|---|---|
| `hms` | Apply home-manager changes (also `git add --intent-to-add`s new files so the flake can see them) |
| `hmn` | Show home-manager changelog |
| `nrs` or `sudo nixos-rebuild switch --flake /home/cyprien/nix --impure` | Apply system changes |
| `sudo nixos-rebuild test --flake ... --impure` | Apply without making it the boot default |
| `sudo nixos-rebuild boot --flake ... --impure` | Stage for next boot only |
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

The installer-generated `/etc/nixos/hardware-configuration.nix` stays where it
is — it is the machine-specific source of truth, and `system/configuration.nix`
imports it from there. That import is what makes every system rebuild need
`--impure`; the trade-off is that this repo works unmodified on any machine.
(`/etc/nixos/configuration.nix` becomes dead weight once the flake is in charge.)

### 1. Rebuild the system from the flake

Flakes and git aren't available yet on a bare install, so bring your own git
and enable flakes for just this one command (the rebuild then enables them
permanently):

```bash
nix-shell -p git
sudo env PATH="$PATH" nixos-rebuild switch --flake .#nixos --impure \
  --option extra-experimental-features "nix-command flakes"
```

> **Work machine?** Use `.#nixos-work` instead. The explicit fragment is only
> needed this first time: the work profile sets the hostname to `nixos-work`,
> and every later rebuild auto-selects the profile from the hostname.

### 2. Bootstrap Home Manager

```bash
mkdir -p ~/.local/state/nix/profiles
nix shell nixpkgs#home-manager --command home-manager switch --flake .
```

Home Manager now manages itself — no need to repeat this step. It also picks
its profile from the hostname (`cyprien@nixos` vs `cyprien@nixos-work`), so
rebuild the system first on a work machine.

> Nix flakes only see git-tracked files. The `hms` alias runs
> `git add --intent-to-add -A` before switching, which makes new files visible
> to the flake without staging their content.

## Work agents

Kolide, Twingate and JumpCloud are enabled declaratively in [`system/work.nix`](system/work.nix),
but all keep their credentials outside the repo — the nix store is world-readable and
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

### JumpCloud

The agent is not in nixpkgs; it comes from the `jumpcloud-nix` flake input
([cyprienruffino/jumpcloud-nix](https://github.com/cyprienruffino/jumpcloud-nix)) — see
there for how it works and its scope (enrollment/inventory only, no managed-user login).
Get the connect key from the admin console under
[Security → Device Enrollment](https://console.jumpcloud.com/userconsole#/security?tab=deviceEnrollment)
(click **Generate Command** and copy the `x-connect-key` value), then drop it in and rebuild:

```bash
sudo mkdir -p /etc/jumpcloud
printf %s '<connect-key>' | sudo tee /etc/jumpcloud/connect-key
sudo chmod 600 /etc/jumpcloud/connect-key
sudo nixos-rebuild switch --flake . --impure
```

The key rotates, so grab a fresh one; until the device is enrolled the service re-reads it
on every start, so rotating is just update-the-file + `sudo systemctl restart jcagent`.
Check enrollment with `systemctl status jcagent` and `journalctl -u jcagent -f`; state
lives in `/opt/jc/`. The device appears in the console as **Ubuntu 22.04**.

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

> If internal hostnames ever fail to resolve while Twingate is up, the first
> suspect is the hardcoded `networking.nameservers` (Quad9) in
> [`system/configuration.nix`](system/configuration.nix): Twingate needs to
> intercept DNS to resolve private resources. In practice its interception has
> always won out, but if it doesn't, drop those and let NetworkManager take DNS
> from the network.

## Directory structure

```
.
├── flake.nix               # Defines system and home-manager outputs
├── system/
│   ├── configuration.nix   # System-wide config (sudo required to apply)
│   └── work.nix            # Work toggle: hostname, docker, compliance agents
└── home-manager/           # home.nix auto-imports every subdirectory
    ├── home.nix            # Entry point; maps res/ into ~/.local/res
    ├── packages/           # Flat list of user packages
    ├── programs/           # Per-program config (git, kitty, plasma, …)
    ├── scripts/            # Small personal scripts wrapped as packages
    ├── shell/              # zsh, aliases, direnv, zoxide
    ├── portals/            # xdg-desktop-portal/kwallet ordering fixes
    └── work/               # Work toggle: work-only packages and git identity
```
