{ pkgs ? import ./nix { } }:
let
  inherit (pkgs)
    bash
    buildGoModule
    lib
    stdenv
    ;
in
buildGoModule rec {
  name = "direnv-${version}";
  version = lib.fileContents ./version.txt;
  subPackages = [ "." ];

  vendorSha256 = "sha256-YhgQUl9fdictEtz6J88vEzznGd8Ipeb9AYo/p1ZLz5k=";

  src = lib.cleanSource ./.;

  # FIXME: find out why there is a Go reference lingering
  allowGoReference = true;

  # we have no bash at the moment for windows
  makeFlags = lib.optional (!stdenv.hostPlatform.isWindows) [
    "BASH_PATH=${bash}/bin/bash"
  ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    description = "A shell extension that manages your environment";
    homepage = https://direnv.net;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
  };
}
