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

    workingDir = mkOption {
      type = path;
      default = "/var/lib/photoprism";
      description = "config storage PATH, values in options.yml override CLI flags and environment variables if present";
    };

    environmentFile = mkOption {
      type = path;
      description = "path to file with environment variables";
    };

    config = mkOption {
      type = path;
      description = "file to copy to configPath as 'options.yml' to configure photoprism";
    };

    originalsPath = mkOption {
      type = path;
      default = "${cfg.workingDir}/originals";
      description = "path to directory containing original images";
    };

    importPath = mkOption {
      type = path;
      default = "${cfg.workingDir}/import";
      description = "path to directory containing imports";
    };

    storagePath = mkOption {
      type = path;
      default = "${cfg.workingDir}/storage";
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
      "d '${cfg.workingDir}' 0770 ${cfg.user} ${cfg.group} - -"
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
        PHOTOPRISM_ORIGINALS_PATH = cfg.originalsPath;
        PHOTOPRISM_IMPORT_PATH = cfg.importPath;
        PHOTOPRISM_STORAGE_PATH = cfg.storagePath;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.workingDir;
        ReadWritePaths = [ cfg.workingDir ];
        EnvironmentFile = [ cfg.environmentFile ];
        ExecStart = "${cfg.package}/bin/photoprism up";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
