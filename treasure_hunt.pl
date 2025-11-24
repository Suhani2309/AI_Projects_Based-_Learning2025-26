% -----------------------------
% TREASURE HUNT AI GAME
% -----------------------------

:- dynamic agent/2.
:- dynamic treasure/2.
:- dynamic trap/2.
:- dynamic visited/2.

grid_size(4).

% Initial positions
agent(1,1).
treasure(3,4).
trap(4,2).

% -----------------------------
% HELPER RULES
% -----------------------------

inside_grid(X,Y) :-
    X >= 1, X =< 4,
    Y >= 1, Y =< 4.

adjacent(X1,Y1,X2,Y2) :-
    (X1 =:= X2, Y1 =:= Y2+1);
    (X1 =:= X2, Y1 =:= Y2-1);
    (X1 =:= X2+1, Y1 =:= Y2);
    (X1 =:= X2-1, Y1 =:= Y2).

clue(sparkle, X, Y) :-
    treasure(TX,TY),
    adjacent(X,Y,TX,TY).

clue(chill, X, Y) :-
    trap(TX,TY),
    adjacent(X,Y,TX,TY).

% -----------------------------
% GAME MESSAGES
% -----------------------------

show_clues(X,Y) :-
    ( clue(sparkle,X,Y) -> write('Clue: You feel a sparkle!'), nl ; true ),
    ( clue(chill,X,Y) -> write('Clue: You feel a chill!'), nl ; true ).

% -----------------------------
% MOVEMENT
% -----------------------------

move(up) :-
    agent(X,Y),
    Y2 is Y+1,
    inside_grid(X,Y2),
    retract(agent(X,Y)),
    assert(agent(X,Y2)),
    write('Moved up.'), nl,
    check_status.

move(down) :-
    agent(X,Y),
    Y2 is Y-1,
    inside_grid(X,Y2),
    retract(agent(X,Y)),
    assert(agent(X,Y2)),
    write('Moved down.'), nl,
    check_status.

move(left) :-
    agent(X,Y),
    X2 is X-1,
    inside_grid(X2,Y),
    retract(agent(X,Y)),
    assert(agent(X2,Y)),
    write('Moved left.'), nl,
    check_status.

move(right) :-
    agent(X,Y),
    X2 is X+1,
    inside_grid(X2,Y),
    retract(agent(X,Y)),
    assert(agent(X2,Y)),
    write('Moved right.'), nl,
    check_status.

move(_) :-
    write('Invalid move OR wall reached.'), nl.

% -----------------------------
% GAME STATUS
% -----------------------------

check_status :-
    agent(X,Y),
    ( treasure(X,Y) ->
        write('Congratulations! You found the treasure!'), nl
    ; trap(X,Y) ->
        write('Oh no! You fell into a trap! Game Over.'), nl
    ; show_clues(X,Y)
    ).

% -----------------------------
% START GAME
% -----------------------------

start :-
    write('--- TREASURE HUNT GAME STARTED ---'), nl,
    agent(X,Y),
    write('You are at position ('), write(X),write(','),write(Y),write(').'), nl,
    show_clues(X,Y),
    write('Available moves: move(up). move(down). move(left). move(right).'), nl.