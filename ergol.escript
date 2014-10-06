#!/usr/bin/env escript
%% -*- erlang -*-
-mode(compile).

% "Game of Life".
% The input will be a game board of cells, either alive (1) or dead (0).
% The code should take this board and create a new board for the
% next generation based on the following rules:
%  1) Any live cell with fewer than two live neighbours dies (under-population)
%  2) Any live cell with two or three live neighbours lives on to
%     the next generation (survival)
%  3) Any live cell with more than three live neighbours dies (overcrowding)
%  4) Any dead cell with exactly three live neighbours becomes a live cell (reproduction)

main(_) ->
    Input =  [[dead, live, dead, dead, dead],
              [live, dead, dead, live, live],
              [live, live, dead, dead, live],
              [dead, live, dead, dead, dead],
              [live, dead, dead, dead, live]],
    Output = [[dead, dead, dead, dead, dead],
              [live, dead, live, live, live],
              [live, live, live, live, live],
              [dead, live, dead, dead, dead],
              [dead, dead, dead, dead, dead]],
    Output = evolve(Input),
    io:format("Passed~n").

evolve(live, Neighbors) when Neighbors < 2 -> dead; %% underpopulation
evolve(live, Neighbors) when Neighbors > 3 -> dead; %% overcrowding
evolve(live, _) -> live; %% survival
evolve(dead, 3) -> live; %% reproduction
evolve(dead, _) -> dead. %% stays dead

-record(coord, {x, y}).
-record(size, {min, max}).
    
evolve(Input_board) ->
    Upper_left  = #coord{x = 1, y = 1},
    Lower_right = #coord{x = length(lists:nth(1, Input_board)), y = length(Input_board)},
    Board_size = #size{min = Upper_left, max = Lower_right},
    iterate_board(Input_board, Input_board, fun evolve_cell/4, Upper_left, Board_size).

evolve_cell(Input_board, Output_board, Current_coord, Size) ->
    Old_value = get_value(Input_board, Current_coord),
    Neighbors = neighbors(Input_board, Current_coord, Size),
    New_value = evolve(Old_value, Neighbors),
    set_value(Output_board, Current_coord, New_value).

iterate_board(Input_board, Output_board, Function, Start, Size = #size{max = #coord{x = MaxX, y = MaxY}}) ->
    Output_board1 = Function(Input_board, Output_board, Start, Size),
    case Start#coord.y of
        MaxY ->
            case Start#coord.x of
                MaxX ->
                    Output_board1;
                _ ->
                    NextColumn = #coord{x = Start#coord.x + 1, y = Size#size.min#coord.y},
                    iterate_board(Input_board, Output_board1, Function, NextColumn, Size)
            end;
        _ ->
            NextRow = #coord{x = Start#coord.x, y = Start#coord.y + 1},
            iterate_board(Input_board, Output_board1, Function, NextRow, Size)
    end.

as_int(live) -> 1;
as_int(dead) -> 0.

get_sum(Input_board, Total, Coord, _Size) ->
    Total + as_int(get_value(Input_board, Coord)).

neighbors(Input_board, Coord = #coord{x = X, y = Y}, 
          #size{min = #coord{x = MinX, y = MinY}, max = #coord{x = MaxX, y = MaxY}}) ->
    %% determine the boundary rectangle of our neighbors
    X1 = erlang:max(MinX, X - 1),
    XN = erlang:min(MaxX, X + 1),
    Y1 = erlang:max(MinY, Y - 1),
    YN = erlang:min(MaxY, Y + 1),
    %% if we are at the edge, do not fall off the board
    Neighbors = #size{min = #coord{x = X1, y = Y1}, max = #coord{x = XN, y = YN}},
    iterate_board(Input_board, 0, fun get_sum/4, #coord{x = X1, y = Y1}, Neighbors) - as_int(get_value(Input_board, Coord)).

get_value(Gen, #coord{x = X, y = Y}) ->
    lists:nth(X, lists:nth(Y, Gen)).

set_value(Gen, #coord{x = X, y = Y}, Val) ->
    replace_single_value_in_list(Y, replace_single_value_in_list(X, Val, lists:nth(Y, Gen)), Gen).

replace_single_value_in_list(Index, Value, List) ->
    {Left, [_ | Right]} = lists:split(Index - 1, List),
    lists:append([Left, [Value], Right]).