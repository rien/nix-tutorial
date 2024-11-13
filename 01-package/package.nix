{
  vlang,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "zinc";
  version = "0.0.0";
  src = builtins.fetchGit {
    url = "https://github.com/ZeusWPI/zinc.git";
    ref = "master";
    rev = "86dbe69c118e81baf0aa58ade5a2c0cd85cd0efa";
  };

  buildInputs = [ vlang ];

  buildPhase = ''
    VMODULES=/tmp v src/main.v
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/main $out/bin/zinc
  '';
}
