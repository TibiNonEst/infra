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
    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$browser" = "firefox";
      "$menu" = "fuzzel";
      "$file-manager" = "thunar";
      "$editor" = "zeditor";

      monitor = [
        "eDP-1, prefered, 0x0, 1"
        "DP-1, 2560x1440@144, 0x0, 1"
        "DP-2, prefered, 2560x0, 1"
      ];

      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 0;
      };

      decoration = {
        rounding = 10;
        dim_inactive = true;
      };

      input = {
        kb_model = "pc104";
        natural_scroll = true;

        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
          clickfinger_behavior = true;
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod, D, exec, $menu"
        "$mod SHIFT, D , exec, mullvad-exclude $menu"
        "$mod, T, exec, $file-manager"
        "$mod, E, exec, $editor"
        "$mod, B, exec, $browser"
        "$mod SHIFT, B, exec, $browser --private-window"
        "$mod SHIFT, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, F, fullscreen"
        "$mod, W, togglefloating"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod SHIFT, N, exec, swaync-client -t -sw"
        ''$mod, PRINT, exec, hyprshot -m region --freeze -r -- | satty --filename - --fullscreen --output-filename "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"''
        "$mod, C, exec, hyprpicker | wl-copy"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      # Requires avizo
      bindel = [
        ",XF86AudioRaiseVolume, exec, volumectl -u up"
        ",XF86AudioLowerVolume, exec, volumectl -u down"
        ",XF86AudioMute, exec, volumectl toggle-mute"
        ",XF86MonBrightnessUp, exec, lightctl up"
        ",XF86MonBrightnessDown, exec, lightctl down"
      ];

      # Requires playerctl
      bindl = [
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      exec-once = [
        "avizo-service &"
        "nm-applet &"
        "wayland-pipewire-idle-inhibit &"
        "wl-clip-persist --clipboard regular"
      ];

      windowrule = [
        "match:fullscreen on, idle_inhibit focus"
        "match:class firefox, match:title (Extension:.*), float on"
      ];
    };
  };
}
