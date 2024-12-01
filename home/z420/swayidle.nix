{ pkgs, ... }: {
  home.packages = with pkgs; [ swayidle ];

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
    ];
    # remove timeouts cause they annoying
    #    timeouts = [
    #      {
    #        timeout = 60 * 10;
    #        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
    #        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
    #      }
    #      {
    #        timeout = 60 * 15;
    #        command = "${pkgs.systemd}/bin/systemctl suspend";
    #      }
    #    ];
  };
}
