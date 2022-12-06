let
    inherit (builtins) foldl' map sort;
    lib = import <nixpkgs/lib>;
    misc = import ./misc-utils.nix;

    # [Int] -> Int
    total = foldl' builtins.add 0;

    # [Int] -> Int
    max = foldl' lib.max 0;

    # [Int] -> [Int]
    sortMax = sort misc.isMax;
    
    # [String] -> [Int]
    toInts = map lib.toInt;
in
    { inherit total max sortMax toInts; }
