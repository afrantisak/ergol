#!/usr/bin/env escript
%% -*- erlang -*-
-mode(compile).
main(_)->Ib=[[0,1,0,0,0],[1,0,0,1,1],[1,1,0,0,1],[0,1,0,0,0],[1,0,0,0,1]],
         Ob=[[0,0,0,0,0],[1,0,1,1,1],[1,1,1,1,1],[0,1,0,0,0],[0,0,0,0,0]],
         Ob=e(Ib),io:format("Passed~n").
e(1,2)->1;
e(1,3)->1;
e(1,_)->0;
e(0,3)->1;
e(0,_)->0.
e(I)->i(I,I,fun e/8,1,1,1,1,l(n(1,I)),l(I)).
e(I,O,X,Y,MnX,MnY,MxX,MxY)->sv(O,X,Y,e(gv(I,X,Y),nb(I,X,Y,MnX,MnY,MxX,MxY))).

i(Ib,Ob,F,X,Y,MnX,MnY,MxX,MxY)->Ob1=F(Ib,Ob,X,Y,MnX,MnY,MxX,MxY),case Y of MxY->case X of MxX->Ob1; _->i(Ib,Ob1,F,X+1,MnY,MnX,MnY,MxX,MxY) end;_->i(Ib,Ob1,F,X,Y+1,MnX,MnY,MxX,MxY) end.

-define(FF(X,Y), F(Ib,Ob,X,Y,MnX,MnY,MxX,MxY)).
i2(Ib,Ob,F,MxX,MxY,MnX,MnY,MxX,MxY)->?FF(MxX,MxY);i2(Ib,Ob,F,X,MxY,MnX,MnY,MxX,MxY)->i2(Ib,?FF(X,MxY),F,X+1,MnY,MnX,MnY,MxX,MxY);i2(Ib,Ob,F,X,Y,MnX,MnY,MxX,MxY)->i2(Ib,?FF(X,Y),F,X,Y+1,MnX,MnY,MxX,MxY).

nb(Ib,X,Y,MnX,MnY,MxX,MxY)->X1=mx(MnX,X-1),Y1=mx(MnY,Y-1),i(Ib,0,fun sum/8,X1,Y1,X1,Y1,mn(MxX,X+1),mn(MxY,Y+1))-gv(Ib,X,Y).
sum(Ib,T,X,Y,_,_,_,_)->T+gv(Ib,X,Y).
gv(I,X,Y)->n(X,n(Y,I)).
sv(I,X,Y,V)->lr(Y,lr(X,V,n(Y,I)),I).
lr(I,V,A)->{L,[_|R]}=ls(I-1,A),la([L,[V],R]).
la(A)->lists:append(A).
ls(I,L)->lists:split(I,L).
n(I,A)->lists:nth(I,A).
mx(L,R)->erlang:max(L,R).
mn(L,R)->erlang:min(L,R).
l(A)->length(A).
