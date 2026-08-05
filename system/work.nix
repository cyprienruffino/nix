# Work-machine configuration: the mandated device agents (each needs a
# one-time manual enrollment step, documented under "Work agents" in the
# README) plus fixes for the work laptop hardware.
#
# This is opt-in: nothing here is active unless `custom.work.enable = true`,
# which the `nixos-work` flake output sets. A plain `.#nixos` build leaves it off.
{ config, lib, ... }:

{
  options.custom.work.enable =
    lib.mkEnableOption "work-mandated device agents (Kolide, Twingate, JumpCloud)";

  config = lib.mkIf config.custom.work.enable {
    # Distinct hostname so `--flake .` (no fragment) auto-selects the work
    # profile — both for nixos-rebuild and for standalone home-manager, which
    # matches homeConfigurations."cyprien@<hostname>". Prevents a plain `nrs`
    # from silently reverting a work machine to the personal profile and
    # de-enrolling the agents below.
    networking.hostName = "nixos-work";

    # Docker daemon + CLI. The daemon is work-only; the docker group grant
    # lives here too (docker group ≈ passwordless root, so it should not
    # exist on machines without the daemon).
    virtualisation.docker.enable = true;
    users.users."cyprien".extraGroups = [ "docker" ];

    # Kolide device-compliance agent (from the kolide-launcher flake input).
    # The enrollment secret is deliberately NOT declared here: anything set via
    # environment.etc ends up world-readable in the nix store, and this repo is
    # in git. It lives in /etc/kolide-k2/secret, created out of band.
    services.kolide-launcher.enable = true;

    # Twingate client daemon + the `twingate` CLI.
    # Enrollment is stored in /etc/twingate, written by `sudo twingate setup`.
    services.twingate.enable = true;

    # JumpCloud agent (from the jumpcloud-nix flake input — not in nixpkgs).
    # Enrolls for inventory and device trust, NOT user-login/PAM management.
    # The connect key lives in /etc/jumpcloud/connect-key, created out of band.
    services.jumpcloud-agent.enable = true;

    # The work laptops ship a QWERTY keyboard, so driving them as AZERTY
    # (services.xserver.xkb.layout = "fr" in configuration.nix) leaves one key
    # with nowhere to live: <LSGT>, the `< >` key AZERTY puts left of the
    # alphanumeric block. Its slot was absorbed by a double-width left Shift.
    # The Copilot key (bottom right, right of AltGr) is unused, so keyd
    # rebinds it to fill the gap.
    #
    # The Copilot key is not a plain keycode — the firmware emits the atomic
    # Microsoft chord LeftMeta+LeftShift+F23 (0xdb/0x2a/0x6e, all three inside
    # 0.5ms; verified with evtest on /dev/input/event0). Hence keyd rather than
    # a udev/hwdb scancode remap: the chord reuses the *real* Shift and Meta
    # scancodes, so remapping those scancodes would break both modifiers.
    #
    # Getting Shift+Copilot to mean `>` needs a trick, because the chord
    # contains a LeftShift of its own. The lever is *ordering*: the firmware
    # always sends LeftMeta before LeftShift, so a leftshift binding placed
    # inside the [meta] layer fires only for the chord. When a human holds
    # Shift first, shift keeps its ordinary main-layer meaning and the chord's
    # second LeftShift press never reaches userspace at all — the kernel input
    # core drops a key-down for an already-pressed key.
    #
    # Remapping below xkb (rather than in an xkb symbols override) means
    # `102nd` picks up whatever the fr layout puts on <LSGT>, and it works
    # identically in Wayland, X, the TTY and games.
    services.keyd = {
      enable = true;
      keyboards.internal = {
        # The built-in i8042 keyboard only ("AT Translated Set 2 keyboard").
        # External keyboards have a real <LSGT> key and are left untouched.
        ids = [ "0001:0001" ];

        # All of this goes in extraConfig rather than `settings`: order is
        # significant (a compound layer must follow the layers it is made of)
        # and `settings` is an unordered attrset.
        extraConfig = ''
          # Only the chord presses LeftShift while Meta is already down, so
          # this reinterpretation is invisible to normal typing.
          [meta]
          leftshift = layer(copilot)

          # Carries Shift so that genuine Meta+Shift+<key> shortcuts pressed in
          # that order keep working; only the explicit bindings below differ.
          [copilot:S]

          # Copilot -> `<`. A compound layer ignores the modifiers of its
          # constituents, so this emits a bare <LSGT> with neither Meta nor
          # Shift attached — important, since toolkits drop text input that
          # arrives with Super held.
          [meta+copilot]
          f23 = 102nd

          # Shift+Copilot -> `>`. Shift went down first, so it activated the
          # stock shift layer instead of the copilot layer above.
          [meta+shift]
          f23 = S-102nd

          # Same, for right Shift: its keycode differs from the LeftShift in
          # the chord, so that one is not a duplicate and both layers activate.
          [meta+shift+copilot]
          f23 = S-102nd
        '';
      };
    };
  };
}
