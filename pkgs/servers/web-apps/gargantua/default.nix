{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "gargantua";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bluk";
    repo = "gargantua";
    rev = "v${version}";

    # nix-shell -p nix-prefetch-github git
    # nix-prefetch-github bluk gargantua --rev <sha of revision>

    sha256 = "sha256-lCEJWjjO65dPeRBHS2VO2MOAt8O0QZVHdYFvcnsIskI=";
  };

  # Use:
  # cargoSha256 = lib.fakeSha256;
  # initially and then build the package. Get the correct value from
  # the error message.
  cargoSha256 = "sha256-s3s1YmXoFyQNuodMYbrSH9hXtIs3J6fcs6qWigt2lFw=";

  meta = with lib; {
    description = "A test web server which returns 404s.";
    homepage = "https://github.com/bluk/gargantua";
    changelog = "https://github.com/bluk/gargantua/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bluk ];
  };
}
