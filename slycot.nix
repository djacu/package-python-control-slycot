{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  numpy,
  scikit-build,
  setuptools,
  setuptools-scm,
  wheel,
  gfortran12,
  blas,
  lapack,
}:

buildPythonPackage rec {
  pname = "slycot";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "Slycot";
    rev = "v${version}";
    hash = "sha256-YQsybl5LbBGzoeh9/pV5YIUxYVdbkkuPDpD8fHQm4O4=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-D CMAKE_MODULE_PATH=${scikit-build}/lib/python3.11/site-packages/skbuild/resources/cmake/"
    "-D BLAS_LIBRARIES=${blas}/lib/"
    "-D LAPACK_LIBRARIES=${lapack}/lib/liblapack"
  ];

  nativeBuildInputs = [
    cmake
    numpy
    scikit-build
    setuptools
    setuptools-scm
    wheel
    gfortran12
    #blas
    #lapack
  ];

  buildInputs = [
    blas
    lapack
  ];

  preBuild = ''
    cd /build/source
  '';

  propagatedBuildInputs = [
    numpy
    cmake
  ];

  pythonImportsCheck = [ "slycot" ];

  meta = with lib; {
    description = "Python wrapper for the Subroutine Library in Systems and Control Theory (SLICOT";
    homepage = "https://github.com/python-control/Slycot";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ djacu ];
  };
}
