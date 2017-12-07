% operateur ?=
:- op(20,xfy,?=).

% Prédicats d affichage fournis

% set_echo: ce prédicat active l affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).



% predicat pour l application des regles

% renommage d une variable
% regles(x?=t,rename) :  true si t est une variable
regles(E,rename) :- arg(1,E,X),arg(2,E,T),var(X), var(T),!.

% simplification d une constante
% regles(x?=a,simplify) :  true si a est une constante, si x est une constante, alors x==a
regles(E,simplify) :- arg(1,E,X), arg(2,E,A), var(X), nonvar(A), ! ; arg(1,E,X), arg(2,E,A), nonvar(X),nonvar(A),X==A,!.

% developpement
% regles(x?=t,expand) : true si t est composé et x n apparait pas dans t
regles(E,expand) :- arg(1,E,X), arg(2,E,T), var(X), compound(T), \+occur_check(X,T),!. 
 
% verification d occurence
% regles(x?=t,check) : true si x\==t et x apparait dans t
regles(E,check) :- arg(1,E,X), arg(2,E,T), var(X), X\==T, occur_check(X,T), !.

% echange
% regles(t?=x,orient) : true si t n est pas une variable
regles(E,orient) :- arg(1,E,T), arg(2,E,X), var(X), nonvar(T), !.

% decomposition de deux fonctions
% regle(x?=t,decompose) : true si x et t ont le meme symbole ET la meme arite
regles(E,decompose) :- arg(1,E,X),arg(2,E,T), compound(X), compound(T), functor(X,N,A),functor(T,M,B),N==M,A==B,!.

% conflit entre deux fonctions
% regle(x?=t,clash) : true si x et t n ont pas le meme symbole OU pas la meme arite
regles(E,clash) :- arg(1,E,X),arg(2,E,T), compound(X), compound(T), functor(X,N,A),functor(T,M,B),not( ( N==M , A==B ) ),!.



% test d occurence
occur_check(V,T) :- var(V), nonvar(T), !, fail ;
                    var(V), arg(_,T,X), V==X, ! ;
                    var(V), arg(_,T,X), compound(X), occur_check(V,X), !.


% application des regles
% renommage
% application(rename,x?=t,x?=t|p,q)  renomme les occurences de la variable x en la variable t
application(rename,E,P,Q) :- arg(1,E,X), arg(2,E,T), X=T, Q=P.

% simplification
% application(simplify,x?=a,x?=a|p,q)  renomme les occurences de la variable x en la constante t
application(simplify,E,P,Q) :- arg(1,E,X), arg(2,E,T), X=T, Q=P.

% developpement
% application(expand,x?f(v),x?=f(v)|p,q)  renomme les occurences de la variable x en terme compose f(v)
application(expand,E,P,Q) :- arg(1,E,X), arg(2,E,T), X=T, Q=P.

% echange
% application(orient,t?=x,t?=x|p,q)  intervertis le t et le x
application(orient,E,P,Q) :- arg(1,E,T), arg(2,E,X), append([X?=T],P,Q).

% decomposition
% application(decompose,f(x)?=f(y),f(x)?=f(y)|p,q)  decompose l equation
application(decompose,E,P,Q) :- arg(1,E,X), arg(2,E,T), X=..XT, new_list(XT,XL), T=..TT,  new_list(TT,TL), croisement(XL,TL,S), append(S,P,Q).



% transforme le système d’équations P en le système d’équations Q par application de la règle de transformation R à l’équation E.
% reduit(R,E,P,Q) : true si la regle est applicable sur l equation.
reduit(R,E,P,Q) :- \+regles(E,clash), \+regles(E,check), regles(E,R), !, write(R), application(R,E,P,Q).




% fonctions complémentaires

% new_list(A,B) : transforme une liste en une autre en ne gardant que le reste
new_list([_|P],XL) :- XL=P.

% croisement(A,B,C) : prend deux à deux les elements de chaque liste pour en faire une liste du type [A?=B, ... ]
croisement([A|P],[B|Q],S) :- croisement(P,Q,Z), append([A?=B],Z,S).
croisement([],[],S) :- S=[].


unifie([A|P]) :- reduit(_,A,P,Q),!, unifie(Q). 
unifie([]) :- write('Unification terminee').


