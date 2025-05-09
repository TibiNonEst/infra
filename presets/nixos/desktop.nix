{ inputs, pkgs, ... }:
{
  imports = [ ./hyprland.nix ];

  hardware.graphics.enable = true;

  catppuccin.enable = true;

  programs = {
    dconf.enable = true;
    fish.enable = true;
    steam.enable = true;

    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    printing.enable = true; # Cups
    pcscd.enable = true; # Smart card (Yubikey) daemon

    # Sound
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Mullvad VPN
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn; # Use GUI instead of CLI
    };

    udev.packages = [ pkgs.yubikey-personalization ];
  };

  environment.systemPackages = with inputs; [
    deploy-rs.packages.x86_64-linux.deploy-rs
    ragenix.packages.x86_64-linux.default
  ];

  users.users.tibs = {
    extraGroups = [ "video" ];
  };

  # Fonts
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    liberation_ttf
    fira-code
    fira-go
  ];

  # Open up firewall
  networking.firewall = {
    allowedTCPPorts = [
      8081 # Expo
      36000 # Simplex
    ];
  };

  security.polkit.enable = true;

  # Allow home-manager to manage xdg portals
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
