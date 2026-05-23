{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.zfs;

  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  options.modules.zfs = with lib; {
    enable = mkEnableOption { description = "Enable ZFS"; };
    autoScrub = mkOption {
      type = types.bool;
      description = "Run ZFS scrubs automatically";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader.grub = lib.mkIf config.boot.loader.grub.enable {
        zfsSupport = true;
      };
      kernelPackages = latestKernelPackage;
      zfs.forceImportRoot = false;
    };

    services = {
      zfs.autoScrub.enable = cfg.autoScrub;
    };
  };
}
