{
  ...
}:
{
  config = {
    systemd.user.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };
}
