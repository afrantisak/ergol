#!/usr/bin/env escript
-mode(compile).

main(_)->
    Output = [[0, 0, 0, 0, 0],
              [1, 0, 1, 1, 1],
              [1, 1, 1, 1, 1],
              [0, 1, 0, 0, 0],
              [0, 0, 0, 0, 0]],
    Input  = [[0, 1, 0, 0, 0],
              [1, 0, 0, 1, 1],
              [1, 1, 0, 0, 1],
              [0, 1, 0, 0, 0],
              [1, 0, 0, 0, 1]],
    Output = evolve(Input).

evolve(1, 2) -> 1;
evolve(_, 3) -> 1;
evolve(_, _) -> 0.

evolve(Board, Position, Size) ->
    evolve(get_value(Board, Position), neighbors(Board, Position, Size)).

evolve(Board) ->
    iterate(Board, fun evolve/3, {1, 1, l(n(1, Board)), l(Board)}).

iterate(Board, F, Size = {MinX, MinY, MaxX, MaxY}) ->
    [[ F(Board, {X, Y}, Size) || X <- r(MinX, MaxX)] || Y <- r(MinY, MaxY)].

neighbors(Board, P = {X, Y}, {MinX, MinY, MaxX, MaxY}) ->
    a([ 
       a(R) ||
           R <-
               iterate(Board,
                       fun(J, E, _) ->
                              get_value(J, E)
                       end,
                       {max(MinX, X - 1), max(MinY, Y - 1), min(MaxX, X + 1), min(MaxY, Y + 1)})
      ])
    -
    get_value(Board, P).

get_value(Board, {X, Y}) ->
    n(X, n(Y, Board)).

n(Index, List)->
    lists:nth(Index, List).

r(L,R)->
    lists:seq(L, R).

l(L)->
    length(L).

a(L)->
    lists:sum(L).
