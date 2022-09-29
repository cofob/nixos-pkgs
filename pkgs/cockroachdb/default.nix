{ lib, stdenv, buildGoPackage, fetchurl
, cmake, xz, which, autoconf
, ncurses6, libedit, libunwind
, installShellFiles
, removeReferencesTo, go
}:

let
  darwinDeps = [ libunwind libedit ];
  linuxDeps  = [ ncurses6 ];

  buildInputs = if stdenv.isDarwin then darwinDeps else linuxDeps;
  nativeBuildInputs = [ installShellFiles cmake xz which autoconf ];

in
buildGoPackage rec {
  pname = "cockroach";
  version = "21.1.21";

  goPackagePath = "github.com/cockroachdb/cockroach";

  src = fetchurl {
    url = "https://binaries.cockroachdb.com/cockroach-v${version}.src.tgz";
    sha256 = "19az6fgc1qrh39yyxhgkksgkk38dn0xrrh3dhx1ibhqwhvx80gdb";
  };

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-Wno-error=deprecated-copy" "-Wno-error=redundant-move" "-Wno-error=pessimizing-move" ];

  inherit nativeBuildInputs buildInputs;

  buildPhase = ''
    runHook preBuild
    cd $NIX_BUILD_TOP/go/src/${goPackagePath}
    patchShebangs .
    make buildoss
    cd src/${goPackagePath}
    for asset in man autocomplete; do
      ./cockroachoss gen $asset
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D cockroachoss $out/bin/cockroach
    installShellCompletion cockroach.bash

    mkdir -p $man/share/man
    cp -r man $man/share/man

    runHook postInstall
  '';

  outputs = [ "out" "man" ];

  # fails with `GOFLAGS=-trimpath`
  allowGoReference = true;
  preFixup = ''
    find $out -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${go} '{}' +
  '';

  meta = with lib; {
    homepage    = "https://www.cockroachlabs.com";
    description = "A scalable, survivable, strongly-consistent SQL database";
    platforms   = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
