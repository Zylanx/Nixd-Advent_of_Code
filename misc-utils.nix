let
    lib = import <nixpkgs/lib>;

    # a -> a -> Boolean
    isMax = x: y: x > y;

    # a -> a -> Boolean
    eq = x: y: x == y;
in
    { inherit isMax eq; }
