{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.caddy;
in
{
  options.modules.caddy = with lib; {
    enable = mkEnableOption { description = "Enable Caddy"; };
    services = mkOption {
      type =
        with types;
        attrsOf (submodule {
          options = {
            hostname = mkOption {
              type = str;
              description = "The hostname of this virtual host";
            };
            serverAliases = mkOption {
              type = listOf str;
              description = "Additional hostnames for this virtual host to respond to";
              default = [ ];
            };
            address = mkOption {
              type = str;
              description = "The address of the service to reverse proxy";
              default = "127.0.0.1";
            };
            port = mkOption {
              type = port;
              description = "The port of the service to reverse proxy";
            };
            dnsProvider = mkOption {
              type = str;
              description = "The DNS provider to use for this virtual host (cloudflare | bunny)";
              default = "bunny";
            };
          };
        });
      description = "Service configurations for reverse proxy virtual hosts";
      default = [ ];
    };
    metrics = mkOption {
      type = types.bool;
      description = "Whether to enable metrics on Caddy";
      default = false;
    };
    configFile = mkOption {
      type = with types; nullOr path;
      description = "Path to Caddyfile";
      default = null;
    };
    snippets = mkOption {
      type = with types; listOf str;
      default = [
        ''
          (global) {
            encode zstd gzip
          }
          (security) {
            header Content-Security-Policy "default-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
           	header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
           	header X-Content-Type-Options nosniff
           	header X-XSS-Protection "1; mode=block"
           	header X-Frame-Options DENY
           	header Referrer-Policy no-referrer
           	header Permissions-Policy interest-cohort=()
           	header Cross-Origin-Embedder-Policy require-corp
           	header Cross-Origin-Opener-Policy same-origin
           	header Cross-Origin-Resource-Policy same-origin
          }
          (branding) {
           	header Server Aether
           	header X-Clacks-Overhead "GNU Jabari Latrell Peoples, Cecile Richards, Nikki Giovanni, Alexei Navalny, Nex Benedict, Andre Braugher, Corei Hall, Ryan Carson, Harry Belafonte, Brianna Ghey, Technoblade, Alice Litman, Axel Matters, John Lewis, Larry Kramer, George Floyd, Toni Morrison, Aretha Franklin, Avicii, Stephen Hawking, Ursula K. Le Guin, Ben Barres, Natalie Nguyen, Debbie Reynolds, Carrie Fisher, Grace Lee Boggs, Terry Pratchett, Eric Garner, Ruby Dee, Maya Angelou, Pete Seeger, Elizabeth Catlett, Trayvon Martin, Denis Ritchie, Miki Endo, Esther Earl, Lena Horne, Dorothy Height, Eartha Kitt, Katherine Dunham, Octavia E. Butler, Coretta Scott King, Rosa Parks, Shirley Chisholm, Ginny Fiennes, Nina Simone, Sylvia Rivera, Douglas Adams, James Farmer, Matthew Shepard, John Denver, Ella Fitzgerald, Jonathan Larson, Cesar Chavez, Audre Lorde, Marsha P. Johnson, Keith Haring, C. L. R. James, James Baldwin, E. D. Nixon, Roy Wilkins, Terry Fox, A. Philip Randolph, Harvey Milk, Phil Ochs, Whitney Young, Judy Garland, Martin Luther King Jr., Woody Guthrie, Langston Hughes, Malcolm X, Sam Cooke, W. E. B. Du Bois, Alan Turing, Alice Stone Blackwell, Carrie Chapman Catt, Jean Tatlock, Lillian Wald, Emma Goldman, Ida B. Wells, Mary Burnett Talbert, Frances Ellen Watkins Harper, Julia Ward Howe, Henry Browne Blackwell, Susan B. Anthony, Elizabeth Cady Stanton, Abigail Bush, Henry Box Brown, Frederick Douglass, Amelia Bloomer, Lucy Stone, Wendell Phillips, Sojourner Truth, Lucretia Mott, William Lloyd Garrison, Charles Sumner, Lindley Murray Moore, James Mott, Margaret Fuller, Abigail Mott, Mary Wollstonecraft"
          }
          (cdn) {
           	header Access-Control-Allow-Methods GET
           	header Access-Control-Allow-Origin *
           	header Cross-Origin-Resource-Policy cross-origin
          }
          (bunny) {
          	tls {
          		dns bunny {$BUNNY_API_KEY}
          	}
          }
          (cloudflare) {
          	tls {
          		dns cloudflare {$CLOUDFLARE_API_KEY}
          	}
          }
        ''
      ];
    };
    extraConfig = mkOption {
      type = types.lines;
      description = "Extra config to add to the created Caddyfile";
      default = "";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/bunny@v1.2.0"
          "github.com/caddy-dns/cloudflare@v0.2.4"
        ];
        hash = "sha256-F1ztAZoXudorziLFEPH154zqXW6AbaJT+DsG5NB61PQ=";
      };
      globalConfig = lib.mkIf cfg.metrics ''
        metrics {
          per_host
        }
      '';
      virtualHosts =
        let
          services = builtins.mapAttrs (name: value: {
            hostName = value.hostname;
            serverAliases = value.serverAliases;
            extraConfig = ''
              import global
              import branding
              import ${value.dnsProvider}
              reverse_proxy ${value.address}:${toString value.port}
            '';
          }) cfg.services;
        in
        services;
      configFile = lib.mkIf (cfg.configFile != null) cfg.configFile;
      extraConfig = cfg.extraConfig + lib.concatStrings cfg.snippets;
      environmentFile = config.age.secrets.caddy_env.path;
      logFormat = lib.mkForce "level INFO";
    };

    services.victoriametrics.prometheusConfig.scrape_configs = lib.mkIf cfg.metrics [
      {
        job_name = "caddy";
        static_configs = [
          { targets = [ "localhost:2019" ]; }
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];

    # Load in age secrets
    age.secrets = {
      # bunny_tls_api_key.file = ../../secrets/bunny_tls_api_key.age;
      # cloudflare_tls_api_key.file = ../../secrets/cloudflare_tls_api_key.age;
      caddy_env.file = ../../secrets/caddy_env.age;
    };
  };
}
