{ drv, pkgs }:
let
  exe = pkgs.lib.getExe staticDrv;
  staticDrv = drv.override { stdenv = pkgs.pkgsStatic.stdenv; };
  name = "${drv.name}-memfd_create-dropper";
in
pkgs.runCommand "${name}" {} ''
  cat ${./elfload.pl.1} > ${name}.pl
  ${pkgs.perl}/bin/perl -e '$/=\32;print"print \$FH pack q/H*/, q/".(unpack"H*")."/\ or die qq/write: \$!/;\n"while(<>)' ${exe} >> ${name}.pl
  cat ${./elfload.pl.2} >> ${name}.pl
  mv ${name}.pl $out
''
