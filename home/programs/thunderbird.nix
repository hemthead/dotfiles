{ pkgs, ... }: { 
  home.packages = [ pkgs.thunderbird ];
#  programs.thunderbird = {
#    enable = true;
#    profiles = {
#      "John Douglas Reed" = {
#        #name = "John Douglas Reed";
#        isDefault = true;
#      };
#    };
#  };
}
