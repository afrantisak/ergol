#!/usr/bin/env escript
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

evolve(Board) ->
    transform(Board, fun evolve_cell/2).

evolve_cell(Board, Cell_position) ->
    Cell_value = get_cell_value(Board, Cell_position),
    Neighbor_count = count_neighbors(Board, Cell_position),
    evolve_cell_value(Cell_value, Neighbor_count).

evolve_cell_value(1, 2) -> 1;
evolve_cell_value(_, 3) -> 1;
evolve_cell_value(_, _) -> 0.

count_neighbors(Board, Position) ->
    Neighbor_region = get_neighbor_region(Board, Position),
    Neighbor_board = transform(Board, fun get_cell_value/2, Neighbor_region),
    accumulate(Neighbor_board, fun lists:sum/1) - get_cell_value(Board, Position).

transform(Board, Function) ->
    transform(Board, Function, get_entire_region(Board)).

transform(Board, Function, {MinX, MinY, MaxX, MaxY}) ->
    [[Function(Board, {X, Y}) || X <- lists:seq(MinX, MaxX)] || Y <- lists:seq(MinY, MaxY)].

get_entire_region(Board) ->
    {1, 1, erlang:length(lists:nth(1, Board)), erlang:length(Board)}.

get_neighbor_region(Board, {X, Y}) ->
    {MinX, MinY, MaxX, MaxY} = get_entire_region(Board),
    {erlang:max(MinX, X - 1), erlang:max(MinY, Y - 1), erlang:min(MaxX, X + 1), erlang:min(MaxY, Y + 1)}.

accumulate(Board, Function) ->
    Function([Function(Board_row) || Board_row <- Board]).

get_cell_value(Board, {X, Y}) ->
    lists:nth(X, lists:nth(Y, Board)).

