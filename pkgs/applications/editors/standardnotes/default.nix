{ stdenv, appimage-run, fetchurl }:

let

  version = "2.3.12";
  sources = let

  in {
    "${version}-x86_64-linux"  = fetchurl {
      url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-x86_64.AppImage";
      sha256 = "0myg4qv0vrwh8s9sckb12ld9f86ymx4yypvpy0w5qn1bxk5hbafc";
    };
    "${version}-i386-linux" = fetchurl {
      url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-i386.AppImage";
      sha256 = "0q7izk20r14kxn3n4pn92jgnynfnlnylg55brz8n1lqxc0dc3v24";
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
