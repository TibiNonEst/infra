{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpicker
    hyprshot
    hyprsysteminfo
    playerctl
    satty
    wayland-pipewire-idle-inhibit
    wl-clipboard-rs
    wl-clip-persist
  ];

  programs = {
    fuzzel.enable = true;

    hyprlock = {
      enable = true;
      settings = {
        auth = {
          "fingerprint:enabled" = true;
        };
      };
    };
  };

  services = {
    avizo.enable = true;
    network-manager-applet.enable = true;
    swaync.enable = true;

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = [
            "${pkgs.playerctl}/bin/playerctl pause"
            "${pkgs.hyprlock}/bin/hyprlock"
          ];
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };

    hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";
        preload = "~/Pictures/wallpapers/arcanepigeon/mushroom.png";
        wallpaper = [
          {
            monitor = "";
            path = "~/Pictures/wallpapers/arcanepigeon/mushroom.png";
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
