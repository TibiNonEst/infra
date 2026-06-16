{
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
{
  imports = with inputs; [
    catppuccin.nixosModules.catppuccin
    home-manager.nixosModules.home-manager
    ragenix.nixosModules.default
  ];

  ### Catppuccin-ify everything
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "macchiato";
  };

  ### Common Nix settings
  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "recursive-nix"
      ];
      system-features = [ "recursive-nix" ];
      trusted-users = [ "violet" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = with inputs; [
      outputs.overlays.packages

      nur.overlays.default
      rust-overlay.overlays.default
    ];
  };

  environment.etc = {
    "nixos".source = "/home/violet/infra";
  };

  ### System meta
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  ### Common packages
  environment.systemPackages = with pkgs; [
    dmidecode
    fastfetch
    inetutils
    iperf3
    ldns # drill
    lm_sensors
    lshw
    pciutils # lspci
    unzip
    usbutils # lsusb
    util-linux # lsblk
    wget
    zip
  ];

  ### Modules
  modules = {
    blocky.enable = lib.mkDefault true;
    chrony.enable = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
  };

  ### Common programs
  programs = {
    fish.enable = true;
    htop.enable = true;
    mtr.enable = true;
    nix-ld.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    nh = {
      enable = true;
      flake = "/home/violet/infra"; # This doesn't seem to show up as `NH_FLAKE`, maybe a fish problem?
      clean = {
        enable = true;
      };
    };
  };

  ### Common services
  services = {
    fwupd.enable = true; # Firmware updater
  };

  ### Networking
  networking = {
    domain = "violet.sh";
    useDHCP = lib.mkDefault false;
    dhcpcd.enable = lib.mkDefault false;
    firewall.enable = true;
    nftables.enable = true;
    search = [ "as215207.net" ];
  };

  ### Users
  users.users.violet = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ"
    ];
  };

  ### Add local bin to PATH
  environment.localBinInPath = true;

  ### Setup ragenix
  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Load ssh key from age file for home-manager
    secrets.ragenix_key = {
      file = ../../secrets/ragenix_key.age;
      owner = "violet";
      group = "users";
    };
  };
}
