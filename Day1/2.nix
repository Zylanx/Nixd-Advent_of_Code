#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (builtins) map foldl';
    inherit (import <nixpkgs/lib>) take;

    utils = import ../utils.nix;
    inherit (utils) lists strings misc args;
    inherit (utils.pipe) pipef;

    input_file_contents = pipef [ args.files.fromPath strings.strip ] input_file;

    # String -> [Int]
    toInventory = pipef [ strings.splitLines lists.toInts ];

    # [Int] -> Ints
    totalInventory = lists.total;

    elf_invs = map (pipef [ toInventory totalInventory ]) (strings.groupLines input_file_contents);

    sorted_invs = lists.sortMax elf_invs;

    top_three = take 3 sorted_invs;

    totalled = lists.total top_three;
in
    totalled
