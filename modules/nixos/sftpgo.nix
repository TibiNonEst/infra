{ config, lib, ... }:
let
  cfg = config.modules.sftpgo;
in
{
  options.modules.sftpgo = with lib; {
    enable = mkEnableOption { description = "Enable SFTPgo"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    sftp_port = mkOption { type = types.port; };
  };

  config = lib.mkIf cfg.enable {
    services.sftpgo = {
      enable = true;
      settings = {
        httpd.bindings = [
          {
            port = 8000;
          }
        ];
        sftpd.bindings = [
          {
            port = 2122;
          }
        ];
      };
    };

    modules.caddy.services.sftpgo = {
      hostname = cfg.hostname;
      port = cfg.port;
    };
  };
}
