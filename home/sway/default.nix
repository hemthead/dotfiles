{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./swaylock.nix ./swayidle.nix ./i3status-rust.nix test];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # super
      terminal = "foot";
      startup = [];

      colors.focused = {
        background = "#A020F0"; # X11 purple
        border = "#663399"; # Rebecca purple
        childBorder = "#A020F0"; # X11 purple
        indicator = "#800080"; # HTML/CSS purple
        text = "#ffffff";
      };

      focus = {
        followMouse = false;
        mouseWarping = false;
        wrapping = "no";
      };

      gaps.inner = 10;

      bars = [
        {
          id = "default";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml 2> /tmp/i3status-rust.log";
          colors.focusedWorkspace = with colors.focused; {
            background = background;
            border = border;
            text = text;
          };
        }
      ];

      modes = {
        resize = {
          Down = "resize grow height 10 px";
          Left = "resize shrink width 10 px";
          Right = "resize grow width 10 px";
          Up = "resize shrink height 10 px";
          j = "resize grow height 10 px";
          h = "resize shrink width 10 px";
          l = "resize grow width 10 px";
          k = "resize shrink height 10 px";

          Escape = "mode default";
          Return = "mode default";
        };

        "exit: [l]ogout, [r]eboot, [s]hutdown, s[u]spend, [h]ibernate, loc[k]" = {
          l = "exec swaymsg exit";
          r = "exec reboot";
          s = "exec shutdown now";
          u = "exec systemctl suspend; mode default";
          h = "exec systemctl hibernate; mode default";
          k = "exec swaylock; mode default";

          Escape = "mode default";
          Return = "mode default";
        };
      };

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";
          "XF86AudioMute" = "exec pamixer -t";
          "XF86AudioMicMute" = "exec pamixer --default-source -t";
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          "${modifier}+x" = "mode 'exit: [l]ogout, [r]eboot, [s]hutdown, s[u]spend, [h]ibernate, loc[k]'";
        };

      defaultWorkspace = "workspace number 1";
    };

    extraConfig = ''
      output * bg ${../../wallpaper} fill
    '';
  };

  home.packages = with pkgs; [swaybg wl-clipboard mako shotman];

  services.mako.enable = true;
}
