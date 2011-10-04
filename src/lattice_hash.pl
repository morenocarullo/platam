/** <module> Funzione hash criptografica.

   USA: modulo 'matrici'.

   @author M.Carullo, A.Carcano
   @version $Id: lattice_hash.pl 37 2007-06-29 15:49:41Z utente33 $
*/
:- consult('matrici').


%% latthash(+Mat,+Gf,+LongString,?Hash)
%
%  Funzione hash applicabile su stringa di bit lunga a piacere.
%  Esempi di query:
%
%   ?- matrix_random_gf(M,200,8,2097152),
%      latthash(M,2097152,[0,1,1,0,1,0],Hash),
%      latthash(M,2097152,[0,1,0,0,1,0],Hash2).
%
%  @author Moreno

latthash(Mat,Gf,LongString,Hash):-
		matrix_rows(Mat,MatrixRows),
		matrix_cols(Mat,MatrixColumns),
		latthash_check_sp(MatrixColumns,MatrixRows,Gf),
		lista_split(LongString,MatrixRows,BlockList),
		latthash_list(Mat,Gf,BlockList,Hash).


%% latthash_base(+Mat,+Gf,+BlockString,?Hash)
%
%  Funzione hash applicabile sul blocco.
%
%  @author Moreno

latthash_base(Mat,Gf,BlockString,Hash):-
		matrix_vector_mult(Mat,BlockString,Hash,Gf).


%
% Funzione hash, che opera su liste di vettori.
%
%  @author Moreno

latthash_list(Mat,Gf,[Bh|[]],Hash):-
		matrix_rows(Mat,MatrixRows),
		lista_fillto(Bh,BhFilled,MatrixRows),
		latthash_base(Mat,Gf,BhFilled,Hash).

%
% Il passo induttivo mette insieme gli hash di due blocchi usando la somma su GF.
%
%  @author Moreno

latthash_list(Mat,Gf,[Bh|Bc],Hash):-
		latthash_list(Mat,Gf,[Bh],HashOne),
		latthash_list(Mat,Gf,Bc,HashTwo),
		vector_sum_gf(HashOne,HashTwo,Hash,Gf).


%% latthash_check_sp(N,M,Q) is det.
%
%  Prova di query: ?- latthash_check_sp(8,200,2097152).  [Yes]
%		
%  @author Moreno

latthash_check_sp(N,M,Q):- V1 is N*log(Q), V2 is Q/(2*N^4), V1 < M, M < V2, !.
latthash_check_sp(_,_,_):- write('ERROR: Security parameters n,m and q are not valid.'), nl, fail.