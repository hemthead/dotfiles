{ config, lib, pkgs, ... }: {
  services.nginx = {
    enable = true;
    statusPage = true;
    logError = "/var/log/nginx/log notice";
  };
  services.nginx.virtualHosts."jenerictest.ddns-ip.net" = {
    # I'm a bit afraid to activate these until I actually have the domain again
    addSSL = true;
    enableACME = true;
    root = "/var/www/jenericdame.ddns.net";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "theredcoat787@gmail.com";
  };
}
