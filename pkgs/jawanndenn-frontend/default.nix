{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "jawanndenn-frontend";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "jawanndenn";
    rev = "${finalAttrs.version}";
    hash = "sha256-OBKOIFA589TPsRhO6Em/6SdkkbXGGYXgNOosiQzzF5s=";
  };

  sourceRoot = "${finalAttrs.src.name}/jawanndenn/frontend";
  npmDepsHash = "sha256-0PldJ8ym9BU5sdbIkr9UpOfdQJGt5Nf1phW+4X08o2s=";

  patchPhase = ''
    runHook prePatch
    substituteInPlace rsbuild.config.ts --replace-fail "root: '../'" "root: 'dist'"
    runHook postPatch
  '';

  installPhase = ''
    mkdir $out
    cp -r dist/* $out/
  '';

  meta = {
    description = "Frontend for self-hosted date poll service";
    homepage = "https://github.com/hartwork/jawanndenn";
  };
})
