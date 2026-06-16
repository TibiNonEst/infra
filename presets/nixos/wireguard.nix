{ config, ... }:
{
  age.secrets = {
    wgautomesh_gossip_secret.file = ../../secrets/wgautomesh_gossip_secret.age;
    # zeus_wg0_preshared_key.file = ../../secrets/zeus_wg0_preshared_key.age;
    # hera_wg0_preshared_key.file = ../../secrets/hera_wg0_preshared_key.age;
    # hermes_wg0_preshared_key.file = ../../secrets/hermes_wg0_preshared_key.age;
    # hestia_wg0_preshared_key.file = ../../secrets/hestia_wg0_preshared_key.age;
    # athena_wg0_preshared_key.file = ../../secrets/athena_wg0_preshared_key.age;
    # zephyrus_wg0_preshared_key.file = ../../secrets/zephyrus_wg0_preshared_key.age;
    # dionysus_wg0_preshared_key.file = ../../secrets/dionysus_wg0_preshared_key.age;
  };

  modules.wireguard = {
    mesh = {
      enable = true;
      gossipSecretFile = config.age.secrets.wgautomesh_gossip_secret.path;
    };

    peers = [
      {
        name = "aether";
        publicKey = "uQKOe+7uF8Jm+98Uc64sEWJpuLpGH/BykXYySHkW6jg=";
        # presharedKeyFile = config.age.secrets.zeus_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.0/16"
          "fd47:4161:82f9::/64"
        ];
        endpoint = "162.120.71.136:51820";
        # endpoint = "5.161.106.226:28183";
        persistentKeepalive = 25;
      }
      {
        name = "zeus";
        publicKey = "6ZEA+gRxXflZWLOHy8epyKCBAunwuwt9SU6R5Nbvbys=";
        allowedIPs = [
          "10.8.0.2/32"
          "fd47:4161:82f9::2/128"
        ];
        mesh = {
          # enable = true;
          ip = "10.8.0.2";
        };
      }
      {
        name = "hera";
        publicKey = "KILRF/mGDBpf7xOWJg+vsewIoIFsiEXsHoB8MJsK3T8=";
        allowedIPs = [
          "10.8.0.3/32"
          "fd47:4161:82f9::3/128"
        ];
        mesh = {
          # enable = true;
          ip = "10.8.0.3";
        };
      }
      {
        name = "hermes";
        publicKey = "DFHeIKM03pv3mlDefk7HgIpyJN4ZeYJcTjfaYIPM6gU=";
        allowedIPs = [
          "10.8.0.4/32"
          "fd47:4161:82f9::4/128"
        ];
      }
      {
        name = "hestia";
        publicKey = "NW41EykKyE1oJRHBhSh0OeqH6IKpEPAwrHVV6SByJ1A=";
        allowedIPs = [
          "10.8.0.5/32"
          "fd47:4161:82f9::5/128"
        ];
        mesh = {
          # enable = true;
          ip = "10.8.0.5";
        };
      }
      # {
      #   name = "athena";
      #   publicKey = "<pubkey>";
      #   allowedIPs = [
      #     "10.8.0.6/32"
      #     "fd47:4161:82f9::6/128"
      #   ];
      #   mesh = {
      #     enable = true;
      #     ip = "10.8.0.6";
      #   };
      # }
      # {
      #   name = "zephyrus";
      #   publicKey = "<pubkey>";
      #   allowedIPs = [
      #     "10.8.0.7/32"
      #     "fd47:4161:82f9::7/128"
      #   ];
      #   mesh = {
      #     enable = true;
      #     ip = "10.8.0.7";
      #   };
      # }
      {
        name = "dionysus";
        publicKey = "tDfcWasj6SBCG+tFGl0UTZT0ZTiP5i+lCeN8o0Svtg4=";
        allowedIPs = [
          "10.8.0.8/32"
          "fd47:4161:82f9::8/128"
        ];
      }
      {
        name = "boreas";
        publicKey = "pSNmGicWbgR1YnxUP/cU7LWSRXU2WYUP7jzFs624kws=";
        allowedIPs = [
          "10.8.0.9/32"
          "fd47:4161:82f9::9/128"
        ];
      }
    ];
  };
}
