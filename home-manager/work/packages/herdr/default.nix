# herdr — Runway's internal fork of the herdr agent multiplexer, run from a
# git checkout (the fork's intended model) rather than a nix package: a
# nix-built hub embeds no fork build sha and has no checkout to rebuild or
# cross-build from, so self-update and `herdr host update` (pushing builds to
# herd pods) refuse to run. Gates itself on the custom.work.enable flag
# defined in ../../default.nix.
#
# The binary lives at ~/.local/bin/herdr, built from ~/dev/herdr-fork and
# updated in place by the fork's self-updater (global menu → "update herdr",
# which git-pulls master and rebuilds). This module only provides the
# toolchain that rebuild needs:
#   - rustup: the checkout pins its rust via rust-toolchain.toml; downloaded
#     toolchains run thanks to programs.nix-ld in the system config
#   - gcc: `cc` linker for host builds
#   - zig 0.15.2 (exactly — builds the vendored libghostty-vt; from unstable,
#     the same nixpkgs the fork's own devShell pins)
#
# cargo-zigbuild (cross-builds the pod binaries `herdr host update` stages
# and pushes) is deliberately NOT the nixpkgs package: that one is wrapped to
# force its own zig (0.16), which the vendored libghostty-vt rejects. It is
# installed with `cargo install cargo-zigbuild` into ~/.cargo/bin, where the
# fork's PATH fixups look for it, and resolves zig from PATH (the 0.15.2
# below).
{ config, lib, pkgs, pkgsUnstable, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    home.packages = [
      pkgs.gcc
      pkgs.rustup
      pkgsUnstable.zig_0_15
    ];
  };
}
