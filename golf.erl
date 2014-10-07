#!/usr/bin/env escript
-mode(compile).
main(_)->[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]]=e([[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]]).
e(1,2)->1;e(_,3)->1;e(_,_)->0.
e(I)->i(I,fun e/3,{1,1,l(n(1,I)),l(I)}).
e(I,C,S)->e(gv(I,C),nb(I,C,S)).
i(I,F,S={Xa,Ya,Xz,Yz})->[[F(I,{X,Y},S)||X<-r(Xa,Xz)]||Y<-r(Ya,Yz)].
nb(I,C={X,Y},{Xa,Ya,Xz,Yz})->a([a(R)||R<-i(I,fun v/3,{mx(Xa,X-1),mx(Ya,Y-1),mn(Xz,X+1),mn(Yz,Y+1)})])-gv(I,C).
v(I,C,_)->gv(I,C).
gv(I,{X,Y})->n(X,n(Y,I)).
n(I,A)->lists:nth(I,A).
r(L,R)->lists:seq(L,R).
mx(L,R)->erlang:max(L,R).
mn(L,R)->erlang:min(L,R).
l(A)->length(A).
a(A)->lists:sum(A).
