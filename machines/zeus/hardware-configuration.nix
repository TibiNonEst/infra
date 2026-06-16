{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zroot/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/home";
    fsType = "zfs";
  };

  fileSystems."/home/violet/.local/share/PrismLauncher/instances" = {
    device = "zroot/prism";
    fsType = "zfs";
  };

  fileSystems."/home/violet/.local/share/Steam/steamapps" = {
    device = "zroot/steam";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/ADC0-82D2";
    fsType = "vfat";
    options = [
      "dmask=0077"
      "fmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/46cf26b0-87fb-4060-9abc-e7e175a3b4a1"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
