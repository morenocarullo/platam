/** <module> Test di unita` per modulo matrici.

  @author M.Carullo, A.Carcano
  @version $Id: test-matrici.pl 23 2007-06-05 14:09:44Z utente33 $
*/
:- ensure_loaded('matrici').
:- begin_tests(matrici).

%
% Test del predicato matrix_rows/2, che deve contare le righe
% di una matrice.
%
test(matrix_rows):-
		matrix_rows([[1,0,0],[0,1,0],[0,0,1]], 3),
		matrix_rows([[0,1,2,4],[0,0,0,0],[1,1,1,1]], 4),
		not(matrix_rows([],0)).
		
%
% Test del predicato matrix_elem/4, che preleva un elemento della matrice.
%
test(matrix_elem):-
		matrix_elem([[1,0,0],[0,1,0],[0,0,1]],2,3,0),
		matrix_elem([[1,2,3],[4,5,6],[7,8,9]],1,3,7).

%
% Test del predicato matrix_random_gf/4, che deve creare
% una matrice random i cui elementi siano appartenenti a GF(p).
%		
test(matrix_random_gf):-
		matrix_random_gf(M,4,3,2),
		matrix_rows(M,4).

% Test del predicato matrix_i che deve generare la matrice identica,
% cioè una matrice con tutti 1 sulla diagonale.
test(matrix_i):-
		matrix_i(M,6,6),
		matrix_rows(M,6).

% Ttest del predicato matrix_matrix_mult
% Moltiplicando una matrice per la sua identica otteniamo la matrice stessa.
% test(matrix_matrix_mult):-
%		matrix_matrix_mult([[1,0,0],[0,1,0],[0,0,1]], [[1,3,5],[4,5,1],[2,2,2]], [[1,3,5],[4,5,1],[2,2,2]]).
% TODO: da sistemare x' da errore

%
% Test del predicato matrix_sum/3
%
test(matrix_sum):-
		matrix_sum([[0,0,0],[0,0,0],[0,0,0]], [[-2,-1,2],[2,1,0],[-3,3,-1]], [[-2,-1,2],[2,1,0],[-3,3,-1]]),
		matrix_sum([[2,5],[1,3]], [[4,1],[1,6]], [[6,6],[2,9]]).

%
% Test del predicato matrix_matrix_mult/4.
%
test(matrix_matrix_mul):-
		matrix_matrix_mult([[1,0,0],[0,1,0],[0,0,1]],[[-2,-1,2],[2,1,0],[-3,3,-1]],0,[[-2,-1,2],[2,1,0],[-3,3,-1]]).

%
% Test del predicato matrix_vector_mult/4
%
test(matrix_vector_mult):-
		% V = V * I -- ovvero moltiplichiamo per la matrice identica e otteniamo V.
		matrix_vector_mult([[1,0,0],[0,1,0],[0,0,1]], [2,3,4], [2,3,4], 5).

%
% Test del predicato matrix_minor/4, che calcola il minore di una matrice.
%
test(matrix_minor):-
		matrix_minor([[-2,-1,2],[2,1,0],[-3,3,-1]], [[-1,2],[3,-1]], 1, 2).
		
%
% Test del predicato matrix_det/2, che calcola il determinante di una matrice.
%
test(matrix_det):-
		matrix_det([[1,0,0],[0,1,0],[0,0,1]], 1),
		matrix_det([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],1),
		matrix_det([[2,3,4,9],[5,1,4,0],[6,4,1,3],[1,2,5,9]],9),
		matrix_det([[0,4,2,5], [3,2,6,0], [8,3,7,1], [5,5,2,2]], -423),
		matrix_det([[0,1,5,0],[0,0,1,3],[0,19,0,2],[0,55,17,3]],0),
		matrix_det([[1,-2,2],[1,1,-1],[-1,2,1]],9).
	
%
% Test del predicato matrix_build_piv/2, che costruisce la condensazione pivotale.
%
test(matrix_build_piv):-
		matrix_build_piv([[1,0,0],[0,1,0],[0,0,1]], [[1,0],[0,1]]).
		
%
% Test del predicato matrix_invert/2, che inverte una matrice quadrata.
%
test(matrix_invert):-
		matrix_invert([[1,0],[0,1]],[[1,0],[0,1]]),
		matrix_invert([[1,1],[5,10]],[[2,-0.2],[-1,0.2]]),
	 	matrix_invert([[1,0,0],[0,1,0],[0,0,1]], [[1,0,0],[0,1,0],[0,0,1]]),
		matrix_invert([[5,0,0],[0,5,0],[0,0,5]], [[0.2,0,0],[0,0.2,0],[0,0,0.2]]),
		matrix_invert([[1,0,4],[0,1,0],[0,0,1]], [[1,0,-4],[0,1,0],[0,0,1]]).

:- end_tests(matrici).