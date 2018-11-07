{stdenv, appimage-run, fetchFromGitHub}:

let

  version = "2.3.11";
  sources = let

  in {
    "${version}-x86_64-linux"  = fetchFromGitHub {
      owner = "standardnotes";
      repo = "desktop";
      rev = "d6bf99d81a8e512a280f7faf7a367aff0eae47ac";
      sha256 = "1zbkmxsipmprrbgjmszg33w7cqs5v5zrcwknkqwybj9q41addsql";
    };
    "${version}-i386-linux" = fetchFromGitHub {
      owner = "standardnotes";
      repo = "desktop";
      rev = "d6bf99d81a8e512a280f7faf7a367aff0eae47ac";
      sha256 = "dbd2ddc01827b1ebd1bbaa4d9cb77a09498bcf3e6a5372cc75f7f82b52b0307f";
    };
  };

in

stdenv.mkDerivation rec {

  name = "standardNotes-${version}";

  src = sources."${version}-${stdenv.hostPlatform.system}" or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

  buildInputs = [ appimage-run  ];

  phases = " installPhase";

   installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/standardNotes.AppImage
    echo "#!/bin/sh" > $out/bin/standardnotes
    echo "${appimage-run}/bin/appimage-run $out/share/standardNotes.AppImage" >> $out/bin/standardnotes
    chmod +x $out/bin/standardnotes $out/share/standardNotes.AppImage
   '';


  meta = with stdenv.lib; {
    description = "A Simple And Private Notes App";
    longDescription = "Standard Notes is a private notes app that features unmatched simplicity, end-to-end encryption, powerful extensions, and open-source applications.";
    homepage = https://standardnotes.org;
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
