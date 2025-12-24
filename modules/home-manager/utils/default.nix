{ lib, ... }:
{
  imports = [
    ./bat.nix
    ./chafa.nix
    ./expect.nix
    ./ffmpeg.nix
    ./file.nix
    ./fzf.nix
    ./gh.nix
    ./ghostscript.nix
    ./mesa-demos.nix
    ./image-magick.nix
    ./iw.nix
    ./jq.nix
    ./killall.nix
    ./lsof.nix
    ./mermaid-cli.nix
    ./neovim-remote.nix
    ./parted.nix
    ./playerctl.nix
    ./ripgrep.nix
    ./socat.nix
    ./sqlite.nix
    ./tealdeer.nix
    ./tectonic.nix
    ./unp.nix
    ./vulkan.nix
    ./wget.nix
    ./wl-clipboard.nix
  ];

  utils.bat.enable = lib.mkDefault false;
  utils.chafa.enable = lib.mkDefault false;
  utils.expect.enable = lib.mkDefault false;
  utils.ffmpeg.enable = lib.mkDefault false;
  utils.file.enable = lib.mkDefault false;
  utils.fzf.enable = lib.mkDefault false;
  utils.gh.enable = lib.mkDefault false;
  utils.ghostscript.enable = lib.mkDefault false;
  utils.mesa-demos.enable = lib.mkDefault false;
  utils.image-magick.enable = lib.mkDefault false;
  utils.iw.enable = lib.mkDefault false;
  utils.jq.enable = lib.mkDefault false;
  utils.killall.enable = lib.mkDefault false;
  utils.lsof.enable = lib.mkDefault false;
  utils.mermaid-cli.enable = lib.mkDefault false;
  utils.nvr.enable = lib.mkDefault false;
  utils.parted.enable = lib.mkDefault false;
  utils.playerctl.enable = lib.mkDefault true;
  utils.ripgrep.enable = lib.mkDefault false;
  utils.socat.enable = lib.mkDefault false;
  utils.sqlite.enable = lib.mkDefault false;
  utils.tealdeer.enable = lib.mkDefault false;
  utils.tectonic.enable = lib.mkDefault false;
  utils.unp.enable = lib.mkDefault false;
  utils.vulkan.enable = lib.mkDefault false;
  utils.wget.enable = lib.mkDefault false;
  utils.wl-clipboard.enable = lib.mkDefault false;
}
