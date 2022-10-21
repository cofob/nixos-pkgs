{ lib
, pkgs
, msaClientID ? ""
}:

pkgs.stdenv.mkDerivation rec {
  pname = "UltimMC";
  version = "0.6.12";
  desktopItem = (pkgs.makeDesktopItem {
    name = pname;
    desktopName = "Minecraft";
    exec = pname;
    icon = pname;
    categories = [ "Game" ];
  });

  src = pkgs.fetchFromGitHub {
    owner = "cofob";
    repo = "UltimMC";
    rev = "9575ba078b603f0fe05723220cbbf56e1623f24f";
    sha256 = "sha256-nPIivZSFTbIvZxhq0hmW4j/6NXtRpwS+prdwqcyalHY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with pkgs; [ cmake file makeWrapper ];
  buildInputs = with pkgs; [ qt5.qtbase jdk zlib ];

  postPatch = ''
    # hardcode jdk paths
    substituteInPlace launcher/java/JavaUtils.cpp \
      --replace 'scanJavaDir("/usr/lib/jvm")' 'javas.append("${pkgs.jdk}/lib/openjdk/bin/java")' \
      --replace 'scanJavaDir("/usr/lib32/jvm")' 'javas.append("${pkgs.jdk8}/lib/openjdk/bin/java")'
  '';

  cmakeFlags = [ "-DLauncher_PORTABLE=0" ] ++
    lib.optionals (msaClientID != "") [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ];

  dontWrapQtApps = true;

  postInstall =
    let
      libpath = with pkgs; lib.makeLibraryPath [
        xorg.libX11
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXxf86vm
        libpulseaudio
        libGL
        glfw
        openal
      ];
    in
    ''
      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      wrapProgram $out/bin/${pname} \
        "''${qtWrapperArgs[@]}" \
        --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} \
        --prefix PATH : ${lib.makeBinPath [ pkgs.xorg.xrandr ]}
      mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
      install -Dm644 $src/launcher/resources/multimc/256x256/minecraft.png $out/share/icons/hicolor/256x256/apps/${pname}.png
      install -Dm644 ${desktopItem}/share/applications/* $out/share/applications
    '';

  meta = with lib; {
    homepage = "https://github.com/UltimMC/Launcher";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    changelog = "https://github.com/UltimMC/Launcher/commit/${version}";
    license = licenses.gpl3Plus;
  };
}
