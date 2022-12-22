#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (import <nixpkgs/lib>) unique intersectLists flatten stringToCharacters;

    utils = import ../utils.nix;
    inherit (utils) args;
    inherit (utils.lists) total groupN foldl'Skip;
    inherit (utils.pipe) pipe pipef;
    inherit (utils.funcs) uncurry;
    inherit (utils.strings) strip splitLines;

    rucksack_utils = import ./rs_utils.nix;

    # [[[Char]]]
    rucksacks = pipe input_file [
        args.files.fromPath
        strip
        splitLines
        (map stringToCharacters)
        (groupN 3)
    ];

    # [[[Char]]] -> [Char]
    intersect = pipef [
        (map (
            pipef [
                (foldl'Skip intersectLists)
                unique
            ])
        )
        flatten
    ];

    # [Chars]
    intersectedRucksacks = intersect rucksacks;

    # [Int]
    priorities = map rucksack_utils.toPriority intersectedRucksacks;
in
    total priorities
