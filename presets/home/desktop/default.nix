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
      aseprite
      bitwarden-desktop
      coppwr
      drawio
      foliate
      gimp
      handbrake
      helvum
      keepassxc
      kdePackages.filelight
      musescore
      newsflash
      prismlauncher
      pwvucontrol
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
      zoom-us

      # Jetbrains
      jetbrains.clion
      jetbrains.datagrip
      jetbrains.goland
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.rider
      jetbrains.rust-rover
      jetbrains.webstorm

      # OBS
      obs-studio
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-webkitgtk
      obs-studio-plugins.obs-pipewire-audio-capture

      # Misc
      networkmanagerapplet
    ];

    sessionVariables = {
      SSH_AUTH_SOCK = "/home/tibs/.bitwarden-ssh-agent.sock";
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

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        # ardenivanov.svelte-intellisense
        astro-build.astro-vscode
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
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
        ms-vscode.cpptools
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
