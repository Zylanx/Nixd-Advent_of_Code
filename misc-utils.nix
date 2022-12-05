let
    lib = import <nixpkgs/lib>;

    isMax = x: y: x > y;
in
    { inherit isMax; }
