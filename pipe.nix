let
    # a -> List[Function] -> <Last function's return type>
    pipe = (import <nixpkgs/lib>).pipe;

    # a -> List[Function] -> <Last function's return type>
    pipef = fs: x: pipe x fs;
in
    { inherit pipe pipef; }
