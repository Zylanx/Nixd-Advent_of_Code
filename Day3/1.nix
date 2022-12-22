#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (import <nixpkgs/lib>) unique intersectLists flatten;

    utils = import ../utils.nix;
    inherit (utils) args;
    inherit (utils.strings) strip splitLines
    inherit (utils.pipe) pipe pipef;
    inherit (utils.funcs) uncurry;

    rucksack_utils = import ./rs_utils.nix;

    # [[[Char]]] -> [Char]
    intersect = pipef [
        (map (pipef [
                (uncurry intersectLists)
                unique
        ]))
        flatten
    ];

    # [[[Char]]]
    rucksacks = pipe input_file [
        args.files.fromPath
        rucksack_utils.toRucksacks
        intersect
    ];

    # [Int]
    priorities = map rucksack_utils.toPriority rucksacks;
in
    utils.lists.total priorities
