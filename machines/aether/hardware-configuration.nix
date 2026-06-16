{
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "ahci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/60ac21c5-08af-4508-b01a-1c4a420eac40";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B396-C22A";
    fsType = "vfat";
    options = [
      "dmask=0077"
      "fmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/d7e07d52-fa7a-494c-b841-249c73ea7751"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
