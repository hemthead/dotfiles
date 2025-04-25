{ pkgs, ... }: {
  home.packages = with pkgs; [ swayidle ];

  #services.swayidle.timeouts = [
  # remove timeouts cause they annoying
  #    {
  #      timeout = 60 * 10;
  #      command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
  #      resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
  #    }
  #    {
  #      timeout = 60 * 15;
  #      command = "${pkgs.systemd}/bin/systemctl suspend";
  #    }
  #];
}
