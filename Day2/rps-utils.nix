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

    # String -> Boolean TODO: I wonder if I could make them like Maybe's and chain them. Food for thought
    isAltLose = pipef [
        toLower
        (eq "x")
    ];
    isAltDraw = pipef [
        toLower
        (eq "y")
    ];
    isAltWin = pipef [
        toLower
        (eq "z")
    ];

    # These are the win and loss mappings for Part 2. TODO: This could replace Part 1 by producing an attrset mapping.
    altWinRock = "B";
    altWinPaper = "C";
    altWinScissors = "A";

    altLoseRock = "C";
    altLosePaper = "A";
    altLoseScissors = "B";

    rpsAltEval = player1: player2: let
        player2Rps = toRps player2 - 1;

        winChar = elemAt [ altWinRock altWinPaper altWinScissors ] player2Rps;
        drawChar = player2;
        loseChar = elemAt [ altLoseRock altLosePaper altLoseScissors ] player2Rps;
    in
        rpsEval (if isAltLose player1 then loseChar else if isAltDraw player1 then drawChar else winChar) player2;
in
    { inherit rpsEval rpsAltEval; }
