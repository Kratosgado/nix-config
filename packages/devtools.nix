{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    trunk
    kotlin
    (inputs.rustowl-flake.packages.${pkgs.system}.rustowl)
    lua51Packages.luarocks
    jdk
    # jdk17
    flutter
    gradle
    maven
    liquibase
    ktor-cli
    dbus
    gobject-introspection
    sqlite
    # dbus-glib
    # rustc
    # cargo
    rustup
    # stylua
    # libsoup_3

    # C++ toolchain
    nasm
    qemu
    gcc
    # tree-sitter
    cmake
    pkg-config
    ninja
    clang-tools
    gnumake
    libgcc
    # opencv4

    # kulala-fmt
    # webkitgtk_4_0
    # gtk3
    # gtk4

    python311
    fzf
    skim
    websocat
    jq
    openssh
    openssl
    # pnpm
    nodejs
    # deno
    # yarn
    corepack

    neofetch

    # for viewing binary files
    hex
    hexedit
    hextazy

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    jdt-language-server
    prisma-engines
    prisma
    lombok

    nnn
    stc-cli # sync files between computers
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    tmux
    ripgrep
    fd
    bat
    pass
    zoxide
    devbox

    # shells / terminals / editors
    lazygit
    lazydocker
    wl-clipboard
    xclip
    delta
    hurl
    pipx
    pre-commit

    # git tooling
    gh
    git-town
    git

    # runtimes
    bun
    pnpm

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses
    gnupg
    glow # markdown previewer in terminal
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

}
