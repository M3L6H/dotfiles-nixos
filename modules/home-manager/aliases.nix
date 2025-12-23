{ hostname, username, ... }:
{
  config = {
    home.shellAliases = {
      dream = "echo 'Sweet dreams...'; rm -f $HOME/.local/state/no-suspend";
      hms = "/home/${username}/.local/bin/home-manager-wrapper /etc/nixos#${hostname}-${username}";
      icat = "kitten icat";
      insomnia = "echo 'Having nightmares...'; touch $HOME/.local/state/no-suspend";
      maxvol = "pactl set-sink-volume @DEFAULT_SINK@ 100%";
      mntimp = "sudo mkdir /mnt >/dev/null 2>&1; sudo mount -o subvol=/ /dev/mapper/root /mnt";
      nix-shell = "nix-shell --run \"$SHELL\"";
      nxs = "/home/${username}/.local/bin/nix-rebuild-wrapper /etc/nixos#${hostname}";
      tsrc = "tmux source /home/${username}/.config/tmux/tmux.conf";
    };
  };
}
