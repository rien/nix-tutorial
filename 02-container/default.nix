let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in rec {
  zinc = pkgs.callPackage ../01-package/package.nix { };

  zinc-image = pkgs.dockerTools.buildImage {
    name = "zinc";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = [ zinc ];
      pathsToLink = [ "/bin" ];
    };

    config = {
      Cmd = [ "/bin/zinc" ];
    };
  };

  load-image = pkgs.writeShellScriptBin "load-image" ''
    docker load < ${zinc-image}
  '';
}
