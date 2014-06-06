-module(ergol).

-export([test/0]).

% "Game of Life".
% The input will be a game board of cells, either alive (1) or dead (0).
% The code should take this board and create a new board for the
% next generation based on the following rules:
%  1) Any live cell with fewer than two live neighbours dies (under-population)
%  2) Any live cell with two or three live neighbours lives on to
%     the next generation (survival)
%  3) Any live cell with more than three live neighbours dies (overcrowding)
%  4) Any dead cell with exactly three live neighbours becomes a live cell (reproduction)

test() ->
    Input =  [[0, 1, 0, 0, 0],
              [1, 0, 0, 1, 1],
              [1, 1, 0, 0, 1],
              [0, 1, 0, 0, 0],
              [1, 0, 0, 0, 1]],
    Output = [[0, 0, 0, 0, 0],
              [1, 0, 1, 1, 1],
              [1, 1, 1, 1, 1],
              [0, 1, 0, 0, 0],
              [0, 0, 0, 0, 0]],
    Output = evolve(Input),
    io:format("Passed~n").

-record(coord, {x, y}).
-record(size, {min, max}).
    
evolve(Input_board) ->
    Start_cell = #coord{x = 1, y = 1},
    Board_size = #size{
              min = Start_cell,
              max = #coord
              {
                x = length(lists:nth(1, Input_board)), 
                y = length(Input_board)
              }
             },
    iterate_2d(Input_board, Input_board, fun evolve_cell/4, Start_cell, Board_size).

evolve_cell(Input_board, Output_board, Coord, Size) ->
    case get_value_at_coordinate(Input_board, Coord) of
        1 -> live(Input_board, Output_board, Coord, Size);
        0 -> dead(Input_board, Output_board, Coord, Size)
    end.

iterate_2d(Input_board, Output_board, Function, Start = #coord{x = X, y = Y}, 
          Size = #size{min = #coord{y = MinY}, max = #coord{x = MaxX, y = MaxY}}) ->
    Output_board1 = Function(Input_board, Output_board, Start, Size),
    case Y of
        MaxY ->
            case X of
                MaxX ->
                    Output_board1;
                _ ->
                    iterate_2d(Input_board, Output_board1, Function, #coord{x = X + 1, y = MinY}, Size)
            end;
        _ ->
            iterate_2d(Input_board, Output_board1, Function, #coord{x = X, y = Y + 1}, Size)
    end.

get_sum(Input_board, Total, Coord, _Size) ->
    Total + get_value_at_coordinate(Input_board, Coord).

neighbors(Input_board, Coord = #coord{x = X, y = Y}, 
          #size{min = #coord{x = MinX, y = MinY}, max = #coord{x = MaxX, y = MaxY}}) ->
    %% determine the boundary rectangle of our neighbors
    X1 = erlang:max(MinX, X - 1),
    XN = erlang:min(MaxX, X + 1),
    Y1 = erlang:max(MinY, Y - 1),
    YN = erlang:min(MaxY, Y + 1),
    Neighbors = #size{min = #coord{x = X1, y = Y1}, max = #coord{x = XN, y = YN}},
    iterate_2d(Input_board, 0, fun get_sum/4, #coord{x = X1, y = Y1}, Neighbors) - get_value_at_coordinate(Input_board, Coord).

live(Gen1, Gen2, Coord, Size) ->
    case neighbors(Gen1, Coord, Size) of
        2 -> set_value_at_coordinate(Gen2, Coord, 1);
        3 -> set_value_at_coordinate(Gen2, Coord, 1);
        _ -> set_value_at_coordinate(Gen2, Coord, 0)
    end.

dead(Gen1, Gen2, Coord, Size) ->
    case neighbors(Gen1, Coord, Size) of
        3 -> set_value_at_coordinate(Gen2, Coord, 1);
        _ -> set_value_at_coordinate(Gen2, Coord, 0)
    end.

get_value_at_coordinate(Gen, #coord{x = X, y = Y}) ->
    lists:nth(X, lists:nth(Y, Gen)).

set_value_at_coordinate(Gen, #coord{x = X, y = Y}, Val) ->
    replace_single_value_in_list(Y, replace_single_value_in_list(X, Val, lists:nth(Y, Gen)), Gen).

replace_single_value_in_list(Index, Value, List) ->
    {Left, [_ | Right]} = lists:split(Index - 1, List),
    lists:append([Left, [Value], Right]).
