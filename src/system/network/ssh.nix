{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = { };
  imports = [ ];
  config = {
    # TODO :: document this
    systemd.user.tmpfiles.rules = [
      "D %t/ssh 0700 - -"
    ];
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraOptionOverrides = {
        Ciphers = "aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
      };
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no"; # FIX :: for some reason this forces it to ask for my password whenever i make an ssh connection; shouldn't the agent be unlocked at login...?
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPath = "$\{XDG_RUNTIME_DIR\}/ssh/socket-%r@%h:%p";
          controlPersist = "no";
        };
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
        "ashwalker.net" = {
          hostname = "hermes.ashwalker.net";
        };
      };
    };
  };
}
