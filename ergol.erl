-module(ergol)

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

evolve(Gen1, Gen2, x, y) ->
    case get(Gen1, x, y) of
        1 -> live(Gen1, Gen2, x, y);
        0 -> dead(Gen1, Gen2, x, y).

dead(Gen1, Gen2, x, y) ->
    case neighbors(Gen1, x, y) of
        2 -> set(Gen2, x, y, 1);
        3 -> set(Gen2, x, y, 1);
        _ -> set(Gen2, x, y, 0).

live(Gen1, Gen2, x, y) ->
    case neighbors(Gen1, x, y) of
        3 -> set(Gen2, x, y, 1);
        _ -> set(Gen2, x, y, 0).            

neighbors(Gen, x, y) -> 
    % TODO
    0.

get(Gen, x, y) ->
    % TODO
    0. 

set(Gen, x, y, val) ->
    % TODO
    Gen.
