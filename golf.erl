#!/usr/bin/env escript
-mode(compile).
main(_)->[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]]=e([[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]]).
e(1,2)->1;e(_,3)->1;e(_,_)->0.
e(I)->i(I,I,fun e/4,{1,1},{1,1,l(n(1,I)),l(I)}).
e(I,O,C,S)->sv(O,C,e(gv(I,C),nb(I,C,S))).
i(I,O,F,C={X,Y},S={_,Ya,Xz,Yz})->O1=F(I,O,C,S),case Y of Yz->case X of Xz->O1;_->i(I,O1,F,{X+1,Ya},S)end;_->i(I,O1,F,{X,Y+1},S)end.
nb(I,C={X,Y},{Xa,Ya,Xz,Yz})->X1=mx(Xa,X-1),Y1=mx(Ya,Y-1),i(I,0,fun sum/4,{X1,Y1},{X1,Y1,mn(Xz,X+1),mn(Yz,Y+1)})-gv(I,C).
sum(I,T,C,_)->T+gv(I,C).
gv(I,{X,Y})->n(X,n(Y,I)).
sv(I,{X,Y},V)->lr(Y,lr(X,V,n(Y,I)),I).
lr(I,V,A)->{L,[_|R]}=ls(I-1,A),la([L,[V],R]).
la(A)->lists:append(A).
ls(I,L)->lists:split(I,L).
n(I,A)->lists:nth(I,A).
mx(L,R)->erlang:max(L,R).
mn(L,R)->erlang:min(L,R).
l(A)->length(A).
