{ pkgs
, lib
, config
, ...
}: {
  imports = [ ./swaylock.nix ./swayidle.nix ./i3status-rust.nix ./mako.nix ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # super
      terminal = "foot";
      startup = [ ];

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

      keybindings = let modifier = config.wayland.windowManager.sway.config.modifier; in lib.mkOptionDefault {
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
	"XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -e s 5%-";
	"XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -e s +5%";
	"${modifier}+p" = "exec ${pkgs.shotman}/bin/shotman --capture window";
	"${modifier}+Shift+p" = "exec ${pkgs.shotman}/bin/shotman --capture region";
	"${modifier}+Ctrl+p" = "exec ${pkgs.shotman}/bin/shotman --capture output";
    };

      defaultWorkspace = "workspace number 1";
    };

    extraConfig = ''
      output * bg ${../../wallpaper} fill
    '';
  };

  home.packages = with pkgs; [ swaybg wl-clipboard shotman ];
}
