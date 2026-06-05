{ config, lib, pkgs, ... }:
let
  cfg = config.services.openreturn;
in {
  options.services.openreturn = {
    enable = lib.mkEnableOption "openreturn IRS 990 API server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./build.nix {};
      defaultText = lib.literalExpression "pkgs.callPackage ./build.nix {}";
      description = "The openreturn package to use.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Bind address for the HTTP server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Bind port for the HTTP server.";
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose request/response logging.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/openreturn";
      description = "Directory where IRS990.db is stored. The service runs from this directory.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "openreturn";
      description = "User account under which openreturn runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "openreturn";
      description = "Group under which openreturn runs.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the firewall for the configured port.";
    };

    auth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Require API key authentication for all requests.";
    };

  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "openreturn service user";
    };

    users.groups.${cfg.group} = {};

    systemd.services.openreturn = {
      description = "openreturn IRS 990 API server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.removePrefix "/var/lib/" cfg.dataDir;
        StateDirectoryMode = "0750";

        ExecStart = lib.concatStringsSep " " (
          [ "${cfg.package}/bin/openreturn" "--host" cfg.host "--port" (toString cfg.port) ]
          ++ lib.optional cfg.debug "--debug"
          ++ lib.optional cfg.auth "--auth"
        );

        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ];
        ProtectHome = true;
      };
    };
  };
}
