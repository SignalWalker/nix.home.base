{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = [];
  config = {
    home.packages = with pkgs; [
      mosh
    ];
    systemd.user.tmpfiles.rules = [
      "D %t/ssh 0700 - -"
    ];
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPath = "$\{XDG_RUNTIME_DIR\}/ssh/socket-%r@%h:%p";
      controlPersist = "no";
      extraOptionOverrides = {
        Ciphers = "aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
      };
      matchBlocks = {
        "github.com" = {
          user = "git";
        };
        "gitlab.com" = {
          user = "git";
        };
        "git.ashwalker.net" = {
          user = "forgejo";
          hostname = "terra.ashwalker.net";
        };
        "hermes.lan" = {
          user = "root";
        };
        "ashwalker.net" = {
          hostname = "hermes.ashwalker.net";
        };
      };
    };
  };
}
