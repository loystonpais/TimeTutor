{ pkgs, inputs, ... }:

with pkgs;

let
  # android-studio is not available in aarch64-darwin
  conditionalPackages = if pkgs.system != "aarch64-darwin" then [ /*android-studio*/ ] else [ ];
in
with pkgs;

# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "Flutter Project";
  motd = ''
    Entered the Flutter app development environment.
  '';
  env = [
    {
      name = "ANDROID_HOME";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "ANDROID_SDK_ROOT";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "JAVA_HOME";
      value = jdk.home;
    }
    {
      name ="CHROME_EXECUTABLE";
      value = "${pkgs.chromium}/bin/chromium";
    }
  ];
  commands = [
    {
      help = "run build runner (needed for json serializable)";
      name = "brb";
      command = "flutter pub run build_runner build --delete-conflicting-outputs";
    }
    {
      help = "builds and runs for web";
      name = "web";
      command = "flutter run -d chrome";
    }
    {
      help = "runs tests";
      name = "tests";
      command = "flutter test";
    }
  ];
  packages = [
    android-sdk
    gradle
    jdk

    inputs.self.packages.${pkgs.system}.flutter

  ] ++ conditionalPackages;
}