{ pkgs, ... }: {
  home.packages = with pkgs; [ thunderbird aerc ];
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
