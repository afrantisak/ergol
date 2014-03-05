-module(ergol).

-export([main/0]).

main() ->
    Gen1 = [[0, 1, 0, 0, 0],
            [1, 0, 0, 1, 1],
            [1, 1, 0, 0, 1],
            [0, 1, 0, 0, 0],
            [1, 0, 0, 0, 1]],
    Gen2 = [[0, 0, 0, 0, 0],
            [1, 0, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [0, 1, 0, 0, 0],
            [0, 0, 0, 0, 0]],
    Gen2 = evolve(Gen1),
    io:format("Passed~n").
    
evolve(Gen1) ->
    evolve(Gen1, Gen1, 0, 0).

evolve(Gen1, Gen2, X, Y) ->
    case get(Gen1, X, Y) of
        1 -> live(Gen1, Gen2, X, Y);
        0 -> dead(Gen1, Gen2, X, Y)
    end.

dead(Gen1, Gen2, X, Y) ->
    case neighbors(Gen1, X, Y) of
        2 -> set(Gen2, X, Y, 1);
        3 -> set(Gen2, X, Y, 1);
        _ -> set(Gen2, X, Y, 0)
    end.

live(Gen1, Gen2, X, Y) ->
    case neighbors(Gen1, X, Y) of
        3 -> set(Gen2, X, Y, 1);
        _ -> set(Gen2, X, Y, 0)
    end.

neighbors(_Gen, _X, _Y) -> 
    0. % TODO

get(Gen, X, Y) ->
    lists:nth(X, lists:nth(Y, Gen)).

set(Gen, X, Y, val) ->
    replace(Y, replace(X, val, lists:nth(Y, Gen)), Gen).

replace(Index, Value, List) ->
    {Left, [_ | Right]} = lists:split(Index, List),
    lists:flatten([Left, Value, Right]).