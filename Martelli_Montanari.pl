 :- op(20,xfy,?=).
 
 
 %Rename 
 %Simplify
 %Expand
 %Check
 %Orient
 %Decompose
 %Clash
 
 %regle(E,R)
 
 
 regle(E,decompose) :- arg(1,E,W),arg(2,E,X),functor(W,N,A),functor(X,M,B),N=M,A=B.

 regle(E,clash) :- arg(1,E,W),arg(2,E,X),functor(W,N,A),functor(X,M,B), not(N=M) ; not(A=B).
 
 
 
 
 
 