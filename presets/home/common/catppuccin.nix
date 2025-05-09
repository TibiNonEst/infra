{ lib, desktop, ... }:
{
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "macchiato";

    cursors.enable = lib.mkIf desktop true;

    gtk = lib.mkIf desktop {
      enable = true;
      gnomeShellTheme = true;
    };
  };

  gtk.enable = lib.mkIf desktop true;

  qt = lib.mkIf desktop {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
