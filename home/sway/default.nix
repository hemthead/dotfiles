{ pkgs, lib, config, ... }: {
  imports = [
    ./i3status-rust
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # super
      terminal = "foot";
      startup = [];

      focus = {
        followMouse = false;
	mouseWarping = false;
	wrapping = "no";
      };

      gaps.inner = 10;

      bars = [{
	  statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs 2> /tmp/i3status-rust.log";
      }];

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

  home.packages = with pkgs; [
    swaylock
    swayidle
    swaybg
    wl-clipboard
    mako
    shotman
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      image = "${../../wallpaper}";
    };
  };

  services.mako.enable = true;

  services.swayidle = {
    enable = true;
    events = [
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { event = "before-sleep"; command = "${pkgs.systemd}/bin/loginctl lock-session"; }
    ];
    timeouts = [
      { timeout = 60*3; command = "${pkgs.systemd}/bin/loginctl lock-session"; }
      { timeout = 60*1; command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'"; }
      { timeout = 60*10; command = "pkill swaylock; ${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
