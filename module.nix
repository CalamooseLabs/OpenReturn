{ config, lib, pkgs, ... }:
let
  cfg = config.services.openreturn;
  effectiveUser  = if cfg.runAsRoot then "root" else cfg.user;
  effectiveGroup = if cfg.runAsRoot then "root" else cfg.group;

  # ---------------------------------------------------------------------------
  # TOML generation for scoring models
  # ---------------------------------------------------------------------------

  mkInputList = inputs:
    "[" + lib.concatMapStringsSep ", " (i: "\"${i}\"") inputs + "]";

  mkFactor = f:
    "\n[[factor]]\n"
    + "name               = \"${f.name}\"\n"
    + "weight             = ${toString f.weight}\n"
    + lib.optionalString (f.formula_type != null) "formula_type       = \"${f.formula_type}\"\n"
    + lib.optionalString (f.inputs != null)       "inputs             = ${mkInputList f.inputs}\n"
    + lib.optionalString (f.scale != null)        "scale              = \"${f.scale}\"\n"
    + lib.optionalString (f.direction != null)    "direction          = \"${f.direction}\"\n"
    + lib.optionalString (f.benchmark_lo != null) "benchmark_lo       = ${toString f.benchmark_lo}\n"
    + lib.optionalString (f.benchmark_hi != null) "benchmark_hi       = ${toString f.benchmark_hi}\n"
    + lib.optionalString (f.formula_description != null)
        "formula_description = \"${f.formula_description}\"\n";

  mkModelToml = model:
    pkgs.writeText "openreturn-model-v${toString model.version}.toml" (
      "[model]\n"
      + "version = ${toString model.version}\n"
      + lib.optionalString (model.description != null)
          "description = \"${model.description}\"\n"
      + lib.optionalString (model.type != null) "type = \"${model.type}\"\n"
      + lib.optionalString (model.mode != "computed") "mode = \"${model.mode}\"\n"
      + lib.concatMapStrings mkFactor model.factors
    );

  modelFiles = map mkModelToml cfg.models;

  hasModels = cfg.models != [];

  # ---------------------------------------------------------------------------
  # Database encryption key injection
  #
  # The app reads the SQLCipher key from DB_SECRET_KEY (literal) or
  # DB_SECRET_KEY_FILE (a path). For a file we use systemd credentials so the
  # secret stays out of the Nix store and out of `systemctl show`; `%d` expands
  # to the per-service credentials directory at runtime. Every unit that opens
  # the database (init creates it encrypted; migrate/register-models/serve open
  # it) gets the same injection.
  # ---------------------------------------------------------------------------

  dbSecretServiceConfig =
    if cfg.database.secretKeyFile != null then {
      LoadCredential = [ "db-secret-key:${cfg.database.secretKeyFile}" ];
      Environment    = [ "DB_SECRET_KEY_FILE=%d/db-secret-key" ];
    } else if cfg.database.secretKey != null then {
      # Escape `%` so it is not read as a systemd specifier in Environment=.
      Environment = [ "DB_SECRET_KEY=${lib.replaceStrings [ "%" ] [ "%%" ] cfg.database.secretKey}" ];
    } else {};

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
      description = "Directory where OpenReturn.db is stored. The service runs from this directory.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "openreturn";
      description = "User account under which openreturn runs. Ignored when runAsRoot = true.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "openreturn";
      description = "Group under which openreturn runs. Ignored when runAsRoot = true.";
    };

    runAsRoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Run the service as root instead of the dedicated service user.
        Not recommended for production — prefer the default unprivileged
        setup, which grants CAP_NET_BIND_SERVICE automatically when port < 1024.
      '';
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

    database = {
      secretKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/openreturn-db-key";
        description = ''
          Path to a file whose contents are the SQLCipher encryption key. The
          file is loaded at runtime via systemd credentials (`LoadCredential`)
          and never enters the Nix store or the process environment of other
          units, so it composes with agenix, sops-nix, `systemd-creds`, or any
          tool that drops a secret file on the host readable by the service.

          Setting this (or `database.secretKey`) enables at-rest encryption of
          the database. Mutually exclusive with `database.secretKey`.
        '';
      };

      secretKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          SQLCipher encryption key given as a literal string.

          INSECURE: the value is copied verbatim into the world-readable Nix
          store and is visible via `systemctl show`. Use it only for throwaway
          or local testing; prefer `database.secretKeyFile` everywhere else.
          Mutually exclusive with `database.secretKeyFile`.
        '';
      };
    };

    models = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          version = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Model version number. Must be unique — bump this when changing factors.";
          };

          description = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional human-readable description of the model.";
          };

          type = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "governance";
            description = ''
              Model category — one of the seeded `model_type` codes (`financial`,
              `governance`, `whole_person`, `christ_centeredness`). Validated at
              registration.
            '';
          };

          mode = lib.mkOption {
            type = lib.types.enum [ "computed" "manual" ];
            default = "computed";
            description = ''
              `computed` (default): factors are evaluated from formulas over 990
              data. `manual`: factors are graded by a person (a value + comment
              supplied via the grading API); set each factor's `scale` instead of
              `formula_type`/`inputs`.
            '';
          };

          factors = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Unique factor name. Used in factor:<name> references.";
                };

                weight = lib.mkOption {
                  type = lib.types.number;
                  description = "Contribution weight (≥ 0). Set to 0 for intermediate factors.";
                };

                formula_type = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Formula type for a computed model (e.g. ratio, growth, clamp, cagr). Omit for manual factors.";
                };

                inputs = lib.mkOption {
                  type = lib.types.nullOr (lib.types.listOf lib.types.str);
                  default = null;
                  description = "Ordered input keys for a computed factor (field keys, numeric literals, or factor:<name>). Omit for manual factors.";
                };

                scale = lib.mkOption {
                  type = lib.types.nullOr (lib.types.enum [ "benchmark" "normalized" "percent" ]);
                  default = null;
                  description = ''
                    For a manual (graded) factor: how the grader's entered value maps to
                    [0,1] — `benchmark` (via direction + benchmark_lo/hi), `normalized`
                    (already 0–1), or `percent` (0–100 ÷ 100). Omit for computed factors.
                  '';
                };

                direction = lib.mkOption {
                  type = lib.types.nullOr (lib.types.enum [ "higher" "lower" ]);
                  default = null;
                  description = "Which end of the benchmark range scores best (computed factors, and manual factors with scale = benchmark).";
                };

                benchmark_lo = lib.mkOption {
                  type = lib.types.nullOr lib.types.number;
                  default = null;
                  description = "Lower bound for normalization.";
                };

                benchmark_hi = lib.mkOption {
                  type = lib.types.nullOr lib.types.number;
                  default = null;
                  description = "Upper bound for normalization (must be > benchmark_lo).";
                };

                formula_description = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Human-readable description of what the factor measures (computed) or grading guidance (manual).";
                };
              };
            });
            description = "List of scoring factors.";
          };
        };
      });
      default = [];
      description = ''
        Scoring models to register automatically on first deployment.
        Each model is written to a TOML file in the Nix store and registered
        via a one-shot systemd service that runs before the API server starts.
        Models are skipped if their version number is already in the database,
        so it is safe to redeploy without re-registering existing models.
        To update a model, bump the version number.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = !(cfg.database.secretKey != null && cfg.database.secretKeyFile != null);
      message = "services.openreturn: set at most one of database.secretKey and database.secretKeyFile, not both.";
    }];

    warnings = lib.optional (cfg.database.secretKey != null) (
      "services.openreturn.database.secretKey is written world-readable into the Nix store and shown by "
      + "`systemctl show`. Use database.secretKeyFile (agenix/sops-nix/systemd credentials) for real secrets."
    );

    environment.systemPackages = [ cfg.package ];

    # Clear any prior failed/rate-limited state before switch-to-configuration
    # tries to restart the unit, so config changes always take effect immediately.
    system.activationScripts.openreturn-reset-failed = lib.stringAfter [ "users" ] ''
      systemctl reset-failed openreturn.service 2>/dev/null || true
      systemctl reset-failed openreturn-init.service 2>/dev/null || true
      systemctl reset-failed openreturn-migrate.service 2>/dev/null || true
      ${lib.optionalString hasModels
        "systemctl reset-failed openreturn-register-models.service 2>/dev/null || true"}
    '';

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    users.users.${cfg.user}  = lib.mkIf (!cfg.runAsRoot) {
      isSystemUser = true;
      group = cfg.group;
      description = "openreturn service user";
    };
    users.groups.${cfg.group} = lib.mkIf (!cfg.runAsRoot) {};

    # ------------------------------------------------------------------
    # One-shot service: initialize database schema and seed data.
    # Runs once on first deployment; subsequent runs are no-ops.
    # ------------------------------------------------------------------
    systemd.services.openreturn-init = {
      description = "Initialize OpenReturn database";
      wantedBy = [ "multi-user.target" ];
      before    = [ "openreturn-migrate.service" "openreturn.service" ]
                  ++ lib.optional hasModels "openreturn-register-models.service";

      serviceConfig = {
        Type             = "oneshot";
        RemainAfterExit  = true;
        User             = effectiveUser;
        Group            = effectiveGroup;
        WorkingDirectory = cfg.dataDir;
        StateDirectory   = lib.removePrefix "/var/lib/" cfg.dataDir;
        StateDirectoryMode = "0750";
        PrivateTmp       = true;
        ProtectSystem    = "strict";
        ReadWritePaths   = [ cfg.dataDir ];
        ProtectHome      = true;
        NoNewPrivileges  = true;
      } // dbSecretServiceConfig;

      script = ''
        ${cfg.package}/bin/openreturn init
      '';
    };

    # ------------------------------------------------------------------
    # One-shot service: apply pending database migrations.
    # Runs after init, before the server and model registration.
    # ------------------------------------------------------------------
    systemd.services.openreturn-migrate = {
      description = "Apply OpenReturn database migrations";
      wantedBy = [ "multi-user.target" ];
      after     = [ "openreturn-init.service" ];
      wants     = [ "openreturn-init.service" ];
      before    = [ "openreturn.service" ]
                  ++ lib.optional hasModels "openreturn-register-models.service";

      serviceConfig = {
        Type             = "oneshot";
        RemainAfterExit  = true;
        User             = effectiveUser;
        Group            = effectiveGroup;
        WorkingDirectory = cfg.dataDir;
        StateDirectory   = lib.removePrefix "/var/lib/" cfg.dataDir;
        StateDirectoryMode = "0750";
        PrivateTmp       = true;
        ProtectSystem    = "strict";
        ReadWritePaths   = [ cfg.dataDir ];
        ProtectHome      = true;
        NoNewPrivileges  = true;
      } // dbSecretServiceConfig;

      script = ''
        ${cfg.package}/bin/openreturn migrate
      '';
    };

    # ------------------------------------------------------------------
    # One-shot service: register scoring models before the server starts.
    # Only created when cfg.models is non-empty.
    # ------------------------------------------------------------------
    systemd.services.openreturn-register-models = lib.mkIf hasModels {
      description = "Register OpenReturn scoring models";
      wantedBy = [ "multi-user.target" ];
      before    = [ "openreturn.service" ];

      serviceConfig = {
        Type             = "oneshot";
        RemainAfterExit  = true;
        User             = effectiveUser;
        Group            = effectiveGroup;
        WorkingDirectory = cfg.dataDir;
        StateDirectory   = lib.removePrefix "/var/lib/" cfg.dataDir;
        StateDirectoryMode = "0750";
        PrivateTmp       = true;
        ProtectSystem    = "strict";
        ReadWritePaths   = [ cfg.dataDir ];
        ProtectHome      = true;
        NoNewPrivileges  = true;
      } // dbSecretServiceConfig;

      script = lib.concatMapStrings (tomlFile: ''
        ${cfg.package}/bin/openreturn models register --skip-existing ${tomlFile}
      '') modelFiles;
    };

    # ------------------------------------------------------------------
    # Main API server
    # ------------------------------------------------------------------
    systemd.services.openreturn = {
      description = "OpenReturn API server";
      wantedBy = [ "multi-user.target" ];
      after  = [ "network.target" "openreturn-migrate.service" ]
               ++ lib.optional hasModels "openreturn-register-models.service";
      wants  = [ "openreturn-migrate.service" ]
               ++ lib.optional hasModels "openreturn-register-models.service";

      restartTriggers = [ cfg.package cfg.host (toString cfg.port) ];

      serviceConfig = {
        User = effectiveUser;
        Group = effectiveGroup;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.removePrefix "/var/lib/" cfg.dataDir;
        StateDirectoryMode = "0750";

        ExecStart = lib.concatStringsSep " " (
          [ "${cfg.package}/bin/openreturn" "serve" "--host" cfg.host "--port" (toString cfg.port) ]
          ++ lib.optional cfg.debug "--debug"
          ++ lib.optional cfg.auth "--auth"
        );

        Environment = [ "PYTHONUNBUFFERED=1" ] ++ (dbSecretServiceConfig.Environment or []);
        LoadCredential = dbSecretServiceConfig.LoadCredential or [];

        Restart = "on-failure";
        RestartSec = "5s";
        StartLimitIntervalSec = "0";

        PrivateTmp = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ];
        ProtectHome = true;
      } // lib.optionalAttrs (!cfg.runAsRoot && cfg.port < 1024) {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      } // lib.optionalAttrs (!cfg.runAsRoot && cfg.port >= 1024) {
        NoNewPrivileges = true;
      };
    };
  };
}
