{ lib, pkgs, ... }: let
    zinc = pkgs.callPackage ../01-package/package.nix {};
in {

  services.sshd.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 ];

  # Run the Zinc service
  systemd.services.zinc = {
    enable = true;
    description = "Zeus in Numerous Colours";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${zinc}/bin/zinc";
      DynamicUser = true;
    };
  };

  # Run Nginx as reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    appendHttpConfig = ''
        add_header "Permissions-Policy" "interest-cohort=()";
        proxy_headers_hash_bucket_size 64;
    '';

    virtualHosts = {
      "localhost" = {
        locations."/" = {
          proxyPass = "http://localhost:8081";
        };
      };
    };
  };

  system.stateVersion = lib.version;

  users.users.root.password = "nixos";
  services.openssh.settings.PermitRootLogin = lib.mkOverride 999 "yes";
  services.getty.autologinUser = lib.mkOverride 999 "root";
}
