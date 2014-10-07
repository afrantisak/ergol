#!/usr/bin/env escript
main(_)->[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]]=e([[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]]).
e(1,2)->1;e(_,3)->1;e(_,_)->0.
e(I)->i(I,fun(J,P,S)->e(v(J,P),n(J,P,S))end,{1,1,l(n(1,I)),l(I)}).
i(I,F,S={A,B,C,D})->[[F(I,{X,Y},S)||X<-r(A,C)]||Y<-r(B,D)].
n(I,P={X,Y},{A,B,C,D})->a([a(R)||R<-i(I,fun(J,E,_)->v(J,E)end,{x(A,X-1),x(B,Y-1),m(C,X+1),m(D,Y+1)})])-v(I,P).
v(I,{X,Y})->n(X,n(Y,I)).
n(I,L)->lists:nth(I,L).
r(L,R)->lists:seq(L,R).
x(L,R)->erlang:max(L,R).
m(L,R)->erlang:min(L,R).
l(L)->length(L).
a(L)->lists:sum(L).
