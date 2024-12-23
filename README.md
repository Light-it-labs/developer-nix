# NIX Configuration for developers

## Install

Firstly, lets install Nix:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

Then we have to install Nix Darwin, this is the nix tool that we will be using to configure our machine:
```bash
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
nix flake init -t nix-darwin
rm flake.nix
wget https://raw.githubusercontent.com/Light-it-labs/developer-nix/refs/heads/main/flake.nix
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```
To run it for the first time use:
```bash
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```
## Rebuilding

To update the mac once the configuration file is changed, you can run:
```bash
darwin-rebuild switch --flake ~/.config/nix-darwin
```
