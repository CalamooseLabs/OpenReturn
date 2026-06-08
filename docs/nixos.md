# NixOS Module

OpenReturn ships a NixOS module. Add the flake as an input and enable the service:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    openreturn = {
      url = "github:CalamooseLabs/OpenReturn";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, openreturn, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        openreturn.nixosModules.default
        {
          services.openreturn = {
            enable = true;
            host   = "0.0.0.0";
            port   = 8080;
          };
        }
      ];
    };
  };
}
```

## Module Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `false` | Enable the service |
| `package` | package | flake default | Override the openreturn package |
| `host` | string | `"localhost"` | Bind address |
| `port` | port | `8080` | Bind port |
| `debug` | bool | `false` | Verbose request/response logging |
| `dataDir` | string | `"/var/lib/openreturn"` | Directory where `IRS990.db` is stored |
| `user` | string | `"openreturn"` | Service user |
| `group` | string | `"openreturn"` | Service group |
| `runAsRoot` | bool | `false` | Run as root instead of the dedicated service user (not recommended) |
| `openFirewall` | bool | `true` | Open the firewall for the configured port |
| `auth` | bool | `false` | Require API key authentication for all requests |
| `models` | list of model submodules | `[]` | Scoring models to register automatically (see below) |

## Scoring Models

Define scoring models directly in your NixOS configuration. Each model is written to a TOML file in the Nix store and registered by a one-shot systemd service (`openreturn-register-models.service`) that runs before the API server starts.

```nix
services.openreturn = {
  enable = true;
  models = [
    {
      version     = 1;
      description = "Initial financial health model";
      factors = [
        {
          name               = "Program Efficiency";
          weight             = 0.40;
          formula_type       = "ratio";
          inputs             = [ "prog" "total_exp" ];
          direction          = "higher";
          benchmark_lo       = 0.50;
          benchmark_hi       = 0.85;
          formula_description = "Program expenses as a share of total expenses";
        }
        {
          name         = "Expense Growth";
          weight       = 0.30;
          formula_type = "growth";
          inputs       = [ "cy_exp" "py_exp" ];
          direction    = "lower";
          benchmark_lo = 0.0;
          benchmark_hi = 0.15;
        }
        {
          name         = "Revenue Stability";
          weight       = 0.30;
          formula_type = "coefficient_of_variation";
          inputs       = [ "cy_rev" ];
          direction    = "lower";
          benchmark_lo = 0.0;
          benchmark_hi = 0.5;
        }
      ];
    }
  ];
};
```

### Factor fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Unique factor name; used in `factor:<name>` references |
| `weight` | number | yes | Contribution weight (≥ 0); set to `0` for intermediate factors |
| `formula_type` | string | yes | Formula type — see [Scoring Models](scoring/models.md) for the full list |
| `inputs` | list of strings | yes | Ordered input keys, numeric literals, or `factor:<name>` references |
| `direction` | `"higher"` or `"lower"` | yes | Which end of the benchmark range scores best |
| `benchmark_lo` | number | yes | Lower bound for normalization |
| `benchmark_hi` | number | yes | Upper bound (must be > `benchmark_lo`) |
| `formula_description` | string or null | no | Human-readable description |

### How model registration works

When `models` is non-empty, the module creates `openreturn-register-models.service`:

- **Type = oneshot, RemainAfterExit = true** — runs once, stays "active" so the API server knows it completed
- Runs **after** `openreturn-migrate.service` and **before** `openreturn.service`; the API server will not start until registration is done
- For each model, runs `openreturn models register --skip-existing <toml-file>` — if the version is already in the database the step is silently skipped, making redeployment safe
- Uses the same user, group, and `dataDir` as the main service

### Updating a model

Model versions are immutable once registered — changing a factor's formula without bumping the version has no effect (the existing DB row is kept). To deploy updated factors:

1. Bump `version` (e.g. `version = 2`)
2. Run `nixos-rebuild switch`

The registration service will register the new version. The old version remains in the database and any scores computed under it are preserved. Use `GET /scores/compare?ein=...&year=...` to see results under both versions side by side.

## Systemd Service Chain

The module creates up to four services that run in dependency order before the API server starts:

| Service | What it does |
|---------|-------------|
| `openreturn-init.service` | Initializes the database schema and seeds form definitions (990, 990-EZ, 990-N, 990-PF, 990-T). No-op if already initialized. |
| `openreturn-migrate.service` | Applies any pending schema migrations from the migration log. Safe to run on every deploy. |
| `openreturn-register-models.service` | Registers scoring models declared in `cfg.models`. Only present when `models != []`. |
| `openreturn.service` | The HTTP API server. Starts only after all of the above complete. |

All three setup services use `Type = oneshot; RemainAfterExit = true` so systemd treats them as "active" once complete and only re-runs them if the unit is explicitly reset.

## Security Hardening

The service runs as a dedicated system user with a hardened systemd unit:

- `PrivateTmp = true`
- `ProtectSystem = strict`
- `NoNewPrivileges = true` (when `port >= 1024`)

When `port < 1024` (e.g. `port = 80`) the unit instead grants `CAP_NET_BIND_SERVICE` via `AmbientCapabilities` and locks the capability bounding set to that single capability. The process can bind the privileged port without running as root and without being able to acquire any other capability.

The database file is written to `dataDir`, which is managed by systemd's `StateDirectory` directive.

## Restart Behaviour

The unit restarts automatically on failure with a 5-second delay between attempts. If the service crashes 5 times within 60 seconds systemd stops retrying and marks it failed — this prevents a broken startup from looping forever.

```bash
# Inspect what went wrong
journalctl -u openreturn -n 50

# Clear the failure state and try again
systemctl reset-failed openreturn
systemctl start openreturn
```

Deploying a new version via `nixos-rebuild switch` automatically restarts the service.

## Managing Keys on a NixOS Host

The `openreturn keys` and `openreturn models` subcommands expect to run from the directory where `OpenReturn.db` lives (`dataDir`, default `/var/lib/openreturn`):

```bash
cd /var/lib/openreturn
openreturn keys create "Dashboard"
openreturn models register /path/to/model_v1.toml
```

See [API Keys](api-keys.md) and [Scoring Models](scoring/models.md) for full CLI reference.
