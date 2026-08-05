{ config, lib, ... }: with lib;
{
  options = {
    kbremap.enable = mkEnableOption "enable keyboard remapping";
  };

  config = mkIf config.kbremap.enable {
    services.kanata = {
      enable = true;
      keyboards.default = {
        extraArgs = [ "--nodelay" ];
        # Avoid needing to remap every key
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            lmet    rmet
          )
          (deflayer default
            @lmeth  @rmeth
          )
          (deflayer normal
            lmet    rmet
          )

          (defvirtualkeys
            showkm f23
            hidekm f24
          )

          (defalias
            ;; Normal SUPER
            lmetn (multi (layer-while-held normal) lmet)
            rmetn (multi (layer-while-held normal) rmet)
            ;; Fire f24 if holding SUPER for more than 500ms while still holding SUPER
            ;; Switch to normal layer to avoid triggering this multiple times while holding
            lmeth (tap-hold-press-timeout 500 1000 _ _ (multi (on-press tap-vkey showkm) (layer-while-held normal) lmet (on-release tap-vkey hidekm)))
            rmeth (tap-hold-press-timeout 500 1000 _ _ (multi (on-press tap-vkey showkm) (layer-while-held normal) rmet (on-release tap-vkey hidekm)))
          )
        '';
      };
    };
  };
}
