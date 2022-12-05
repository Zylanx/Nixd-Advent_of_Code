let
    lib = import <nixos/lib>;

    paths = rec {
        converter = rec {
            isPathArgCompatible = path: builtins.isString path || builtins.isPath path;

            pathArgTypeCheck = path: if builtins.isNull path
                then throw "Please provide a path using --arg or --argstr"
                else
                    if isPathArgCompatible path
                        then path
                        else throw "Invalid path arg type. Must be string or path";
        
            toPathArgString = path: builtins.toString (pathArgTypeCheck path);

            isAbsolute = path: lib.hasPrefix "/" (toPathArgString path);

            removeDotPrefix = path: lib.removePrefix "." path;

            toAbsolutePath = path: let
                    path_string = toPathArgString path;
                in
                    if isAbsolute path_string
                        then /. + path_string
                        else ./. + (removeDotPrefix path_string);
        };

        isPathArg = path: builtins.isAttrs path && path ? _type;

        toPathArg = path: let
                path_string = converter.toPathArgString path;
            in
                {
                    _type = "path_arg";

                    isAbsolute = converter.isAbsolute path_string;
                    path = path_string;
                    absolutePath = converter.toAbsolutePath path_string;
                };
    };

    files = {
        fromPath = path: let
                pathArg = paths.toPathArg path;
                
                doesExist = builtins.pathExists pathArg.absolutePath;
                # TODO: Existence checks
            in
                builtins.readFile pathArg.absolutePath;
    };
in
    { inherit paths files; }
