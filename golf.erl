#!/usr/bin/env escript
%% -*- erlang -*-
-mode(compile).
main(_) ->
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
ev(1,N)when N<2->0;
ev(1,N)when N>3->0;
ev(1,_)->1;
ev(0,3)->1;
ev(0,_)->0.

-record(coord, {x, y}).
-record(size, {min, max}).
    
evolve(Input_board) ->
    Upper_left  = #coord{x = 1, y = 1},
    Lower_right = #coord{x = length(lists:nth(1, Input_board)), y = length(Input_board)},
    Board_size = #size{min = Upper_left, max = Lower_right},
    iterate_board(Input_board, Input_board, fun evolve_cell/5, Upper_left, Board_size).

evolve_cell(Input_board, Output_board, X, Y, Size) ->
    Old_value = gv(Input_board, X, Y),
    Neighbors = nb(Input_board, X, Y, Size),
    New_value = ev(Old_value, Neighbors),
    sv(Output_board, X, Y, New_value).

iterate_board(Input_board, Output_board, Function, Start, Size = #size{max = #coord{x = MaxX, y = MaxY}}) ->
    Output_board1 = Function(Input_board, Output_board, Start#coord.x, Start#coord.y, Size),
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

get_sum(Input_board, Total, X, Y, _Size) ->
    Total + gv(Input_board, X, Y).

nb(Input_board, X, Y,
   #size{min = #coord{x = MinX, y = MinY}, max = #coord{x = MaxX, y = MaxY}}) ->
    X1 = mx(MinX, X - 1),
    XN = mn(MaxX, X + 1),
    Y1 = mx(MinY, Y - 1),
    YN = mn(MaxY, Y + 1),
    Neighbors = #size{min = #coord{x = X1, y = Y1}, max = #coord{x = XN, y = YN}},
    iterate_board(Input_board, 0, fun get_sum/5, #coord{x = X1, y = Y1}, Neighbors) - gv(Input_board, X, Y).

gv(I,X,Y)->ln(X,ln(Y,I)).
sv(I,X,Y,V)->lr(Y,lr(X,V,ln(Y,I)),I).
lr(I,V,A)->{L,[_|R]}=ls(I-1,A),la([L,[V],R]).
la(A)->lists:append(A).
ls(I,L)->lists:split(I,L).
ln(I,A)->lists:nth(I,A).
mx(L,R)->erlang:max(L,R).
mn(L,R)->erlang:min(L,R).
