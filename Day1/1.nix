#!/usr/bin/env -S nix-instantiate --eval --strict --arg nothing null
{ input_file ? null }:
let
    inherit (builtins) map foldl' add;
    inherit (import <nixpkgs/lib>) splitString toInt removeSuffix removePrefix;
    arg-utils = import ../arg-utils.nix;
    list-utils = import ../list-utils.nix;
    
    input_file_contents = arg-utils.files.fromPath input_file;

    # string -> list[int]
    toInventory = string: map toInt (splitString "\n" (removeSuffix "\n" (removePrefix "\n" string)));
    # list[int] -> int
    totalInventory = foldl' add 0;

    elf_inventories = map (inventory: totalInventory (toInventory inventory)) (splitString "\n\n" input_file_contents);

    max_calouries = list-utils.max elf_inventories;
in
    max_calouries
