#!/usr/bin/env escript
main(_)->[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]]=e([[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]]).
e(1,2)->1;e(_,3)->1;e(_,_)->0.
e(I)->i(I,fun(J,C,S)->e(v(J,C),n(J,C,S))end,{1,1,l(n(1,I)),l(I)}).
i(I,F,S={Xa,Ya,Xz,Yz})->[[F(I,{X,Y},S)||X<-r(Xa,Xz)]||Y<-r(Ya,Yz)].
n(I,C={X,Y},{Xa,Ya,Xz,Yz})->a([a(R)||R<-i(I,fun(J,D,_)->v(J,D)end,{x(Xa,X-1),x(Ya,Y-1),m(Xz,X+1),m(Yz,Y+1)})])-v(I,C).
v(I,{X,Y})->n(X,n(Y,I)).
n(I,A)->lists:nth(I,A).
r(L,R)->lists:seq(L,R).
x(L,R)->erlang:max(L,R).
m(L,R)->erlang:min(L,R).
l(A)->length(A).
a(A)->lists:sum(A).
