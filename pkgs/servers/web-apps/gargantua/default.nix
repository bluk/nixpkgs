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

  # cargoSha256 = "sha256-kxYXTzQl1klMxYR1W+1dfDKAg+qWxBYydYXczu4ot7E=";
  cargoSha256 = lib.fakeSha256;

  meta = with lib; {
    description = "A test web server which returns 404s.";
    homepage = "https://github.com/bluk/gargantua";
    changelog = "https://github.com/bluk/gargantua/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bluk ];
  };
}
