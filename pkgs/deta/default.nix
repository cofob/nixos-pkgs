{ stdenv, fetchzip, lib, ... }:

stdenv.mkDerivation rec {
  pname = "deta-cli";
  version = "1.3.3-beta";

  src = fetchzip {
    url = "https://github.com/deta/${pname}/releases/download/v${version}/deta-x86_64-linux.zip";
    sha256 = "sha256-7d80q6tmPEW0Wlf9Cmczc2a7rtNkadAWTEF+F+Om950=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/deta $out/bin/deta
    chmod u+x $out/bin/deta
  '';

  meta = with lib; {
    description = "The Deta CLI tool provides a number of helpful commands to help you with your Deta development.";
    homepage = "https://github.com/deta/deta-cli";
    license = licenses.mit;
  };
}
