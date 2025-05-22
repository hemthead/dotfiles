{ pkgs, zen-browser, ... }: {
  home.packages = with pkgs; [
    thunderbird
    aerc
    vdhcoapp
    xfce.thunar
    obsidian
    zen-browser.packages.${pkgs.system}.default
    abcde # cd ripper
  ];

  # I have zen, but sometimes media playback wants to be quirky, so firefox is a backup
  programs.firefox = {
    enable = true;
    # I WOULD have this enabled but FIREFOX doesn't let me >:[
    #    profiles.johndr = {
    #      id = 0;
    #      isDefault = true;
    #      search.default = "DuckDuckGo";
    #      search.engines = {
    #        "Nix Packages (unstable)" = {
    #          urls = [{
    #            template = "https://search.nixos.org/packages";
    #            params = [
    #              { name = "channel"; value = "unstable"; }
    #              { name = "type"; value = "packages"; }
    #              { name = "query"; value = "{searchTerms}"; }
    #            ];
    #          }];
    #
    #          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #          definedAliases = [ "@pkgs" ];
    #        };
    #
    #        "NixOS Wiki" = {
    #          urls = [{
    #            template = "https://nixos.wiki/index.php";
    #            params = [
    #              { name = "search"; value = "{searchTerms}"; }
    #            ];
    #          }];
    #          iconUpdateURL = "https://nixos.wiki/favicon.png";
    #          updateInterval = 24 * 60 * 60 * 1000; # every day
    #          definedAliases = [ "@nixwiki" ];
    #        };
    #
    #        "NixOS Options" = {
    #          urls = [{
    #            template = "https://search.nixos.org/options";
    #            params = [
    #              { name = "channel"; value = "unstable"; }
    #              { name = "query"; value = "{searchTerms}"; }
    #            ];
    #          }];
    #          iconUpdateURL = "https://search.nixos.org/favicon.png";
    #          updateInterval = 24 * 60 * 60 * 1000; # every day
    #          definedAliases = [ "@opts" ];
    #        };
    #
    #        "Wiby" = {
    #          urls = [{
    #            template = "https://wiby.org";
    #            params = [
    #              { name = "q"; value = "{searchTerms}"; }
    #            ];
    #          }];
    #          iconUpdateURL = "https://wiby.org/favicon.ico";
    #          updateInterval = 24 * 60 * 60 * 1000; # every day
    #          definedAliases = [ "@wiby" ];
    #        };
    #
    #        "Home Manager Options" = {
    #          urls = [{
    #            template = "https://home-manager-options.extranix.com/";
    #            params = [
    #              { name = "release"; value = "master"; }
    #              { name = "query"; value = "{searchTerms}"; }
    #            ];
    #          }];
    #          iconUpdateURL = "https://home-manager-options.extranix.com/images/favicon.png";
    #          updateInterval = 24 * 60 * 60 * 1000; # every day
    #          definedAliases = [ "@hmopts" ];
    #        };
    #
    #        "Bing".metaData.hidden = true;
    #        "DuckDuckGo".metadata.alias = "@ddg";
    #        "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
    #      };
    #    };
  };
}
