{ pkgs, lib, config, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };

  # Clone the personal neovim config on first activation; leave it alone after
  # so day-to-day edits and lazy.nvim installs are not clobbered.
  home.activation.cloneNeovimConfig =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      NVIM_DIR="${config.home.homeDirectory}/.config/nvim"
      if [ ! -d "$NVIM_DIR/.git" ]; then
        run mkdir -p "${config.home.homeDirectory}/.config"
        run ${pkgs.git}/bin/git clone \
          https://github.com/Kratosgado/neovim-config.git "$NVIM_DIR"
      fi
    '';
}
