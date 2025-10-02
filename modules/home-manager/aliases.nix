{ ... }:
{
  config = {
    home.shellAliases = {
      dream = "echo 'Sweet dreams...'; rm -f $HOME/.local/state/no-suspend";
      hms = "/home/m3l6h/.local/bin/home-manager-wrapper";
      icat = "kitten icat";
      insomnia = "echo 'Having nightmares...'; touch $HOME/.local/state/no-suspend";
      maxvol = "pactl set-sink-volume @DEFAULT_SINK@ 100%";
      mntimp = "sudo mkdir /mnt >/dev/null 2>&1; sudo mount -o subvol=/ /dev/mapper/root /mnt";
      nix-shell = "nix-shell --run \"$SHELL\"";
      nxs = "/home/m3l6h/.local/bin/nix-rebuild-wrapper";
      tsrc = "tmux source /home/m3l6h/.config/tmux/tmux.conf";
    };
  };
}
