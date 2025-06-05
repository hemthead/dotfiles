{ pkgs
, lib
, config
, ...
}:
let
  wallpaper-shift = pkgs.writeShellScript "wallpaper-shift" ''
    # poll for two hours before before/after dark starts/ends at Cincinnati, OH
    ${pkgs.sunwait}/bin/sunwait poll offset 02:00 39.103119N 84.512016W
    time=$?

    set -eu

    case $time in
    2) # day
        ${pkgs.sway}/bin/swaymsg output "*" bg ${../../wallpapers/day} center "#A6CCD9"
      ;;
    3) # night
        ${pkgs.sway}/bin/swaymsg output "*" bg ${../../wallpapers/night} center "#1C1F4E"
      ;;
    *) # error
      exit 1
      ;;
    esac
  '';
in
{
  imports = [ ./i3status-rust.nix ./mako.nix ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # super
      terminal = "ghostty";
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

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          "XF86MonBrightnessUp" = "exec brightnessctl set -e +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set -e 5%-";

          "${modifier}+p" = "exec shotman --capture window";
          "${modifier}+Shift+p" = "exec shotman --capture region";
          "${modifier}+Ctrl+p" = "exec shotman --capture output";

          "${modifier}+x" = "mode 'exit: [l]ogout, [r]eboot, [s]hutdown, s[u]spend, [h]ibernate, loc[k]'";
        };

      defaultWorkspace = "workspace number 1";
    };

    extraConfig = ''
      #exec_always systemctl --user start wallpaper-shift.service

      # make godot windows open floating (godot likes to use many windows for menues)
      for_window [class="Godot"] floating enable
    '';
  };

  services.wpaperd.enable = true;
  services.wpaperd.settings = builtins.fromTOML (builtins.readFile ./wpaperd.toml);
  #xdg.configFile."wpaperd/config.toml".source = ./wpaperd.toml;

  # manage wallpapers according to time
  #  systemd.user.timers."wallpaper-shift" = {
  #    Timer = {
  #      OnStartupSec = "30m";
  #      OnUnitActiveSec = "30m";
  #      Unit = "wallpaper-shift.service";
  #      Persistent = true;
  #    };
  #    Install = {
  #      WantedBy = [ "default.target" ];
  #    };
  #  };
  #  systemd.user.services."wallpaper-shift" = {
  #    Service = {
  #      Type = "oneshot";
  #      ExecStart = "${wallpaper-shift}";
  #    };
  #
  #    Install = {
  #      WantedBy = [ "default.target" "sway-session.target" ];
  #    };
  #  };

  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    events = [
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "after-resume";
        #command = "${wallpaper-shift}";
        command = "";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "1C1F4E";
      image = "${../../wallpapers/lock}";
      scaling = "center";
    };
  };

  home.packages = with pkgs; [ swayimg swaybg wl-clipboard shotman sunwait swayidle ];
}
