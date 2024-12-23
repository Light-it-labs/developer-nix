{
  description = "Light-it's nix-darwin system flake";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.neovim  
          pkgs.git
          pkgs.curl
        ];

      nixpkgs.config = {
        allowUnfree = true;
      };
      
      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Fingerprint sudo with Touch ID.
      security.pam.enableSudoTouchIdAuth = true;

      # ZSH
      programs.zsh.enableSyntaxHighlighting = true;
      # programs.zsh.enableFastSyntaxHighlighting = true;
      programs.zsh.enableFzfCompletion = true;
      programs.zsh.enableFzfHistory = true;
      programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

      environment.shellAliases = {
	ll = "ls -l";
      };

      # Fonts
      fonts.packages = with pkgs; [
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
      ];

      # Homebrew
      homebrew.enable = true;
      homebrew.casks = [
	      "visual-studio-code"
        "iterm2"
        "alacritty"
        "slack"
        "docker"
        "postman"
        "1password"
        "slite"
        "jetbrains-toolbox"
        "phpstorm"  
        
        "google-chrome"
        "alfred"
        "maccy"
      ];

      homebrew.brews = [
        "awscli"
        "fzf"
        "mas"
        "terraform"
        "nvm"
        "gh"
      ];

      system.defaults.dock.persistent-apps = [
        "/Applications/Slack.app/"
        "/Applications/Alacritty.app/"
        "/Applications/Visual Studio Code.app/"
        "/Applications/PhpStorm.app/"
        "/Applications/Google Chrome.app/"
        "/Applications/1Password.app/"
      ];

  };  
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Juans-MacBook-Air
    darwinConfigurations.Juans-MacBook-Air = nix-darwin.lib.darwinSystem {
      modules = [ 
   	configuration
     ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.simple.pkgs;
  };
}
