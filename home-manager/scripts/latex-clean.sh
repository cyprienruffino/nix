exts=".aux .lof .log .lot .fls .out .toc .dvi .bbl .bcf .blg -blx.aux -blx.bib .run.xml .fdb_latexmk .synctex.gz .pdfsync .nav .snm .vrb .acn .acr .glg .glo .gls .idx .ilg .ind .ist .maf .mtc .mtc0 .nlo .tdo .xdy"
for x in "${@:-.}"; do
  arg=$(echo "${x:-.}" | sed 's/\.\(tex\|pdf\)$//')
  if [[ -d "$arg" ]]; then
    for ext in $exts; do rm -f "$arg"/*$ext; done
  else
    for ext in $exts; do rm -f "$arg"$ext; done
  fi
done
