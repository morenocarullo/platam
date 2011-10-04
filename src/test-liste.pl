/** <module> Test di unita` per modulo liste.

  @author M.Carullo, A.Carcano
  @version $Id: test-liste.pl 33 2007-06-27 13:26:50Z utente33 $
*/
:- ensure_loaded('liste').
:- begin_tests(liste).

%
% Test del predicato lunghezza/2, che calcola la lunghezza
% di una lista.
%
test(lunghezza):-
		lunghezza([1,2,3,4,5,6,7,8,9], 9),
		lunghezza([],0).

%
% Test del predicato lista_elem/3, che ottiene l'N-esimo elemento.
%
test(lista_elem):-
		lista_elem([0,1,2,3],2,1).

%
% Test del predicato lista_elem_canc/3, che elimina un elemento.
%
test(lista_elem_canc):-
		lista_elem_canc([1,2,3,4,5],1,[2,3,4,5]),
		lista_elem_canc([0,1,2,3],4,[0,1,2]),
		lista_elem_canc([0,1,2,3,4],5,[0,1,2,3,4]).

%
% Test del predicato liste_elem_canc/3, che elimina l'N-esimo
% elemento da ogni lista in una lista di liste.
%
test(liste_elem_canc):-
		liste_elem_canc([[0,1,2],[2,3,4]],2,[[0, 2], [2, 4]]).

%
% Test del predicato lista_notnull/3, che ritorna gli elementi diversi da 0.
%
test(lista_notnull):-
		lista_notnull([0,5,0,0],2,5), !.

%
% Test del predicato lista_join/3, che unisce due liste.
%
test(lista_join):-
		lista_join([1,2,3],[4,5,6],[1,2,3,4,5,6]),
		lista_join([],[1,2,3,4,5], [1,2,3,4,5]),
		lista_join([1,2,3,4,5], [], [1,2,3,4,5]).

%
% Test del predicato lista_blank/2.
%
test(lista_blank):-
		lista_blank(X,10),
		lunghezza(X,10),
		massimo(X,0), !.

%
% Test del predicato lista_fillto/3, che allunga una lista
% fino a raggiungere la lunghezza desiderata.
%
test(lista_fillto):-
		lista_fillto([1,2,3,4],[1,2,3,4,0,0,0,0],8).
		
%
% Test del predicato lista_split/3
%
test(lista_split):-
		lista_split([1,2,3,4,5],2,X),
		lunghezza(X,3),!.

:- end_tests(liste).