{pkgs, ...}: {
  home.packages = with pkgs; [swayidle];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];
    timeouts = [
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
  };
}
