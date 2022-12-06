let
    inherit (import <nixpkgs/lib>) elemAt toLower;
    utils = import ../utils.nix;
    inherit (utils.misc) eq;
    inherit (utils.pipe) pipe pipef;

    rock = 1;
    paper = 2;
    scissors = 3;

    # Int -> Boolean
    isRock = eq 1;
    isPaper = eq 2;
    isScissors = eq 3;

    # Int -> Int
    toRps = player: let
        lower = toLower player;
        _rock = if lower == "a" || lower == "x" then rock else 0;
        _paper = if lower == "b" || lower == "y" then paper else 0;
        _scissors = if lower == "c" || lower == "z" then scissors else 0;
    in
        _rock + _paper + _scissors;

    # Int -> Int -> Boolean
    rockWin = player1: player2: isRock player1 && isScissors player2;
    paperWin = player1: player2: isPaper player1 && isRock player2;
    scissorsWin = player1: player2: isScissors player1 && isPaper player2;

    # Int -> (Int -> Boolean)
    winEval = player: (elemAt [ rockWin paperWin scissorsWin ] (player - 1)) player;

    # Int -> Int -> Boolean
    drawEval = eq;

    # Int -> Int -> Int
    rpsEval = player1: player2: let
        player1Rps = toRps player1;
        player2Rps = toRps player2;
        
        winMap = map (f: f player1Rps player2Rps) [ drawEval winEval ];
    in
        player1Rps + (if elemAt winMap 0 then
            3
        else
            if elemAt winMap 1 then
                6
            else
                0);
in
    rpsEval
