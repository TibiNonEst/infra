{ ... }:
{
  packages = final: _prev: import ../packages { pkgs = final; };
}
