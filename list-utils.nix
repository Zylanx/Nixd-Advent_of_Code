let
    lib = import <nixpkgs/lib>;
    inherit (builtins) foldl';

    max = foldl' lib.max 0;
in
    { inherit max; }
