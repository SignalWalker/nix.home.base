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
      settings = {
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no"; # FIX :: for some reason this forces it to ask for my password whenever i make an ssh connection; shouldn't the agent be unlocked at login...?
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "auto";
          ControlPath = "\${XDG_RUNTIME_DIR}/ssh/socket-%r@%h:%p";
          ControlPersist = "no";
        };
        "github.com" = {
          User = "git";
        };
        "gitlab.com" = {
          User = "git";
        };
        "git.ashwalker.net" = {
          User = "forgejo";
          Hostname = "terra.ashwalker.net";
        };
        "ashwalker.net" = {
          Hostname = "hermes.ashwalker.net";
        };
      };
    };
  };
}
