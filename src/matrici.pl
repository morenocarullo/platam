/** <module> Libreria per matrici, anche su campi GF(p).

   USA: modulo 'liste', modulo 'vettori'.

   NOTA: si utilizza la notazione a "lista di colonne".

   @author M.Carullo, A.Carcano
   @version $Id: matrici.pl 37 2007-06-29 15:49:41Z utente33 $
*/
:- ensure_loaded('vettori').


%% matrix_rows(+Matrix,?Row) is nondet.
%
%  conta le righe di una matrice:
%  basta contare gli elementi di una colonna.
%
%  @author Moreno

:- dynamic matrix_rows/2.
matrix_rows([Mh|_],C):- lunghezza(Mh,C).

matrix_cols(M,C):- lunghezza(M,C).


%% matrix_elem(+Matrix,+Row,+Col,?A) is det.
%
%  Preleva l'elemento alla riga Row e colonna Col
%  NOTA: la matrice deve essere quadrata!
%
%  @author Andrea

matrix_elem(M,Row,Col,A):- matrix_elem_u(M,Row,Col,A).
matrix_elem_u([Mh|_],Row,1,A):- lista_elem(Mh,Row,A),!.
matrix_elem_u([_|Mc],Row,N,A):- N1 is N - 1, matrix_elem_u(Mc,Row,N1,A).


%% matrix_random_gf(?Matrix,+Row,+Columns,+Gf) is det.
%
%  inizializza una matrice random su GF(p)
%
%  @author Andrea	

matrix_random_gf([Mh|[]],Rows,1,Gf):-!, vector_random_gf(Mh,Rows,Gf).
matrix_random_gf([Mh|Mc],Rows,Cols,Gf):-
		matrix_random_gf([Mh|[]],Rows,1,Gf),
		ColsMin1 is Cols - 1,
		matrix_random_gf(Mc,Rows,ColsMin1,Gf).


%% matrix_random_inteval(?Matrix,+Row,+Columns,+Gf) is det.
%
%  inizializza una matrice random su GF(p)
%
%  @author Andrea	

matrix_random_interval([Mh|[]],Rows,1,Int):-!, vector_random_int(Rows,Int,Mh).
matrix_random_interval([Mh|Mc],Rows,Cols,Gf):-
		matrix_random_interval([Mh|[]],Rows,1,Gf),
		ColsMin1 is Cols - 1,
		matrix_random_interval(Mc,Rows,ColsMin1,Gf).

%% matrix_i(?M,+Rows,+Cols)
%
%	Genera la matrice identità
%	M = dimensione della matrice
%	Rows = righe della matrice
%	Cols =Colonne dell matrice; parametro da passare a Vettore_uno
%
%  @author Andrea

:- dynamic matrix_i/3.
matrix_i(M,Rows,Cols):- matrix_i_u(M,Rows,Cols,Cols).
matrix_i_u([Mh|[]],1,Cols,I):-!, vector_unoi(Cols,I,Mh).
matrix_i_u([Mh|Mc],Rows,Cols,I):-
	matrix_i_u([Mh|[]],1,Cols,I),
	RowsMin1 is Rows-1,
	I1 is I-1,
	matrix_i_u(Mc,RowsMin1,Cols,I1).


%% matrix_matrix_mult(+M1,+M2,+Gf,?Mprod)
%
%	moltiplica due matrici
%
%  @author Andrea

matrix_matrix_mult(M1,M2,Gf,Mprod):- matrix_trasp(M2,M2_trasp), vector_dot_products(M1,M2_trasp,Mprod,Gf), !.


%% matrix_vector_mult(+Matrix,+Vector,?Result,+Gf) is det.
%
%  Moltiplica un vettore per una matrice. Se Gf == 0 allora si opera su R
%
%  @author Andrea

matrix_vector_mult([Mh|[]],V,[Oh|[]],Gf):-!, vector_dot_product(Mh,V,Oh,Gf).
matrix_vector_mult([Mh|Mc],V,[Oh|Oc],Gf):-
		matrix_vector_mult([Mh|[]],V,[Oh|[]],Gf),
		matrix_vector_mult(Mc,V,Oc,Gf).


%% matrix_trasp(+Matrix,?TraspMatrix) is det.
%
%  matrice trasposta
%  NOTA: dal libro del prof.

matrix_trasp([[ ] | _], [ ]):-!,true.
matrix_trasp(Matrice, [Col_1 | Col_n]) :- matrix_colonne(Matrice, Col_1, Resto_colonne), matrix_trasp(Resto_colonne, Col_n). 


%% matrix_colonne(+Matrix,?PrimaColonna,?AltreColonne) is nondet.
%
%  separa la prima colonna dal resto delle colonne	
%  NOTA: dal libro del prof.

matrix_colonne([], [ ], [ ]). 
matrix_colonne([[C_11|C_1n] | C], [C_11|X], [C_1n|Y]) :- matrix_colonne(C, X, Y).


%% matrix_minor(+Matrix,?MinorMatrix,+CancRow,+CancColumn) is det.
%
%  Calcola il minore di una matrice.
%  Il minore I,J di una matrice N*M si calcola togliendo la I-esima riga e la J-esima colonna.
%
%  @author Moreno
	
matrix_minor(Min,Mout,I,J):-!,
		lista_elem_canc(Min,J,MoutStepOne),
		liste_elem_canc(MoutStepOne,I,Mout).


%% matrix_not1null(+Matrix) is det.
%
%  Controlla che la prima riga non sia tutta di 0.
%
%  @author Moreno

matrix_not1null([[E|_]|_]):- E \== 0, !.
matrix_not1null([[0|_]|Mc]):- matrix_not1null(Mc).


%% matrix_swap_nozero(+Matrice,?MatriceOk,?Scambi) is det.
%
%  Scambia le colonne della matrice in modo da avere in posizione (1,1) un elem. non nullo.
%  Richiede prima un controllo con la matrix_not1null altrimenti va in loop se la prima riga e' tutta a 0.
%
%  @author Moreno

matrix_swap_nozero(Mi,Mi,0):- matrix_elem(Mi,1,1,A), A \== 0,!.
matrix_swap_nozero(Mi,Mo,Scambi):- lista_scroll(Mi,Mt), matrix_swap_nozero(Mt,Mo,Scambi0), Scambi is Scambi0 + 1.


%% matrix_det(+Matrix,?Det) is det.
%
%  calcola il determinante di una matrice.
%
%   caso 2x2: base --  caso 3x3: regola Sarrus --  caso 4x4: espansione Laplace + Sarrus.
%   caso induttivo con condensazione pivotale.
%
%  @author Moreno

:- dynamic matrix_det/2.
matrix_det([[A,C],[B,D]],Det):-!, Det is A*D - B*C.
matrix_det([[A,D,G],[B,E,H],[C,F,I]], Det):-!, Det is A*E*I + B*F*G + C*D*H - C*E*G - A*F*H - B*D*I.
matrix_det([[M11,M12,M13,M14],[M21,M22,M23,M24],[M31,M32,M33,M34],[M41,M42,M43,M44]], Det):-!,
		Det is
		M11 * (M22*M33*M44 + M32*M43*M24 + M42*M23*M34 - M42*M33*M24 - M22*M43*M34 - M32*M23*M44) -
		M12 * (M21*M33*M44 + M31*M43*M24 + M41*M23*M34 - M41*M33*M24 - M21*M43*M34 - M31*M23*M44) +
		M13 * (M21*M32*M44 + M31*M42*M24 + M41*M22*M34 - M41*M32*M24 - M21*M42*M34 - M31*M22*M44) -
		M14 * (M21*M32*M43 + M31*M42*M23 + M41*M22*M33 - M41*M32*M23 - M21*M42*M33 - M31*M22*M43).

matrix_det([[0|Mh]|Mc],Det):-
		matrix_not1null([[0|Mh]|Mc]), matrix_swap_nozero([[0|Mh]|Mc],Ms,Swaps),
		matrix_elem(Ms,1,1,A),
		matrix_rows(Ms,Rows),
		asserta(matrix_rows(Ms,Rows)),
		matrix_build_piv(Ms,M1),
		retract(matrix_rows(Ms,Rows)),
		matrix_det(M1,Det1),
		Det is (1 - 2*(Swaps mod 2)) * (Det1 / A^(Rows-2)).

matrix_det([[A|Mh]|Mc],Det):-
		A =\= 0,
		matrix_rows([[A|Mh]|Mc],Rows),
		asserta(matrix_rows([[A|Mh]|Mc],Rows)),
		matrix_build_piv([[A|Mh]|Mc],M1),
		retract(matrix_rows([[A|Mh]|Mc],Rows)),
		matrix_det(M1,Det1),
		Det is Det1 / A^(Rows-2).

matrix_det(_,0).


%% matrix_build_piv(+Matrix,+Pos,?MatrixPivotCondensed) is det.
%
%  Condensazione pivotale. Utile per il calcolo del determinante.
%
%  @author Moreno

matrix_build_piv(Min,Mpiv):-
		matrix_rows(Min,Rows),
		Rows1 is Rows - 1,
		matrix_build_piv_c(Min,Mpiv,Rows1).

matrix_build_piv_c(_,[],0):-!.
matrix_build_piv_c(Mat,[Mh|Mc], Col):-
		matrix_rows(Mat,Rows),
		Rows1 is Rows - 1,
		matrix_build_piv_r(Mat,Mh,Col,Rows1),
		Col1 is Col - 1,
		matrix_build_piv_c(Mat,Mc,Col1).

matrix_build_piv_r(_,[],_,0):-!.
matrix_build_piv_r(M,[Ch|Cc],Col,Row):-
		Col1 is Col + 1, Row1 is Row + 1,
		matrix_elem(M,1,1,A), matrix_elem(M,1,Col1,B), matrix_elem(M,Row1,1,C), matrix_elem(M,Row1,Col1,D),
		Ch is A*D - B*C,
		NextRow is Row - 1,
		matrix_build_piv_r(M,Cc,Col,NextRow).


%% matrix_invert(+Matrix,?InverseMatrix) is det.
%
%  Calcola la matrice inversa.
%
%  @author Moreno

matrix_invert([[A,C],[B,D]], [[Ai,Ci],[Bi,Di]]):-!,
		Divisore is A*D - B*C,
		Ai is  D/Divisore, Ci is -C/Divisore,
		Bi is -B/Divisore, Di is  A/Divisore.

matrix_invert(M,MInv):-
		matrix_rows(M,Rows), matrix_det(M,Det),
		Det \== 0,
		asserta(matrix_rows(M,Rows)),
		asserta(matrix_det(M,Det)),
		matrix_invert_c(M,MInv,Rows),
		retract(matrix_rows(M,Rows)),
		retract(matrix_det(M,Det)), !.

matrix_invert_c(_,[],0):-!,true.
matrix_invert_c(M,[MInvH|MInvC],N):-
		N1 is N - 1,
		matrix_rows(M,Rows),
		matrix_invert_r(M,MInvH,N,Rows), % questa ora e' una colonna, processane gli elem.
		matrix_invert_c(M,MInvC,N1).
		
matrix_invert_r(_,[],_,0):-!,true.
matrix_invert_r(M,[Ch|Cc],Col,N):-
		matrix_det(M,Det), matrix_trasp(M,Mt),
		matrix_rows(M,Rows),
		NReal is Rows - N + 1, ColReal is Rows - Col + 1,
		matrix_minor(Mt,Minor,NReal,ColReal), matrix_det(Minor,MinorDet),
		Ch is (MinorDet/Det * (-1)^(Col+N)),
		N1 is N - 1,
		matrix_invert_r(M,Cc,Col,N1).


%%
%
%  R deve essere la matrice identica matrix_addnoise([Rh|Rc],I, Dim):
%
%  @author Andrea

matrix_addnoise([Rh|C],1,Dim,[Mh|C]):-
	vector_random_noise(V,Dim),
	vector_sum_if0(Rh,V,Mh).

matrix_addnoise([E|C],I,Dim,[E|Mc]):- 
	I1 is I-1,
	matrix_addnoise(C,I1,Dim,Mc).


%% matrix_sum(+M1,+M2,?Somma) is det.
%
%  @author Andrea

matrix_sum([],[],[]).
matrix_sum([M1h|M1b],[M2h|M2b],[Moh|Mob]):-
    vector_sum(M1h,M2h,Moh),
    matrix_sum(M1b,M2b,Mob).


%% matrix_number_mult(+Matrix,+Numero,?MatriceRisultato) is det.
%
%  @author Andrea

matrix_number_mult([],_,[]).
matrix_number_mult([Mh|Mb],N,[Moh|Mob]):-
    vector_number_mult(Mh,N,Moh),
    matrix_number_mult(Mb,N,Mob).