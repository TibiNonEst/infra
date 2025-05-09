{ config, lib, ... }:
let
  cfg = config.modules.podman;
in
{
  options.modules.podman = with lib; {
    enable = mkEnableOption { description = "Enable Podman"; };
    autoPrune = mkOption {
      type = types.bool;
      description = "Automatically prune unused resources?";
      default = true;
    };
    containers = mkOption {
      type =
        with types;
        attrsOf (submodule {
          options = {
            image = mkOption {
              type = str;
              description = "The image of your container";
            };
            ports = mkOption {
              type = listOf str;
              description = "The ports your container has bound";
              default = [ ];
            };
            volumes = mkOption {
              type = listOf str;
              description = "The volumes your container has bound";
              default = [ ];
            };
          };
        });
      description = "Container configurations";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.containers.enable = true;

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;

      autoPrune.enable = cfg.autoPrune;
    };

    virtualisation.oci-containers.containers = cfg.containers;
  };
}
