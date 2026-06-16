{ pkgs, ... }:
{
  programs = {
    xfconf.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-vcs-plugin
        thunar-volman
      ];
    };
  };

  services = {
    libinput.enable = true;

    # Thunar
    gvfs.enable = true; # Mount, trash, etc
    tumbler.enable = true; # Thumbnails

    # Bluetooth manager
    blueman = {
      enable = true;
    };

    # Display manager
    greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
          user = "greeter";
        };
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
