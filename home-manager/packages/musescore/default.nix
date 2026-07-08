{ ... }:

{
  # MuseScore is installed via Flatpak to avoid a Qt 6.9 crash in the
  # "New Score" QML dialog (QQmlConnections::connectSignalsToMethods SIGSEGV).
  # The Flatpak bundles its own Qt, bypassing the incompatibility.
  #
  # After `nrs`, run once:
  #   flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #   flatpak install flathub org.musescore.MuseScore
}
