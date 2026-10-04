{
  description = "TinyML playground: a playground for experimenting with TinyML and related topics";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      # Current nixpkgs no longer supports Intel macOS.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          name = "tinyml-playground-dev";

          packages = with pkgs; [
            python314
            uv
            gnumake
            stdenv.cc
            cmake
            ninja
          ];

          UV_PYTHON = "${pkgs.python314}/bin/python3";
          UV_PYTHON_DOWNLOADS = "never";

          # Native wheels need runtime libraries and access to the host GPU driver.
          shellHook = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
            CUDA_DRIVER_DIR="''${TMPDIR:-/tmp}/nix-cuda-libs"
            mkdir -p "$CUDA_DRIVER_DIR"
            for lib in /usr/lib/x86_64-linux-gnu/libcuda* /usr/lib/x86_64-linux-gnu/libnvidia* /usr/lib/aarch64-linux-gnu/libcuda* /usr/lib/aarch64-linux-gnu/libnvidia*; do
              [ -e "$lib" ] && ln -sf "$lib" "$CUDA_DRIVER_DIR/"
            done
            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.stdenv.cc.cc.lib
                pkgs.zlib
                pkgs.jemalloc
              ]
            }:/run/opengl-driver/lib:/usr/lib/wsl/lib:$CUDA_DRIVER_DIR''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          '';
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
