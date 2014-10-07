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
    Board_dimensions = {1, 1, length(lists:nth(1, Board)), length(Board)},
    transform_board_subset(Board, bind(fun evolve_board_cell/3, Board_dimensions), Board_dimensions).

evolve_board_cell(Board, Position, Subset_dimensions) ->
    Value = get_board_cell_value(Board, Position),
    Neighbor_count = count_neighbors(Board, Position, Subset_dimensions),
    evolve_cell(Value, Neighbor_count).

evolve_cell(1, 2) -> 1;
evolve_cell(_, 3) -> 1;
evolve_cell(_, _) -> 0.

count_neighbors(Board, Position = {X, Y}, {MinX, MinY, MaxX, MaxY}) ->
    Neighbor_subset_dimensions = {max(MinX, X - 1), max(MinY, Y - 1), min(MaxX, X + 1), min(MaxY, Y + 1)},
    Neighbor_board = transform_board_subset(Board, fun get_board_cell_value/2, Neighbor_subset_dimensions),
    accumulate_board(Neighbor_board) - get_board_cell_value(Board, Position).

bind(Function, Subset_dimensions) ->
    fun(Board, Position) ->
            Function(Board, Position, Subset_dimensions)
    end.

transform_board_subset(Board, Function, {MinX, MinY, MaxX, MaxY}) ->
    [[Function(Board, {X, Y}) || X <- lists:seq(MinX, MaxX)] || Y <- lists:seq(MinY, MaxY)].

accumulate_board(Board) ->
    lists:sum([lists:sum(Board_row) || Board_row <- Board]).

get_board_cell_value(Board, {X, Y}) ->
    lists:nth(X, lists:nth(Y, Board)).

