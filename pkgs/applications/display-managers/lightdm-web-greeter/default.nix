{ stdenv, appimage-run, fetchFromGitHub,
  #meson, pkgconfig, dbus-glib, lightdm, x11, gtk3-x11, webkitgtk
  }:

let

  version = "3.0.0rc2";

in

  stdenv.mkDerivation rec {
    name = "lightdm-web-greeter-${version}";
    src = fetchFromGitHub {
      owner = "antergos";
      repo = "web-greeter";
      rev = "${version}";
      sha256 = "1mhqnvc77m483sm4mj08qq1gzidkfkgn7xhaj3dgs65lndsxrwnn";
    };

    #buildInputs = [ meson pkgconfig dbus-glib lightdm x11 gtk3-x11 webkitgtk ];

    # Patch shebang and set correct variables in utils.sh
    # Set correct permissions
    preBuild = ''
      patchShebangs build/utils.sh
      sed -i 's~REPO_DIR=~REPO_DIR="$src" #~g' build/utils.sh
      sed -i 's~BUILD_DIR=~BUILD_DIR="$src" #~g' build/utils.sh
      sed -i 's~INSTALL_ROOT=~INSTALL_ROOT="$out" #~g' build/utils.sh
    '';


    #buildPhase = ''
    #  BASH_SOURCE[0] = "test" && meson --prefix=/usr --libdir=lib ..
    #  ninja
    #'';

    meta = with stdenv.lib; {
      description = "A modern, visually appealing greeter for LightDM.";
      homepage = https://antergos.github.io/web-greeter/;
      license = licenses.agpl3;
      maintainers = with maintainers; [ mgregoire ];
    };
  }
