#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (builtins) map foldl' add sort;
    inherit (import <nixpkgs/lib>) splitString toInt removeSuffix removePrefix take;
    
    arg-utils = import ../arg-utils.nix;
    list-utils = import ../list-utils.nix;
    misc-utils = import ../misc-utils.nix;
    
    input_file_contents = arg-utils.files.fromPath input_file;

    # string -> list[int]
    toInventory = string: map toInt (splitString "\n" (removeSuffix "\n" (removePrefix "\n" string)));
    # list[int] -> int
    totalInventory = foldl' add 0;

    elf_invs = map (inventory: totalInventory (toInventory inventory)) (splitString "\n\n" input_file_contents);

    sorted_invs = sort misc-utils.isMax elf_invs;

    top_three = take 3 sorted_invs;

    totalled = foldl' add 0 top_three;
in
    totalled
