{ pkgs, conduwuit, ... }: {
  services.conduwuit = {
    enable = true;
    package = conduwuit.packages.${pkgs.system}.default;

    settings.global = {
      server_name = "jenerictest.ddns-ip.net";
      port = [ 6167 ]; # default

      allow_registration = true;
      registration_token = "test";
      #registration_token_file = "/etc/conduwuit/.reg_token";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8448 ]; # matrix port

  services.nginx.virtualHosts."jenerictest.ddns-ip.net" = {
    locations."/_matrix" = {
      proxyPass = "http://localhost:6167"; # send matrix requests to conduwuit
    };
    listen = [
      {
        addr = "0.0.0.0";
        port = 8448;
        ssl = true;
      }
      {
        addr = "[::0]";
        port = 8448;
        ssl = true;
      }
    ];
  };
}
