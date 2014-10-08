#!/usr/bin/env escript
main(_)->[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]]=e([[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]]).
e(1,2)->1;e(_,3)->1;e(_,_)->0.
e(I)->i(I,fun(J,P,S)->e(v(J,P),n(J,P,S))end,{1,1,length(n(1,I)),length(I)}).
i(I,F,S={A,B,C,D})->[[F(I,{X,Y},S)||X<-lists:seq(A,C)]||Y<-lists:seq(B,D)].
n(I,P={X,Y},{A,B,C,D})->lists:sum([lists:sum(R)||R<-i(I,fun(J,E,_)->v(J,E)end,{max(A,X-1),max(B,Y-1),min(C,X+1),min(D,Y+1)})])-v(I,P).
v(I,{X,Y})->n(X,n(Y,I)).
n(I,L)->lists:nth(I,L).
