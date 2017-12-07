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


 
 regles(E,decompose) :- arg(1,E,W),arg(2,E,X),compound(W),compound(X),!,functor(W,N,A),functor(X,M,B),N==M,A==B.

 regles(E,clash) :-  arg(1,E,W),arg(2,E,X),compound(W),compound(X),!,functor(W,N,A),functor(X,M,B),not( ( N==M , A==B ) ).