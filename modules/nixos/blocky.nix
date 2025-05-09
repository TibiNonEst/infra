{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.blocky;
in
{
  options.modules.blocky = with lib; {
    enable = mkEnableOption { description = "Enable Blocky"; };
    updateDns = mkOption {
      type = types.bool;
      description = "Update machine local DNS";
      default = true;
    };
    upstreams = mkOption {
      type = with types; listOf str;
      description = "List of upstreams for Blocky";
      default = [
        "https://ordns.he.net/dns-query"
        "https://dns10.quad9.net/dns-query"
        "https://cloudflare-dns.com/dns-query"
        "https://dns.mullvad.net/dns-query"
        "https://freedns.controld.com/p0"
        "https://unfiltered.adguard-dns.com/dns-query"
      ];
    };
    allowlists = mkOption {
      type = with types; listOf str;
      description = "List of allowlists for Blocky";
      default = [
        ''${pkgs.writeText "allowlist.txt" ''
          *.deno.dev
        ''}''
      ];
    };
    denylists = mkOption {
      type = with types; listOf str;
      description = "List of denylists for Blocky";
      default = [
        "https://cdn.jsdelivr.net/gh/StevenBlack/hosts@master/alternates/fakenews/hosts"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/dyndns.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/hoster.txt"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking = lib.mkIf cfg.updateDns {
      networkmanager.dns = "none";
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
    };

    services.blocky = {
      enable = true;
      settings = {
        upstreams.groups.default = cfg.upstreams;
        bootstrapDns = [
          {
            upstream = "https://dns.quad9.net/dns-query";
            ips = [
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"
            ];
          }
        ];
        blocking = {
          allowlists = {
            default = cfg.allowlists;
          };
          denylists = {
            default = cfg.denylists;
          };
          clientGroupsBlock = {
            default = [ "default" ];
          };
        };
        caching.prefetching = true;
        customDNS.mapping = {
          "aether.wg" = "10.8.0.1";
          "zeus.wg" = "10.8.0.2";
          "hera.wg" = "10.8.0.3";
          "hermes.wg" = "10.8.0.4";
          "hestia.wg" = "10.8.0.5";
          "athena.wg" = "10.8.0.6";
          "zephyrus.wg" = "10.8.0.7";
          "dionysus.wg" = "10.8.0.8";
        };
      };
    };
  };
}
