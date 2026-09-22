{ pkgs, user, userDescription, hostName, ... }: {
  imports = [ ./hardware-configuration.nix ];

  system.activationScripts.script.text = ''
    cp /home/${user}/Pictures/${user}.png /var/lib/AccountsService/icons/${user}
    export PATH=$PATH:/home/${user}/.npm-packages/bin
    export CHROME_EXECUTABLE="${pkgs.google-chrome}/bin/google-chrome-stable"
  '';
  users.users.${user} = {
    isNormalUser = true;
    description = userDescription;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers" ];
  };
  programs = {
    nix-ld.enable = true;
    adb.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    dconf.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking
  networking = {
    hostName = hostName;
    # nftables = {
    #   enable = true;
    #   ruleset = ''
    #     table ip nat {
    #       chain PREROUTING {
    #         type nat hook prerouting priority dstnat; policy accept;
    #         iifname "ens3" tcp dport 80 dnat to 10.100.0.3:80
    #       }
    #     }
    #   '';
    # };
    # firewall = {
    #   enable = true;
    #   allowedTCPPorts = [80 433 9000];
    # };
    # nat = {
    #   enable = true;
    #   internalInterfaces = [ "ens3" ];
    #   externalInterface = "wg0";
    #   forwardPorts = [{
    #     sourcePort = 80;
    #     proto = "tcp";
    #     destination = "10.100.0.3:80";
    #   }];
    # };
    #
    # interfaces = {
    #   ens3.ipv6.addresses = [
    #     {
    #       address = "2a01:4f8:1c1b:16d0::1";
    #       prefixLength = 64;
    #     }
    #   ];
    # };
    # defaultGateway6 = {
    #   address = "fe80::1";
    #   interface = "ens3";
    # };
    #

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
  };
  # Set your time zone.
  time.timeZone = "Africa/Accra";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  services = {
    snap = { enable = true; };
    gnome.gnome-keyring.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    pulseaudio.enable = false;

    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # # List services that you want to enable:
    # ngrok = {
    #   enable = true;
    #   extraConfig = {};
    #   extraConfigFiles = [];
    #   tunnels = {};
    # };

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  security = {
    rtkit.enable = true;
    # acme.certs = {
    #   "kgopinion.freetcp.com".email = "essilfiembeah@gmail.com";
    # };
    # acme.acceptTerms = true;
  };
  environment = {
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    variables = {
      GTK_THEME = "Andromeda";
      GDM_THEME = "Andromeda";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    gnome.excludePackages = with pkgs; [
      epiphany # web browser
      simple-scan # document scanner
      totem # video player
      yelp # help viewer
      evince # document viewer
      # geary  # email client
      # gnome-calculator
      # gnome-contacts
      gnome-maps
      gnome-music
      # gnome-screenshot
      # gnome-connections
      # gnome-console
    ];
    systemPackages = with pkgs; [ nginx direnv home-manager nix-direnv ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    allowUnsupportedSystem = true;
    android_sdk.accept_license = true;
    # permittedInsecurePackages = [ "libsoup-2.74.3" ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 16;

  # enable docker
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}
