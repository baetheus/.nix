{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.photoprism;
in {
  options.services.photoprism = with types; {
    enable = mkEnableOption "photoprism service";

    package = mkOption {
      type = package;
      default = pkgs.photoprism;
      defaultText = "pkgs.photoprism";
      description = "The package to use for photoprism";
    };

    path = mkOption {
      type = path;
      default = "/var/lib/photoprism";
      description = "config storage PATH, values in options.yml override CLI flags and environment variables if present";
    };

    config = mkOption {
      type = path;
      description = "file to copy to configPath as 'options.yml' to configure photoprism";
    };

    originalsPath = mkOption {
      type = path;
      default = "${cfg.path}/originals";
      description = "path to directory containing original images";
    };

    importPath = mkOption {
      type = path;
      default = "${cfg.path}/import";
      description = "path to directory containing imports";
    };

    storagePath = mkOption {
      type = path;
      default = "${cfg.path}/storage";
      description = "path to directory for photoprism storage";
    };

    user = mkOption {
      type = str;
      default = "photoprism";
      description = "User account under which photoprism runs.";
    };

    group = mkOption {
      type = str;
      default = "photoprism";
      description = "Group associated which photoprism runs.";
    };
  };

  config = mkIf cfg.enable {
    # Create the user if it is default
    users.users = mkIf (cfg.user == "photoprism") {
      photoprism = {
        description = "Photoprism Service";
        home = cfg.path;
        useDefaultShell = true;
        group = "photoprism";
        isSystemUser = true;
      };
    };

    # Create the group if it is default
    users.groups = mkIf (cfg.group == "photoprism") {
      photoprism = {};
    };

    # Configure systemd
    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.rules = [
      "d '${cfg.path}' 0770 ${cfg.user} ${cfg.group} - -"
      "F '${cfg.path}/options.yml' 0770 ${cfg.user} ${cfg.group} - ${cfg.config}"
      "d '${cfg.originalsPath}' 0770 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.importPath}' 0770 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.storagePath}' 0770 ${cfg.user} ${cfg.group} - -"
    ];
    systemd.services.photoprism = {
      description = "photoprism server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];

      environment = {
        PHOTOPRISM_CONFIG_PATH = cfg.path;
        PHOTOPRISM_ORIGINALS_PATH = cfg.originalsPath;
        PHOTOPRISM_IMPORT_PATH = cfg.importPath;
        PHOTOPRISM_STORAGE_PATH = cfg.storagePath;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.path;
        ReadWritePaths = [ cfg.path ];
        ExecStart = "${cfg.package}/bin/photoprism up";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
