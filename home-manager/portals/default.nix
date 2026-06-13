{ pkgs, ... }:

let
  waitForWayland = "/bin/sh -c 'n=0; while [ $n -lt 20 ] && ! [ -S $XDG_RUNTIME_DIR/wayland-0 ]; do sleep 0.5; n=$((n+1)); done; [ -S $XDG_RUNTIME_DIR/wayland-0 ]'";
in
{
  # Prevent xdg-desktop-portal-kde from starting before kwin creates the wayland-0 socket.
  # D-Bus activation (via SystemdService=) still picks up this drop-in.
  xdg.configFile."systemd/user/plasma-xdg-desktop-portal-kde.service.d/wait-for-kwin.conf".text = ''
    [Service]
    ExecStartPre=${waitForWayland}
  '';

  # ksecretd is D-Bus-activated directly (no SystemdService= in the system file),
  # so we need a user-level systemd service + D-Bus override.
  xdg.configFile."systemd/user/ksecretd.service".text = ''
    [Unit]
    Description=KWallet Secrets Daemon
    After=plasma-kwin_wayland.service
    PartOf=graphical-session.target

    [Service]
    ExecStartPre=${waitForWayland}
    ExecStart=${pkgs.kdePackages.kwallet}/bin/ksecretd
    Slice=background.slice
    Restart=no
  '';

  xdg.dataFile."dbus-1/services/org.freedesktop.impl.portal.desktop.kwallet.service".text = ''
    [D-BUS Service]
    Name=org.freedesktop.impl.portal.desktop.kwallet
    Exec=${pkgs.kdePackages.kwallet}/bin/ksecretd
    SystemdService=ksecretd.service
  '';
}
