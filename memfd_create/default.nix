{ drv, pkgs }:
let
  exe = pkgs.lib.getExe staticDrv;
  staticDrv =
    if drv.stdenv.hostPlatform.isStatic == false
      then throw ''
        The package "${drv.name}" needs to be static, try pkgsStatic
        Example: nix bundle --bundler github:matthewcroughan/nix-dropper-bundle#memfd_create nixpkgs#pkgsStatic.hello"
      ''
    else drv;
  name = "${drv.name}-memfd_create-dropper";
in
pkgs.runCommand "${name}" {} ''
  cat ${./elfload.pl.1} > ${name}.pl
  ${pkgs.perl}/bin/perl -e '$/=\32;print"print \$FH pack q/H*/, q/".(unpack"H*")."/\ or die qq/write: \$!/;\n"while(<>)' ${exe} >> ${name}.pl
  cat ${./elfload.pl.2} >> ${name}.pl
  mv ${name}.pl $out
''
