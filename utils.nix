let
    arg-utils = import ./arg-utils.nix;
    list-utils = import ./list-utils.nix;
    misc-utils = import ./misc-utils.nix;
    pipe = import ./pipe.nix;
    string-utils = import ./string-utils.nix;
in
    {
        args = arg-utils;
        lists = list-utils;
        misc = misc-utils;
        pipe = pipe;
        strings = string-utils;
    }
