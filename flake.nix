{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      control =
        with pkgs.python3Packages;
        buildPythonPackage rec {
          pname = "control-toolbox";
          version = "0.10.0";
          pyproject = true;

          src = pkgs.fetchFromGitHub {
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
            numpy
            scipy
            matplotlib
          ];
        };

      control-init = pkgs.callPackage ./default.nix {
        buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
        cvxopt = pkgs.python3Packages.cvxopt;
        matplotlib = pkgs.python3Packages.matplotlib;
        slycot = slycot;
        numpy = pkgs.python3Packages.numpy;
        scipy = pkgs.python3Packages.scipy;
        pytest = pkgs.python3Packages.pytest;
        pytest-timeout = pkgs.python3Packages.pytest-timeout;
        setuptools = pkgs.python3Packages.setuptools;
        setuptools-scm = pkgs.python3Packages.setuptools-scm;
        wheel = pkgs.python3Packages.wheel;
      };

      slycot = pkgs.callPackage ./slycot.nix {
        buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
        numpy = pkgs.python3Packages.numpy;
        setuptools = pkgs.python3Packages.setuptools;
        setuptools-scm = pkgs.python3Packages.setuptools-scm;
        wheel = pkgs.python3Packages.wheel;
        scikit-build = pkgs.python3Packages.scikit-build;
        gfortran12 = pkgs.gfortran12;
        blas = pkgs.blas;
        lapack = pkgs.lapack;
      };
    in

    {
      packages.x86_64-linux = {
        inherit control control-init slycot;
      };
      devShells.x86_64-linux = {
        test = pkgs.mkShellNoCC {
          packages = [
            (pkgs.python3.withPackages (ps: [
              ps.numpy
              ps.matplotlib
              control-init
              #slycot
            ]))
          ];
        };
      };
    };
}
