let
    inherit (builtins) foldl';

    # uncurry :: (a -> b) -> [a] -> b
    uncurry = f: xs: foldl' (x: y: x y) f xs;
in
    { inherit uncurry; }
