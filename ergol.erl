#!/usr/bin/env escript
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

e(1, 2) -> 1;
e(_, 3) -> 1;
e(_, _) -> 0.

evolve(I) ->
    iterate(I,
            fun(J, P, S) ->
                   e(get_value(J, P), neighbors(J, P, S))
            end,
            {1, 1, l(n(1, I)), l(I)}).


iterate(I, F, S = {A, B, C, D}) ->
    [[ F(I, {X, Y}, S) || X <- r(A, C)] || Y <- r(B, D)].

neighbors(I, P = {X, Y}, {A, B, C, D}) ->
    a([ 
       a(R) ||
           R <-
               iterate(I,
                       fun(J, E, _) ->
                              get_value(J, E)
                       end,
                       {max(A, X - 1), max(B, Y - 1), min(C, X + 1), min(D, Y + 1)})
      ])
    -
    get_value(I, P).

get_value(I, {X, Y}) ->
    n(X, n(Y, I)).

n(I,L)->
    lists:nth(I, L).

r(L,R)->
    lists:seq(L, R).

l(L)->
    length(L).

a(L)->
    lists:sum(L).
