{
  fetchFromGitHub,
  jawanndenn-frontend,
  lib,
  python3,
  ...
}:
let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "jawanndenn";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "jawanndenn";
    rev = "${version}";
    hash = "sha256-OBKOIFA589TPsRhO6Em/6SdkkbXGGYXgNOosiQzzF5s=";
  };

  postUnpack = ''
    cp -r ${jawanndenn-frontend}/* source/jawanndenn/
  '';

  patchPhase = ''
    runHook prePatch

    substituteInPlace jawanndenn/__main__.py --replace-fail \
    'os.environ["JAWANNDENN_ALLOWED_HOSTS"] = ",".join(
            [options.host, "127.0.0.1", "0.0.0.0", "localhost"]
        )' \
    'os.environ.setdefault(
            "JAWANNDENN_ALLOWED_HOSTS",
            ",".join([options.host, "127.0.0.1", "0.0.0.0", "localhost"])
        )'

    runHook postPatch
  '';

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    django
    django-extensions
    django-ratelimit
    django-redis
    djangorestframework
    gunicorn
    gunicorn_color
    python-dateutil
    python-rapidjson
    pyyaml
  ];

  pythonImportsCheck = [ "jawanndenn" ];

  pyproject = true;

  passthru.pythonPath = "${python.pkgs.makePythonPath dependencies}:${placeholder "out"}/${python.sitePackages}";
  makeWrapperArgs = [
    "--prefix PYTHONPATH : ${passthru.pythonPath}"
  ];

  meta = {
    description = "Self-hosted date poll service";
    homepage = "https://github.com/hartwork/jawanndenn";
  };
}
