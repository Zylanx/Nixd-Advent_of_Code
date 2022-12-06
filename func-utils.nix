let
    inherit (builtins) foldl';

    uncurry = f: xs: foldl' (x: y: x y) f xs;
in
    { inherit uncurry; }
