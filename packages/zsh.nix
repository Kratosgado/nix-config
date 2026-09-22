{ pkgs, ... }: {

  home.packages = with pkgs; [ pay-respects ];
  programs = {
    # starship - an customizable prompt for any shell
    starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      dotDir = "/home/kratosgado/.config/zsh";

      shellAliases = {
        hms = "home-manager switch";
        v = "nvim";
        vi = "nvim";
        c = "clear";
        cat = "bat --theme='Catppuccin Mocha'";
        fk = "pay-respects";
        pn = "pnpm";
        px = "pnpx";
        ls =
          "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
        s = "web_search duckduckgo";

        l = "ls -alh";
        ll = "ls -alF";
        la = "ls -A";

        # NixOS management (paths point at ~/projects/configs/nix-config)
        upgrade =
          "sudo nix flake update --flake ~/projects/configs/nix-config && update";
        update =
          "sudo nixos-rebuild switch --flake ~/projects/configs/nix-config";
        syncconfig =
          "sudo rsync -avh --delete --exclude .git ~/projects/configs/nix-config/ /etc/nixos/";
        switch =
          "syncconfig && sudo nixos-rebuild switch && sudo cp /etc/nixos/flake.lock ~/projects/configs/nix-config/flake.lock";
        iswitch =
          "syncconfig && sudo nixos-rebuild switch --impure && sudo cp /etc/nixos/flake.lock ~/projects/configs/nix-config/flake.lock";
        editconfig =
          "cd ~/projects/configs/nix-config/ && nvim ~/projects/configs/nix-config";
        editvim = "cd ~/.config/nvim/ && nvim ~/.config/nvim";
        editkitty = "cd ~/.config/kitty/ && nvim ~/.config/kitty";
        vaults = "cd ~/vaults/ && nvim ~/vaults";
        zshconfig = "nvim ~/.zshrc";

        # git aliases
        gc = "git add . && git commit -m";
        gs = "git status";
        go = "git checkout";
        gb = "git branch";
        push = "git push";
        gt = "git-town";
        gsw = "git-town switch";
        gtc = "git-town continue";
        gts = "git-town sync";
        gtsa = "git-town sync -a";
        gtbcreate = "git-town append";
        gtb = "git-town branch";

        # docker aliases
        dup = "docker compose up -d";
        dps = "docker ps";
        dreset = "docker compose down -v && docker compose up -d";
        ddown = "docker compose down";
        ddvol = "docker compose down -v";
        dstop = "docker compose stop";
        dstart = "docker compose start";
        dlogs = "docker compose logs -f";

        # Maven aliases
        mvnc = "mvn clean compile";
        mvnv = "mvn clean verify";
        mvnspring = "mvn clean spring-boot:run";
        mvntest = "mvn clean test";
        mvncheckstyle = "mvn clean checkstyle:check";

        # Gradle aliases
        gradlec = "./gradlew clean";
        gradled = "./gradlew build";
        gradlet = "./gradlew test";
        gradlebootrun = "./gradlew bootRun";
        gradlerun = "./gradlew run";
        gradlecheck = "./gradlew check";
        gradledgs = "./gradlew generateJava";

        # Rust aliases
        cr = "cargo run";
        cb = "cargo build";
        ct = "cargo test";
        cc = "cargo check";
        ccp = "cargo clippy";
        cf = "cargo fmt";
      };
      oh-my-zsh = {
        enable = true;
        extraConfig = builtins.readFile ./extraConfig.zsh;
        plugins = [
          "git"
          "aws"
          "docker"
          "kubectl"
          "fzf"
          "web-search"
          "copyfile"
          "copybuffer"
        ];
      };

      sessionVariables = {
        OPENCODE_CONFIG_DIR = "$HOME/.config/nvim/opencode";
        SKIP = "conventional-pre-commit";
        CARGO_TARGET_DIR = "$HOME/.cache/cargo";
        PAGER = "cat";
        BUN_INSTALL = "$HOME/.bun";
        PNPM_HOME = "$HOME/.local/share/pnpm";
        SDKMAN_DIR = "$HOME/.sdkman";
      };

      initContent = ''
        [[ ! -f ~/.config/home-manager/.p10k.zsh ]] || source ~/.config/home-manager/.p10k.zsh

        # PATH additions (Android SDK, cargo, bun,  local bins)
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.cargo/bin:$PATH"
        export PATH="$HOME/.pub-cache/bin:$PATH"
        export PATH="$HOME/.caa/bin:$PATH"
        export PATH="$HOME/.opencode/bin:$PATH"
        export PATH="$BUN_INSTALL/bin:$PATH"

        export PATH="$PATH:$ANDROID_HOME/tools"
        export PATH="$PATH:$ANDROID_HOME/platform-tools"
        export PATH="$PATH:$ANDROID_HOME/emulator"
        export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac

        # Prefer vim over nvim on remote SSH sessions
        if [[ -n $SSH_CONNECTION ]]; then
          export EDITOR='vim'
        else
          export EDITOR='nvim'
        fi

        # git-town completions
        if command -v git-town >/dev/null 2>&1; then
          source <(git-town completions zsh)
        fi

        # Angular CLI completions
        if command -v ng >/dev/null 2>&1; then
          source <(ng completion script)
        fi

        # AWS CLI completer (snap)
        if [ -x /snap/aws-cli/current/bin/aws_completer ]; then
          autoload -Uz bashcompinit && bashcompinit
          complete -C '/snap/aws-cli/current/bin/aws_completer' aws
        fi

        # bun completions
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        # nvm (kept for parity with Ubuntu setup)
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        # Kiro shell integration
        if [[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1; then
          . "$(kiro --locate-shell-integration-path zsh)"
        fi

        # keep caa daemon running
        if command -v caa >/dev/null 2>&1 && [ -z "$(pidof caa)" ]; then
          caa -d
        fi

        # user-local secrets
        [ -f ~/.secrets ] && source ~/.secrets

        # SDKMAN (must stay near the end)
        [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
      '';
    };

    # Atuin
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        dialect = "us";
        style = "compact";
        inline_height = 15;
      };
    };
  };
}
