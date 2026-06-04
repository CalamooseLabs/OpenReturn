{ config, lib, pkgs, ... }:
let
  cfg = config.services.ffapi;
in {
  options.services.ffapi = {
    enable = lib.mkEnableOption "ffapi IRS 990 API server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./build.nix {};
      defaultText = lib.literalExpression "pkgs.callPackage ./build.nix {}";
      description = "The ffapi package to use.";
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
      default = "/var/lib/ffapi";
      description = "Directory where IRS990.db is stored. The service runs from this directory.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "ffapi";
      description = "User account under which ffapi runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "ffapi";
      description = "Group under which ffapi runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "ffapi service user";
    };

    users.groups.${cfg.group} = {};

    systemd.services.ffapi = {
      description = "ffapi IRS 990 API server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.removePrefix "/var/lib/" cfg.dataDir;
        StateDirectoryMode = "0750";

        ExecStart = lib.concatStringsSep " " (
          [ "${cfg.package}/bin/ffapi" "--host" cfg.host "--port" (toString cfg.port) ]
          ++ lib.optional cfg.debug "--debug"
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
