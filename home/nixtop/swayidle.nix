{ pkgs, ... }: {
  services.swayidle.timeouts = [
      {
        timeout = 60 * 3;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        timeout = 60 * 1;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
      {
        timeout = 60 * 10;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
}
