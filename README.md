# dotfiles-nixos

My personal nixos configuration.

## installation

The following provides an outline of the exact steps needed to install this system.

### boot media

Download [rufus](https://rufus.ie/en).

Download [the NixOS graphical ISO image](https://nixos.org/download).

Insert USB drive to create ISO on. ⚠️**IT WILL BE WIPED**⚠️

Open Rufus.

Select the USB under `Device`.

Select the NixOS ISO under `Boot selection`.

Click `START` to format the USB. ⚠️**THIS WILL DELETE _EVERYTHING_ ON THE USB**⚠️

Shutdown the computer when Rufus is finished.

### installer

Boot into NixOS installer (might have to press a button to boot into BIOS first, then select USB from boot options).

Select Plasma (or Gnome if preferred).

Connect to WIFI (or wired connection if available).

If prompted, select blowfish encryption for wallet & set a basic password.

Close the installer.

Open a terminal and run the following:

```sh
sudo su
nix-shell -p git
git clone https://github.com/m3l6h/dotfiles-nixos.git nixos
cd nixos
ls /dev/disk/by-id # Identify the disk to install NixOS on
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix --arg device '"/dev/disk/by-id/<disk from previous step>"'
cd ..
mkdir /mnt/etc
mv nixos /mnt/etc/
nixos-install --root /mnt --flake /mnt/etc/nixos#nixos
reboot
```

## [modules](modules)

Breakdown of the included modules.

### [home-manager](modules/home-manager) - Home Manager modules

- [games](/modules/home-manager/games) - Central module for all games
  - [minecraft](/modules/home-manager/games/minecraft.nix) - Installs minecraft via prismlauncher
    - games.minecraft.enable `boolean` - Enables the module
- [hyprland](modules/home-manager/hyprland) - Hyprland submodule
  - hyprland.enable `boolean` - Enables the module and its submodules
  - [eww](modules/home-manager/hyprland/eww) - Eww configuration and scripts
  - [rofi](modules/home-manager/hyprland/rofi) - Configures rofi
  - [binds](modules/home-manager/hyprland/binds.nix) - Sets hyprland keybinds
  - [eww](modules/home-manager/hyprland/eww.nix) - Configues eww
  - [hypridle](modules/home-manager/hyprland/hypridle.nix) - Configures hypridle
  - [hyprlock](modules/home-manager/hyprland/hyprlock.nix) - Configures hyprlock
  - [hyprshot](modules/home-manager/hyprland/hyprshot.nix) - Configures hyprshot
  - [layer-rules](modules/home-manager/hyprland/layer-rules.nix) - Configures layerrules
  - [monitors](modules/home-manager/hyprland/monitors.nix) - Configures monitors
  - [wallpaper](modules/home-manager/hyprland/wallpaper.nix) - Configures wallpapers
    - wallpaper.mpvpaper.enable `boolean` - Enable mpvpaper video wallpaper
    - wallpaper.swww.enable `boolean` - Enable swww image wallpaper
  - [workspaces](modules/home-manager/hyprland/workspaces.nix) - Configures workspaces
- [scripts](modules/home-manager/scripts) - Scripts submodule
  - [conditional-lock](modules/home-manager/scripts/conditional-lock.nix) - When called will lock the system as long as ~/.local/state/no-lock is not present
    - scripts.conditional-lock.enable `boolean` - Enables the module
  - [conditional-suspend](modules/home-manager/scripts/conditional-suspend.nix) - When called will suspend the system as long as ~/.local/state/no-suspend is not present
    - scripts.conditional-suspend.enable `boolean` - Enables the module
  - [fs-diff](modules/home-manager/scripts/fs-diff.nix) - Use to find files needing to be persisted
    - Will automatically be enabled if `neovim.enable` is true
  - [home-manager-wrapper](modules/home-manager/scripts/home-manager-wrapper.nix) - Wrapper around home-manager to suspend lock/sleep during switch
    - Always enabled
  - [nix-rebuild-wrapper](modules/home-manager/scripts/nix-rebuild-wrapper.nix) - Wrapper around nix rebuild to suspend lock/sleep during switch
    - Always enabled
  - [persist](modules/home-manager/scripts/persist.nix) - Util to persist files/directories
    - Will automatically be enabled if `neovim.enable` is true
  - [toggle-mute](modules/home-manager/scripts/toggle-mute.nix) - Util to toggle-mute in playerctl
    - Will automatically be enabled if `utils.playerctl.enable` is true
  - [wallpaper-haven](modules/home-manager/scripts/wallpaper-haven.nix) - Sets a random wallpaper from wallpaper haven
    - scripts.wallpaper-haven.enable `boolean` - Enables the module
    - configure [api options](https://wallhaven.cc/help/api) with `~/.config/.wallhaven.ini`
- [services](modules/home-manager/services) - Systemd services submodule
  - [clip-mngr](modules/home-manager/services/clip-mngr.nix) - Systemd clipboard manager
    - services.clip-mngr.enable `boolean` - Enables the module
- [software](modules/home-manager/software) - Software submodule
  - [bazecor](modules/home-manager/software/bazecor.nix) - Graphical configurator for Dygma products
    - software.bazecor.enable `boolean` - Enables the module
  - [digikam](modules/home-manager/software/digikam) - Image management software
    - software.digikam.enable `boolean` - Enables the module
  - [firefox](modules/home-manager/software/firefox.nix) - Enables firefox browser
    - software.firefox.enable `boolean` - Enables the module
  - [krita](modules/home-manager/software/krita.nix) - Enables krita
    - software.krita.enable `boolean` - Enables the module
  - [obs](modules/home-manager/software/obs.nix) - Enables obs studio
    - software.obs.enable `boolean` - Enables the module
  - [vivaldi](modules/home-manager/software/vivaldi.nix) - Enables vivaldi browser
    - software.vivaldi.enable `boolean` - Enables the module
- [toolchains](modules/home-manager/toolchains) - Toolchains submodule
  - [c-cpp](modules/home-manager/toolchains/c-cpp.nix) - Install c/c++ toolchain
    - toolchains.c-cpp.enable `boolean` - Enables the module
  - [go](modules/home-manager/toolchains/go.nix) - Install go toolchain
    - toolchains.go.enable `boolean` - Enables the module
  - [markdown](modules/home-manager/toolchains/markdown.nix) - Install markdown toolchain
    - toolchains.markdown.enable `boolean` - Enables the module
  - [nix](modules/home-manager/toolchains/nix.nix) - Install nix toolchain
    - toolchains.nix.enable `boolean` - Enables the module
  - [node](modules/home-manager/toolchains/node.nix) - Install node toolchain
    - toolchains.node.enable `boolean` - Enables the module
  - [python](modules/home-manager/toolchains/python.nix) - Install python toolchain
    - toolchains.python.enable `boolean` - Enables the module
- [utils](modules/home-manager/utils) - CLI utils submodule
  - [bat](modules/home-manager/utils/bat.nix) - Install bat
    - utils.bat.enable `boolean` - Enables the module
  - [chafa](modules/home-manager/utils/chafa.nix) - Install chafa
    - utils.chafa.enable `boolean` - Enables the module
  - [expect](modules/home-manager/utils/expect.nix) - Install expect tools (e.g. unbuffer)
    - utils.expect.enable `boolean` - Enables the module
  - [ffmpeg](modules/home-manager/utils/ffmpeg.nix) - Install ffmpeg
    - utils.ffmpeg.enable `boolean` - Enables the module
  - [file](modules/home-manager/utils/file.nix) - Install file
    - utils.file.enable `boolean` - Enables the module
  - [fzf](modules/home-manager/utils/fzf.nix) - Install fzf
    - utils.fzf.enable `boolean` - Enables the module
  - [gh](modules/home-manager/utils/gh.nix) - Install gh
    - utils.gh.enable `boolean` - Enables the module
  - [ghostscript](modules/home-manager/utils/ghostscript.nix) - Install ghostscript
    - utils.ghostscript.enable `boolean` - Enables the module
  - [glxinfo](modules/home-manager/utils/glxinfo.nix) - Install glxinfo
    - utils.glxinfo.enable `boolean` - Enables the module
  - [image-magick](modules/home-manager/utils/image-magick.nix) - Install the image-magick suite
    - utils.image-magick.enable `boolean` - Enables the module
  - [iw](modules/home-manager/utils/iw.nix) - Install iw
    - utils.iw.enable `boolean` - Enables the module
  - [jq](modules/home-manager/utils/jq.nix) - Install jq
    - utils.jq.enable `boolean` - Enables the module
  - [killall](modules/home-manager/utils/killall.nix) - Install killall
    - utils.killall.enable `boolean` - Enables the module
  - [lsof](modules/home-manager/utils/lsof.nix) - Install lsof
    - utils.lsof.enable `boolean` - Enables the module
  - [mermaid-cli](modules/home-manager/utils/mermaid-cli.nix) - Install mermaid-cli
    - utils.mermaid-cli.enable `boolean` - Enables the module
  - [ripgrep](modules/home-manager/utils/ripgrep.nix) - Install ripgrep
    - utils.ripgrep.enable `boolean` - Enables the module
  - [parted](modules/home-manager/utils/parted.nix) - Install parted
    - utils.parted.enable `boolean` - Enables the module
  - [playerctl](modules/home-manager/utils/playerctl.nix) - Install playerctl
    - utils.playerctl.enable `boolean` - Enables the module
  - [socat](modules/home-manager/utils/socat.nix) - Install socat
    - utils.socat.enable `boolean` - Enables the module
  - [sqlite](modules/home-manager/utils/sqlite.nix) - Install sqlite
    - utils.sqlite.enable `boolean` - Enables the module
  - [tealdeer](modules/home-manager/utils/tealdeer.nix) - Install tealdeer
    - utils.tealdeer.enable `boolean` - Enables the module
  - [tectonic](modules/home-manager/utils/tectonic.nix) - Install tectonic
    - utils.tectonic.enable `boolean` - Enables the module
  - [unp](modules/home-manager/utils/unp.nix) - Install unp & its requisite tools
    - utils.unp.enable `boolean` - Enables the module
  - [vulkan](modules/home-manager/utils/vulkan.nix) - Install vulkan-tools
    - utils.vulkan.enable `boolean` - Enables the module
  - [wget](modules/home-manager/utils/wget.nix) - Install wget
    - utils.wget.enable `boolean` - Enables the module
  - [wl-clipboard](modules/home-manager/utils/wl-clipboard.nix) - Install wl-clipboard
    - utils.wl-clipboard.enable `boolean` - Enables the module
- [aliases](modules/home-manager/aliases.nix) - Define shell aliases
- [gpg](modules/home-manager/gpg.nix) - Enables gpg keys
  - gpg.enable `boolean` - Enables the module
- [impermanence](modules/home-manager/impermanence.nix) - Enables impermanence at user level
  - impermanence.enable `boolean` - Enables the module
- [neovim](modules/home-manager/neovim.nix) - Enables my custom neovim flake
  - neovim.enable `boolean` - Enables the module
- [terminal](modules/home-manager/terminal.nix) - Configure terminal
  - terminal.enable `boolean` - Enables the module
  - terminal.emulator `string` - Set the terminal emulator to use
- [tmux](modules/home-manager/tmux/default.nix) - Configure tmux
  - tmux.enable `boolean` - Enables the module
  - [sessionx](modules/home-manager/tmux/sessionx.nix) - Configure sessionx
    - tmux.sessionx.enable `boolean` - Enables sessionx
  - [tmuxinator](modules/home-manager/tmux/tmuxinator.nix) - Configure tmuxinator
    - tmux.tmuxinator.enable `boolean` - Enables tmuxinator
- [user-dirs](modules/home-manager/user-dirs.nix) - Custom user dirs
  - user-dirs.enable `boolean` - Enables the module
- [zsh](modules/home-manager/zsh/default.nix) - Configure zsh
  - zsh.enable `boolean` - Enables the module
  - zsh.zoxide.enable `boolean` - Enables zoxide
  - [zsh-vi-mode](modules/home-manager/zsh/zsh-vi-mode.nix) - Configures a better vi mode in zsh
    - zsh.vi-mode.enable `boolean` - Enables zsh-vi-mode

### [nixos](modules/nixos) - Nixos modules

- [services](modules/nixos/services) - Systemd services submodule
  - [clean-old-generations](modules/nixos/services/clean-old-generations.nix) - Systemd service to clean old nixos generations
    - services.clean-old-generations.enable `boolean` - Enables the module
- [hyprland](modules/nixos/hyprland.nix) - Enables hyprland window manager
  - hyprland.enable `boolean` - Enables the module
- [neovim](modules/nixos/impermanence.nix) - Enables impermanence at system level
  - neovim.enable `boolean` - Enables the module
- [nix-ld](modules/nixos/nix-ld.nix) - Enables nix-ld for executing arbitrary binaries
  - nix-ld.enable `boolean` - Enables the module
- [nixos-rebuild-ng](modules/nixos/nixos-rebuild-ng.nix) - Enables nixos-rebuild-ng as a replacement to nixos-rebuild
  - nixos-rebuild-ng.enable `boolean` - Enables the module
- [nvidia](modules/nixos/nvidia.nix) - Enables nvidia configurations
  - nvidia.enable `boolean` - Enables the module
- [partition-manager](modules/nixos/partition-manager.nix) - Install partition-manager
  - partition-manager.enable `boolean` - Enables the module
- [sddm](modules/nixos/sddm.nix) - Enables sddm window manager
  - sddm.enable `boolean` - Enables the module
- [users](modules/nixos/users.nix) - Create default user
  - users.enable `boolean` - Enables the module
  - users.zsh.enable `boolean` - Enables zsh as the default shell (must be done at the system level)
- [vcs](modules/nixos/vcs.nix) - Install git
  - vcs.enable `boolean` - Enables the module

## cheatsheet

NixOS cheatsheet.

To list generations:

```sh
nixos-rebuild list-generations
```

### troubleshooting

To clean the store:

```sh
nix-delete-store
```

To verify/repair the store:

```sh
sudo nix-store --verify --check-contents --repair
```

## development

This project is broken up into NixOS and home-manager configuration. The NixOS
configuration lives in
[configs/nixos/configuration.nix](configs/nixos/configuration.nix)
and [modules/nixos](modules/nixos). While the home-manager configuration lives
in [homes/m3l6h/home.nix](homes/m3l6h/home.nix) and
[modules/home-manager](modules/home-manager).

Although the configuration has been separated, the home-manager side of the
house ultimately is built as a part of the NixOS config. The advantage of
separating it is that during _development_ the home-manager configuration can
be built by itself, but **to persist any changes after reboot, the NixOS
configuration will have to be built.**

### commands

To build the NixOS configuration, run

```sh
nxs
```

To build the home-manager configuration, run

```sh
hms
```

To update the system, run

```sh
nix flake update
nxs
```

To update a single input, run

```sh
nix flake update <input>
nxs
```

## credits

Non-exhaustive list of sources I referenced/learned from while building this.

In no particular order.

### people

- [Vimjoyer](https://www.youtube.com/@vimjoyer)

### other people's configs

- [Liassica/nixos-config](https://codeberg.org/Liassica/nixos-config)
- [Misterio77/nix-config](https://github.com/Misterio77/nix-config)

### articles

- [Impermanent NixOS: on a VM + tmpfs root + flakes + LUKS | Will Bush](https://willbush.dev/blog/impermanent-nixos/)
