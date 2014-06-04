-module(ergol).

-export([main/0]).

% "Game of Life".
% The input will be a game board of cells, either alive (1) or dead (0).
% The code should take this board and create a new board for the
% next generation based on the following rules:
%  1) Any live cell with fewer than two live neighbours dies (under-population)
%  2) Any live cell with two or three live neighbours lives on to
%     the next generation (survival)
%  3) Any live cell with more than three live neighbours dies (overcrowding)
%  4) Any dead cell with exactly three live neighbours becomes a live cell (reproduction)

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
    evolve(Gen1, Gen1, 1, 1, 5, 5).

evolve(Gen1, Gen2, X, Y, MaxX, MaxY) ->
    Gen3 = case get(Gen1, X, Y) of
               1 -> live(Gen1, Gen2, X, Y);
               0 -> dead(Gen1, Gen2, X, Y)
           end,
    case Y of
        MaxY -> 
            case X of
                MaxX ->
                    Gen3;
                _ ->
                    evolve(Gen1, Gen3, X + 1, 1, MaxX, MaxY)
            end;
        _ ->
            evolve(Gen1, Gen3, X, Y + 1, MaxX, MaxY)
    end.

live(Gen1, Gen2, X, Y) ->
    case neighbors(Gen1, X, Y) of
        2 -> set(Gen2, X, Y, 1);
        3 -> set(Gen2, X, Y, 1);
        _ -> set(Gen2, X, Y, 0)
    end.

dead(Gen1, Gen2, X, Y) ->
    case neighbors(Gen1, X, Y) of
        3 -> set(Gen2, X, Y, 1);
        _ -> set(Gen2, X, Y, 0)
    end.

neighbors(Gen1, X, Y) ->
    L = erlang:max(1, X - 1),
    R = erlang:min(5, X + 1),
    T = erlang:max(1, Y - 1),
    B = erlang:min(5, Y + 1),
    Sum = neighbors(Gen1, 0, L, T, R, B, T) - get(Gen1, X, Y).

neighbors(Gen1, Total, X, Y, MaxX, MaxY, MinY) ->
    Total1 = Total + get(Gen1, X, Y),
    case Y of
        MaxY -> 
            case X of
                MaxX ->
                    Total1;
                _ ->
                    neighbors(Gen1, Total1, X + 1, MinY, MaxX, MaxY, MinY)
            end;
        _ ->
            neighbors(Gen1, Total1, X, Y + 1, MaxX, MaxY, MinY)
    end.

get(Gen, X, Y) ->
    lists:nth(X, lists:nth(Y, Gen)).

set(Gen, X, Y, Val) ->
    replace(Y, replace(X, Val, lists:nth(Y, Gen)), Gen).

replace(Index, Value, List) ->
    {Left, [_ | Right]} = lists:split(Index - 1, List),
    lists:append([Left, [Value], Right]).
