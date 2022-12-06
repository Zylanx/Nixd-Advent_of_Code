#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (import <nixpkgs/lib>) splitString reverseList;
    rpsEval = import ./rps-utils.nix;
    utils = import ../utils.nix;
    inherit (utils) args lists;
    inherit (utils.strings) strip splitLines;
    inherit (utils.pipe) pipe;
    inherit (utils.funcs) uncurry;
    
in
    pipe input_file [
        args.files.fromPath
        strip
        splitLines
        (map (splitString " "))
        (map reverseList)
        (map (uncurry rpsEval))
        lists.total
    ]
