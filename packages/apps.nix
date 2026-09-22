{ pkgs, ... }: {
  home.packages = with pkgs; [
    obs-studio
    brave
    obsidian
    vlc
    libreoffice
    docker
    dbgate
    telegram-desktop
    kitty
    imagemagick
    postgresql # for dadbod
  ];
}
