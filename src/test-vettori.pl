/** <module> Test di unita` per modulo vettori.

  @author M.Carullo, A.Carcano
  @version $Id$
*/
:- ensure_loaded('vettori').
:- begin_tests(vettori).

%
% Test del predicato vector_dot_product/3
%
test(vector_dot_product):-
		% prova moltiplicazione
		vector_dot_product([2,5,9],[1,2,4],48),
		% prodotto di vettori ortogonali = 0
		vector_dot_product([1,0],[0,1],0),
		% prodotto di vettori paralleli = 1
		vector_dot_product([1,0],[1,0],1),
		% non e' definito per vettori nulli
		not(vector_dot_product([],[],0)).
		
%
% Test del predicato vector_dot_product/4, ovvero su GF(p).
%
test(vector_dot_product_GF):-
		% prova di moltiplicazione su GF
		vector_dot_product([2,5,9],[1,2,4],0,2),
		% prodotto di vettori ortogonali = 0
		vector_dot_product([1,0],[0,1],0,2),
		% prodotto di vettori paralleli = 1
		vector_dot_product([1,0],[1,0],1,2),
		% non e' definito per vettori nulli
		not(vector_dot_product([],[],0,2)).

%
% Test del predicato vector_sum_gf/4
%
test(vector_sum_gf):-
		% test somma su GF(3).
		vector_sum_gf([3,2,4],[1,2,4],[1,1,2],3),
		% somma di vettori nulli e' un vettore nullo
		vector_sum_gf([],[],[],2),!.
		
%
% Test del predicato vector_sum/3
%
test(vector_sum):-
		vector_sum([0],[1],[1]),
		vector_sum([0,0,0], [1,2,3], [1,2,3]).

%
% Test del predicato vector_number_mult/3
% TODO: aggiungere controllo per dare No nel caso in ingresso ci sia una matrice e non un vettore
test(vector_number_mult):-
		vector_number_mult([1,0,0], 5, [5,0,0]),
		vector_number_mult([3,2,4], 0, [0,0,0]).

%
% Test del predicato vector_random_gf/3
%
test(vector_random_gf):-
		% genera vettore random e verifica il max
		vector_random_gf(X,10,2),
		massimo(X,1), !.
		
%
% Test del predicato vector_random_int/3
%
test(vector_random_int):-
		vector_random_int(3,5,V), lunghezza(V,3), massimo(V,Max), Max =< 5, minimo(V,Min), Min >= -5.
		
%
% Test del predicato vector_error/3
%
test(vector_error):-
		vector_error(3,2,V), lunghezza(V,3), massimo(V,Max), Max =< 5, minimo(V,Min), Min >= -5.
		
%
% Test del predicato vector_unoi/3, che mette nella posizione scelta un 1.
%
test(vector_unoi):-
		vector_unoi(5,1,[0,0,0,0,1]),
		vector_unoi(5,2,[0,0,0,1,0]),
		vector_unoi(5,5,[1,0,0,0,0]).

%
% Test del predicato vector_round/2
%
test(vector_round):-
		vector_round([],[]),
		vector_round([0.1,1.2,5.3],[0,1,5]).

:- end_tests(vettori).