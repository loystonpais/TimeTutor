{ pkgs, inputs, ... }:
with pkgs;
# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "Rust server";
  motd = ''
    Rust server using rocket
  '';
  env = [{
    name = "RUST_SRC_PATH";
    value = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  }];
  commands = [

  ];
  packages = [
    pkg-config
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "cargo" "rustc" ];
    })
    rust-analyzer
  ];
}
