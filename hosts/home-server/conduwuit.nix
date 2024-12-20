{...}: {
  services.conduwuit = {
    enable = true;
    settings.global = {
      server_name = "jenericDame.ddns.net";
      port = [ 6167 ]; # default

      allow_registration = true;
      registration_token = "test";
      #registration_token_file = "/etc/conduwuit/.reg_token";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8448 ]; # matrix port

  services.nginx.virtualHosts."jenerictest.ddns-ip.net".locations."/_matrix" = {
    proxyPass = "http://localhost:6167"; # send matrix requests to conduwuit
  };
  # again, create a server to forward matrix requests
  services.nginx.appendHttpConfig = ''
    server {
      listen 8448;
      location / {
        proxy_pass http://localhost:6167;
      }
    }
  '';
}
