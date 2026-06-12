{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "fakecompil" ''
      flags=(-Iinclude -c -pthread -fvisibility=hidden -O2 -fpic -fPIC -DHX_LINUX -DHXCPP_M64 -O2 -fpic -ansi -std=standard -fgnu89-inline -fno-asm -fno-builtin -fhosted -ffreestanding -fopenmp -fopenmp-simd -fms-extensions -fsigned-bitfields -fsigned-char -funsigned-bitfields -funsigned-char -trigraphs -traditional -traditional-cpp -ffriend-injection -fno-elide-constructors -fno-enforce-eh-specs -fno-for-scope -fno-gnu-keywords -fno-implicit-templates -fno-nonansi-builtins -fnothrow-opt -fno-operator-names -fpermissive -fno-pretty-templates -fno-rtti -fsized-deallocation -ftemplate-depth=1024 -fno-threadsafe-statics -fuse-cxa-atexit -fno-weak -nostdinc++ -fvisibility-inlines-hidden -Wabi=8 -Wconversion-null -Wctor-dtor-privacy -Wdelete-non-virtual-dtor -Wmultiple-inheritance -Wnamespaces -Wnarrowing -Wnoexcept -Wnon-virtual-dtor -Wreorder -Weffc++ -Wstrict-null-sentinel -Wno-non-template-friend -Wold-style-cast -Woverloaded-virtual -Wsign-promo)
      files=(./opengl/qglpixelbuffer.cpp ./opengl/qglshaderprogram.cpp ./opengl/gl2paintengineex/qglengineshadermanager.cpp ./opengl/gl2paintengineex/qpaintengineex_opengl2.cpp ./network/access/qnetworkreplyfileimpl.cpp ./network/access/qnetworkreply.cpp ./network/access/http2/huffman.cpp ./network/access/http2/http2frames.cpp ./network/ssl/qsslcontext_openssl.cpp ./network/ssl/qsslcertificateextension.cpp ./network/ssl/qsslcipher.cpp ./network/ssl/qsslkey_p.cpp ./network/ssl/qsslsocket_openssl.cpp ./network/ssl/qsslcertificate.cpp ./tools/moc/parser.cpp ./tools/moc/preprocessor.cpp ./tools/moc/generator.cpp ./tools/moc/main.cpp ./tools/uic/validator.cpp ./tools/uic/cpp/cppwritedeclaration.cpp ./tools/rcc/rcc.cpp ./tools/rcc/main.cpp)
      while true; do
        output="\033[33m\033[1mg++ \033[37m"
        nbFlags=$(( (RANDOM % 16) + 12 ))
        for i in $(seq 1 $nbFlags); do
          flag=$(( RANDOM % ''${#flags[@]} ))
          output="$output ''${flags[$flag]}"
        done
        file=$(( RANDOM % ''${#files[@]} ))
        output="$output ''${files[$file]} -c $(echo ''${files[$file]} | sed 's/.cpp$/.o/')"
        echo -e "$output"
        sleep $(( (RANDOM % 3) / ((RANDOM % 5) + 1) ))
      done
    '')

    (pkgs.writeShellScriptBin "cleandownloads" ''
      rm -f ~/Downloads/*.zip ~/Downloads/*.tar.gz ~/Downloads/*.tar.xz \
            ~/Downloads/*.tgz ~/Downloads/*.torrent ~/Downloads/*.rar \
            ~/Downloads/*.7z
    '')

    (pkgs.writeShellScriptBin "latex-clean" ''
      exts=".aux .lof .log .lot .fls .out .toc .dvi .bbl .bcf .blg -blx.aux -blx.bib .run.xml .fdb_latexmk .synctex.gz .pdfsync .nav .snm .vrb .acn .acr .glg .glo .gls .idx .ilg .ind .ist .maf .mtc .mtc0 .nlo .tdo .xdy"
      for x in "''${@:-.}"; do
        arg=$(echo "''${x:-.}" | sed 's/\.\(tex\|pdf\)$//')
        if [[ -d "$arg" ]]; then
          for ext in $exts; do rm -f "$arg"/*$ext; done
        else
          for ext in $exts; do rm -f "$arg"$ext; done
        fi
      done
    '')

    (pkgs.writeShellScriptBin "nap" ''
      killall electron
      echo "Napping for $1 minutes"
      sleep ''${1}m && ${pkgs.mpv}/bin/mpv ~/.local/res/alarm.mp4
      ferdium & disown
    '')

    # Note: tpad uses xinput (X11). May not work under Wayland.
    (pkgs.writeShellScriptBin "tpad" ''
      INPUTID=$(${pkgs.xinput}/bin/xinput list | grep ouchpad | sed -E 's/(.*)id=(.*)/\2/' | sed -E 's/(.*)\[(.*)/\1/')
      if [ -f ".tpadlock" ]; then
        rm .tpadlock
        ${pkgs.xinput}/bin/xinput enable $INPUTID
      else
        touch .tpadlock
        ${pkgs.xinput}/bin/xinput disable $INPUTID
      fi
    '')
  ];
}
