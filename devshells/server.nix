{ pkgs, inputs, ... }:
with pkgs;
# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "Rust server";
  motd = ''
    Rust server using rocketf
  '';
  env = [
    {
      name = "RUST_SRC_PATH";
      value = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    }
  ];
  commands = [

  ];
  packages = [ cargo rustc gcc clippy rustfmt pkg-config rust-analyzer ];
}
