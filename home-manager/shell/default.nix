{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      size = 1000;
      save = 1000;
    };

    shellAliases = {
      hms  = "home-manager switch --flake /home/cyprien/nix -b backup";
      hmn  = "home-manager news --flake /home/cyprien/nix";
      ls   = "ls --color=auto";
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      ssh  = "TERM=xterm-256color ssh";
      llm  = "llm -m claude-4-opus -s 'You are currently run in a zsh terminal with a very small text display. Do not exceed 500 characters. If I ask you to give me a command, you HAVE to cut out unnecessary text, summaries, comments. Go straight to the point, do not give additional information, cut the fluff.'";
    };

    initContent = ''
      autoload -Uz promptinit
      promptinit
      prompt redhat

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[3~"   delete-char
      bindkey "^[3;5~"  delete-char
      bindkey '^[[3;5~' kill-word
      bindkey '\e[1~'   beginning-of-line
      bindkey '\e[H'    beginning-of-line
      bindkey '\eOH'    beginning-of-line
      bindkey '\e[4~'   end-of-line
      bindkey '\e[F'    end-of-line
      bindkey '\eOF'    end-of-line

      ex() {
        if [ -f "$1" ]; then
          case $1 in
            *.tar.bz2) tar xjf "$1"  ;;
            *.tar.gz)  tar xzf "$1"  ;;
            *.bz2)     bunzip2 "$1"  ;;
            *.rar)     unrar x "$1"  ;;
            *.gz)      gunzip "$1"   ;;
            *.tar)     tar xf "$1"   ;;
            *.tbz2)    tar xjf "$1"  ;;
            *.tgz)     tar xzf "$1"  ;;
            *.zip)     unzip "$1"    ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1"    ;;
            *.deb)     ar x "$1"    ;;
            *.tar.xz)  tar xf "$1"  ;;
            *.tar.zst) unzstd "$1"  ;;
            *) echo "'$1' cannot be extracted via ex()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Activate the persistent user Python venv
      [[ -f "$HOME/.venv/bin/activate" ]] && source "$HOME/.venv/bin/activate"
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nano";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
}
