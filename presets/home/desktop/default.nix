{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./hyprland.nix
    ./waybar
  ];

  home = {
    packages = with pkgs; [
      # Browsers
      brave
      mullvad-browser
      tor-browser

      # Apps
      ardour
      aseprite
      bitwarden-desktop
      blender
      blockbench
      coppwr
      davinci-resolve
      drawio
      ente-auth
      ente-desktop
      foliate
      gimp
      handbrake
      image-roll
      keepassxc
      kdePackages.filelight
      musescore
      newsflash
      prismlauncher
      protonmail-desktop
      proton-vpn
      pwvucontrol
      signal-desktop
      simplex-chat-desktop
      slack
      sparrow-wifi
      spotify
      teams-for-linux
      transmission_4-qt
      vesktop
      video-trimmer
      vlc
      wavemon
      yaak
      zoom-us

      # Jetbrains
      android-studio
      jetbrains.clion
      jetbrains.datagrip
      jetbrains.goland
      jetbrains.idea
      jetbrains.pycharm
      jetbrains.rider
      jetbrains.rust-rover
      jetbrains.webstorm

      # LibreOffice
      libreoffice-qt
      hunspellDicts.en_US-large
      hyphenDicts.en_US

      # Misc
      networkmanagerapplet
    ];

    sessionVariables = {
      SSH_AUTH_SOCK = "/home/violet/.bitwarden-ssh-agent.sock";
    };
  };

  programs = {
    mangohud.enable = true;

    alacritty = {
      enable = true;
      settings.window.padding = {
        x = 5;
        y = 5;
      };
    };

    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };

    ghostty = {
      enable = true;
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };

    vscodium = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        # ardenivanov.svelte-intellisense
        astro-build.astro-vscode
        christian-kohler.path-intellisense
        codezombiech.gitignore
        davidlday.languagetool-linter
        dbaeumer.vscode-eslint
        denoland.vscode-deno
        eamodio.gitlens
        elixir-lsp.vscode-elixir-ls
        esbenp.prettier-vscode
        github.vscode-github-actions
        gleam.gleam
        golang.go
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        ms-python.debugpy
        ms-python.python
        ms-toolsai.jupyter
        # ms-vscode.cpptools
        ms-vscode.cmake-tools
        # oscarotero.vento-syntax
        rust-lang.rust-analyzer
        # slevesque.shader
        svelte.svelte-vscode
        tamasfe.even-better-toml
        unifiedjs.vscode-mdx
        vadimcn.vscode-lldb
        vscjava.vscode-java-pack
        yzhang.markdown-all-in-one
      ];
    };

    zed-editor = {
      enable = true;
      userSettings = {
        disable_ai = true;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };
      extensions = [
        "amber"
        "angular"
        "ansible"
        "assembly"
        "astro"
        "caddyfile"
        "cargo-tom"
        "csharp"
        "csv"
        "d"
        "dart"
        "deno"
        "desktop"
        "dockerfile"
        "docker-compose"
        "elixir"
        "erlang"
        "fish"
        "fortran"
        "git-firefly"
        "gleam"
        "glsl"
        "graphql"
        "groovy"
        "helm"
        "html"
        "ini"
        "java"
        "julia"
        "just"
        "kotlin"
        "latex"
        "liquid"
        "log"
        "lua"
        "make"
        "markdown-oxide"
        "matlab"
        "nginx"
        "nim"
        "nix"
        "ocaml"
        "perl"
        "php"
        "pkl"
        "prolog"
        "proto"
        "r"
        "ruby"
        "scala"
        "scss"
        "sql"
        "svelte"
        "swift"
        "terraform"
        "toml"
        "twig"
        "vento"
        "vue"
        "xml"
        "zig"
      ];
    };
  };

  xdg = {
    mimeApps.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
