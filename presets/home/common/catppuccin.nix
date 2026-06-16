{
  lib,
  pkgs,
  desktop,
  ...
}:
{
  catppuccin = {
    enable = true;
    autoEnable = true; # supress warning
    accent = "lavender";
    flavor = "macchiato";

    cursors.enable = lib.mkIf desktop true;
  };

  gtk = lib.mkIf desktop rec {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    gtk4.theme = theme;
  };

  qt = lib.mkIf desktop {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
