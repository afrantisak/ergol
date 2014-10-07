#!/usr/bin/env escript
-mode(compile).
main(_)->[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]]=e([[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]]).
e(1,2)->1;e(_,3)->1;e(_,_)->0.
e(I)->i2(I,fun e/3,{1,1,l(n(1,I)),l(I)}).
i(I,O,F,C={X,Y},S={Xa,_,Xz,Yz})->O1=F(I,O,C,S),case X of Xz->case Y of Yz->O1;_->i(I,O1,F,{Xa,Y+1},S)end;_->i(I,O1,F,{X+1,Y},S)end.
e(I,C,S)->e(gv(I,C),nb(I,C,S)).
i2(I,F,S={Xa,Ya,Xz,Yz})->[[F(I,{X,Y},S)||X<-s(Xa,Xz)]||Y<-s(Ya,Yz)].
nb(I,C={X,Y},{Xa,Ya,Xz,Yz})->X1=mx(Xa,X-1),Y1=mx(Ya,Y-1),i(I,0,fun sum/4,{X1,Y1},{X1,Y1,mn(Xz,X+1),mn(Yz,Y+1)})-gv(I,C).
sum(I,T,C,_)->T+gv(I,C).
gv(I,{X,Y})->n(X,n(Y,I)).
n(I,A)->lists:nth(I,A).
s(L,R)->lists:seq(L,R).
mx(L,R)->erlang:max(L,R).
mn(L,R)->erlang:min(L,R).
l(A)->length(A).
