#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (builtins) map;
    inherit (import <nixpkgs/lib>) take;

    utils = import ../utils.nix;
    inherit (utils) lists strings args;
    inherit (utils.pipe) pipe pipef;

    input_file_contents = pipe input_file [ args.files.fromPath strings.strip ];

    # String -> [Int]
    toInventory = pipef [ strings.splitLines lists.toInts ];

    elf_invs = pipe input_file_contents [
        strings.groupLines
        (map toInventory)
        (map lists.total)
    ];

    sorted_invs = lists.sortMax elf_invs;

    top_three = take 3 sorted_invs;
in
    lists.total top_three
