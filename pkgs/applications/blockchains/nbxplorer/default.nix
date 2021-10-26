{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "nbxplorer";
  version = "2.2.11";

  src = fetchFromGitHub {
    owner = "dgarage";
    repo = "NBXplorer";
    rev = "v${version}";
    sha256 = "sha256-ZDqzkANGMdvv3e5gWCYcacUYKLJRquXRHLr8RAzT9hY=";
  };

  projectFile = "NBXplorer/NBXplorer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.aspnetcore_3_1;

  postInstall = ''
    mv $out/bin/{NBXplorer,nbxplorer}
  '';

  meta = with lib; {
    description = "Minimalist UTXO tracker for HD Cryptocurrency Wallets";
    maintainers = with maintainers; [ kcalvinalvin earvstedt ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
