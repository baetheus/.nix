{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fossil;
in {
  options.services.fossil = with types; {
    enable = mkEnableOption "fossil scm service";

    package = mkOption {
      type = package;
      default = pkgs.fossil;
      defaultText = "pkgs.fossil";
      description = "The package to use for fossil";
    };

    git = mkOption {
      type = nullOr package;
      default = null;
      description = "The package to use for git";
    };

    path = mkOption {
      type = path;
      default = "/var/lib/fossil";
      description = "Path under which fossil should run";
    };

    repository = mkOption {
      type = str;
      default = ".";
      description = "Repository that fossil should serve, . allows for repolist";
    };

    user = mkOption {
      type = str;
      default = "fossil";
      description = "User account under which fossil runs.";
    };

    group = mkOption {
      type = str;
      default = "fossil";
      description = "Group associated which fossil runs.";
    };

    port = mkOption {
      type = port;
      default = 9000;
      description = "The port to listen on for tunnel traffic";
    };

    baseurl = mkOption {
      default = null;
      type = nullOr str;
      description = "Use URL as the base (useful for reverse proxies)";
    };

    https = mkOption {
      default = false;
      type = bool;
      description = "Indicates that the input is coming through a reverse proxy that has already translated HTTPS into HTTP.";
    };

    maxLatency = mkOption {
      default = 10;
      type = int;
      description = "Do not let any single HTTP request run for more than N seconds (only works on unix)";
    };

    repolist = mkOption {
      default = false;
      type = bool;
      description = "If REPOSITORY is dir, URL \"/\" lists repos.";
    };

    scgi = mkOption {
      default = false;
      type = bool;
      description = "Accept SCGI rather than HTTP";
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Open firewall if we want that
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    # Make fossil available systemwide for creation of new repos
    environment.systemPackages = [ cfg.package ];

    # Create the user if it is default
    users.users = mkIf (cfg.user == "fossil") {
      fossil = {
        description = "Fossil Service";
        home = cfg.path;
        useDefaultShell = true;
        group = "fossil";
        isSystemUser = true;
      };
    };

    # Create the group if it is default
    users.groups = mkIf (cfg.group == "fossil") {
      fossil = {};
    };

    # Configure systemd
    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.rules = [
      "d '${cfg.path}' 0770 ${cfg.user} ${cfg.group} - -"
    ];
    systemd.services.fossil = {
      description = "fossil server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package cfg.git ];

      serviceConfig =  {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.path;
        ReadWritePaths = [ cfg.path ];
        ExecStart = "${cfg.package}/bin/fossil server"
         + " --port ${toString cfg.port}"
         + optionalString cfg.https " --https"
         + optionalString cfg.scgi " --scgi"
         + optionalString cfg.repolist " --repolist"
         + optionalString (cfg.baseurl != null) " --baseurl ${cfg.baseurl}"
         + optionalString (cfg.maxLatency > 0) " --max-latency ${toString cfg.maxLatency}"
         + " ${cfg.repository}";
        Restart = "always";
        RestartSec = 3;
      };

    };
  };
}

