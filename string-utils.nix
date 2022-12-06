let
    inherit (import <nixpkgs/lib>) splitString removePrefix removeSuffix;
    inherit (import ./pipe.nix) pipef;

    # String -> String
    strip = pipef [ (removePrefix "\n") (removeSuffix "\n") ];

    # String -> [String]
    splitLines = splitString "\n";

    # String -> [String]
    groupLines = splitString "\n\n";
in
    { inherit strip splitLines groupLines; }
