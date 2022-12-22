#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (import <nixpkgs/lib>) elemAt count;

    utils = import ../utils.nix;
    inherit (utils) args;
    inherit (utils.pipe) pipe;

    parse = import ./parsing.nix;

    # ranges :: [[{ start: Int; end: Int }]]
    ranges = pipe input_file [
        args.files.fromPath
        parse
    ];

    # isSubset :: [{ start: Int; end: Int }] -> Bool
    isSubset = pairs: let
        elf1 = elemAt pairs 0;
        elf2 = elemAt pairs 1;
    in
        (elf1.start >= elf2.start && elf1.end <= elf2.end) || (elf2.start >= elf1.start && elf2.end <= elf1.end);

    subsets = count isSubset ranges; 
in
    subsets
