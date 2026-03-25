{
  fetchFromGitHub,
  gunicorn,
  lib,
  python,
  setuptools,
  termcolor,
  ...
}:
python.pkgs.buildPythonPackage rec {
  pname = "gunicorn_color";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "swistakm";
    repo = "gunicorn-color-logger";
    rev = "${version}";
    hash = "sha256-7Uy7DyF/GR8j46JmdfWCxPm9m7sSJZTsoy2Rlu1VNgA=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    termcolor
  ];

  nativeCheckInputs = [
    gunicorn
  ];
  pythonImportsCheck = [ "gunicorn_color" ];

  pyproject = true;

  meta = {
    description = "Gunicorn access loger with termcolor support";
    homepage = "https://github.com/swistakm/gunicorn-color-logger";
  };
}
