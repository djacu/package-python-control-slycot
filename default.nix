{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  matplotlib,
  numpy,
  scipy,
  cvxopt,
  #slycot,
  pytest,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "python-control";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "python-control";
    rev = version;
    hash = "sha256-T0op/0f9M4M9Djb8waX0MfUKLMi7jxbIYvqxeq2AjOw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
  ];

  passthru.optional-dependencies = {
    cvxopt = [ cvxopt ];
    #slycot = [ slycot ];
    test = [
      pytest
      pytest-timeout
    ];
  };

  pythonImportsCheck = [ "control" ];

  meta = with lib; {
    description = "The Python Control Systems Library is a Python module that implements basic operations for analysis and design of feedback control systems";
    homepage = "https://github.com/python-control/python-control";
    changelog = "https://github.com/python-control/python-control/blob/${src.rev}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
