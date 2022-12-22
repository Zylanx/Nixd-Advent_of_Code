let
    inherit (builtins) foldl' map sort length;
    lib = import <nixpkgs/lib>;
    inherit (lib) take drop range;
    misc = import ./misc-utils.nix;

    # [Int] -> Int
    total = foldl' builtins.add 0;

    # [Int] -> Int
    max = foldl' lib.max 0;

    # [Int] -> [Int]
    sortMax = sort misc.isMax;
    
    # [String] -> [Int]
    toInts = map lib.toInt;

    # partition :: Int -> [a] -> [[a]]
    partition = number: list: let
        size = ((length list) / number);
        partitions = range 0 (number - 1);
    in
        map (x: lib.sublist (x * size) ((x + 1) * size) list) partitions;

    # Int -> [a] -> [[a]]
    groupN = size: list:
    assert lib.mod (length list) size == 0;
    if length list >= 3 then
        [(take 3 list)] ++ (groupN size (drop 3 list))
    else
        [];

    # (a -> a -> b) -> [a] -> [b]
    foldl'Skip = op: list: let
        func = a: b: if builtins.isNull a then b else op a b;
    in
        foldl' func null list;
in
    { inherit total max sortMax toInts partition groupN foldl'Skip; }
