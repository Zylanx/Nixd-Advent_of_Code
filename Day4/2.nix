#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (builtins) length;
    inherit (import <nixpkgs/lib>) elemAt count range intersectLists;

    utils = import ../utils.nix;
    inherit (utils) args;
    inherit (utils.pipe) pipe pipef;
    inherit (utils.funcs) uncurry;

    parse = import ./parsing.nix;


    # ranges :: [[{ start: Int; end: Int }]]
    ranges = pipe input_file [
        args.files.fromPath
        parse
    ];

    # rangeLists :: [([Int] [Int])]
    rangeLists = (map (map (x: range x.start x.end))) ranges;

    # isIntersect :: ([Int] [Int]) -> Bool
    isIntersect = pair: length (uncurry intersectLists pair) > 0;
in
    count isIntersect rangeLists
