{ pkgs, ... }: {
  home.packages = with pkgs; [
    # blender
    # godot
    # blendfarm
    pcsx2
    # firefox
    obs-studio
    insomnia

    gimp
    # android-studio-full
    android-studio
    jetbrains.idea-community
    discord
    google-chrome
    brave
    obsidian
    vlc
    vdhcoapp
    yt-dlp
    libreoffice
    docker
    dbeaver-bin
    telegram-desktop
    zapzap
    kitty
    imagemagick
    claude-code
    postgresql # for dadbod
  ];
}
