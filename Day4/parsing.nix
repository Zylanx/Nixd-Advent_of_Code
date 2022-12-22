let
    inherit (builtins) elemAt;

    inherit (import <nixpkgs/lib>) range splitString toInt;

    utils = import ../utils.nix;
    inherit (utils.pipe) pipef;
    inherit (utils.funcs) uncurry;
    inherit (utils.strings) strip splitLines;


    # toElf :: String -> { start: Int; end: Int }
    toElf = pipef [
        (splitString "-")
        (map toInt)
        (x: { start = elemAt x 0; end = elemAt x 1; })
    ];

    # toPair :: String -> [{ start: Int; end: Int }]
    toPair = pipef [
        (splitString ",")
        (map toElf)
    ];

    # fromString :: String -> [[{ start: Int; end: Int }]]
    fromFile = pipef [
        strip
        splitLines
        (map toPair)
    ];
in
    fromFile
