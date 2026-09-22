{ pkgs, lib, user, ... }:
let clibraries = with pkgs; [ xorg.libX11 stdenv.cc.cc.lib zlib ];
in {
  imports = [ ./vscode ./packages ];
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };

    #   "org/gnome/desktop/interface" = {
    #     font-name = "JetBrainsMono Nerd Font 12";
    # document-font-name = "JetBrainsMono Nerd Font 12";
    #     monospace-font-name = "JetBrainsMono Nerd Font Mono 12";
    #   };
    #   "org/gnome/terminal/legacy/profiles:/:<profile-id>" = {
    #     font = "JetBrainsMono Nerd Font Mono 12";
    #     use-system-font = false;
    #   };

    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/${user}/Pictures/wallpaper.jpg";
      picture-uri-dark = "file:///home/${user}/Pictures/wallpaper.jpg";
    };
  };
  home = {
    username = user;
    homeDirectory = "/home/${user}";

    stateVersion = "24.11";
    packages = with pkgs; [
      gnomeExtensions.dash-to-dock
      gnomeExtensions.hide-top-bar
      gnome-tweaks
      gnomeExtensions.gsconnect
      gnomeExtensions.clipboard-history
      gnomeExtensions.user-themes
      andromeda-gtk-theme

      xclip
      jetbrains-mono
    ];

    file = {
      "Pictures/wallpaper.jpg" = { source = ./files/wallpaper.jpg; };
      "Pictures/${user}.png" = { source = ./files/kratosgado.png; };
      ".npmrc".text = "prefix=$HOME/.npm-packages";
      ".config/kitty/kitty.conf" = { source = ./files/kitty.conf; };
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISIUAL = "nvim";
      FZF_CTRL_T_OPTS =
        "--preview 'bat -n --color=always --theme='Catppuccin Mocha' --line-range :500 {}'";
      FZF_ALT_C_OPTS = "--preview 'eza --tree --color=always {} | head -200'";
      LD_LIBRARY_PATH = "${lib.makeLibraryPath clibraries}";
      LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
      PKG_CONFIG_PATH =
        "${pkgs.opencv4}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.libxml2.dev}/lib/pkgconfig";
      NPM_CONFIG_PREFIX = "$HOME/.npm-packages";
      PNPM_HOME = "$HOME/.pnpm-home";
      PATH = "/home/${user}/.npm-packages/bin:$HOME/.pnpm-home:$PATH";
      NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
      JAVA_HOME = "${pkgs.jdk}";
      ANDROID_HOME = "$HOME/Android/Sdk";
      GRADLE_USER_HOME = "$HOME/.gradle";
      CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
      NIXPKGS_ALLOW_UNFREE = 1;
      NIXPKGS_ALLOW_UNFREE_PREDICATE = 1;
      NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = 1;
      # This forces kotlin-language-server to use the correct JDK
      KOTLIN_LANGUAGE_SERVER_JAVA_HOME = "${pkgs.jdk}";

      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_QUERY_ENGINE_LIBRARY =
        "${pkgs.prisma-engines}/lib/libquery_engine.node";
      PRISMA_INTROSPECTION_ENGINE_BINARY =
        "${pkgs.prisma-engines}/bin/introspection-engine";
      PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
    };
  };
  fonts.fontconfig.enable = true;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    network-manager-applet.enable = true;
  };
  # nixpkgs.config = {
  #   allowBroken = true;
  #   allowUnfree = true;
  #   allowUnfreePredicate = true;
  # };
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        user.name = "Kratosgado";
        user.email = "mbeahessilfieprince@gmail.com";
        push = { autoSetupRemote = true; };
        credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
      };
    };
    tmux = {
      enable = true;
      plugins = [ pkgs.tmuxPlugins.vim-tmux-navigator ];
    };
  };
}
