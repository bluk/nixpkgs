{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.gargantua;

  cfgService = {
    DynamicUser = true;
    User = cfg.user;
    Group = cfg.group;
    StateDirectory = "gargantua";
    StateDirectoryMode = "0750";
    LogsDirectory = "gargantua";
    LogsDirectoryMode = "0750";
  };
in
{
  meta.maintainers = with maintainers; [ bluk ];

  options.services.gargantua = {
    enable = mkEnableOption (lib.mdDoc "gargantua web app");

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gargantua;
      defaultText = lib.literalExpression "pkgs.gargantua";
      description = lib.mdDoc "Package to use.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        IPv4 address to bind to.
      '';
    };

    port = mkOption {
      default = 8080;
      type = types.port;
      description = lib.mdDoc ''
        TCP port used to listen on.
      '';
    };

    user = lib.mkOption {
      default = "gargantua";
      type = lib.types.str;
      description = lib.mdDoc ''
        User which the service will run as. If it is set to "gargantua", that
        user will be created.
      '';
    };

    group = lib.mkOption {
      default = "gargantua";
      type = lib.types.str;
      description = lib.mdDoc ''
        Group which the service will run as. If it is set to "gargantua", that
        group will be created.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gargantua = {
      after = [ "network.target" ];

      environment = {
        PORT = "${toString cfg.port}";
      };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/gargantua";
      } // cfgService;
    };

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "gargantua") {
        gargantua = {
          isSystemUser = true;
          home = cfg.package;
          inherit (cfg) group;
        };
      })
      (lib.attrsets.setAttrByPath [ cfg.user "packages" ] [ cfg.package ])
    ];
  };
}
