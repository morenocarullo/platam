/** <module> Libreria per vettori, anche su campi GF(p).

   USA: modulo 'liste'.

   @author M.Carullo, A.Carcano
   @version $Id: vettori.pl 35 2007-06-28 20:58:52Z utente33 $
*/
:- ensure_loaded('liste').
:- ensure_loaded('utils').


%% vector_number_mult(+Vettore,+Numero,?VettoreRisultato) is det.
%
%  Moltiplica ogni componente di un vettore per un numero.
%
%  @author Andrea

vector_number_mult([],_,[]).
vector_number_mult([V1h|V1b],N,[V2h|V2b]):-
    V2h is V1h * N,
    vector_number_mult(V1b,N,V2b).


%% vector_dot_product(+Vector1,+Vector2,?Result) is det.
%
%  Prodotto scalare tra due vettori
%  vector_dot_product(V1,V2,Out)
%
%  @author Moreno

vector_dot_product([V1h|[]],[V2h|[]],DotProduct):-!, DotProduct is V1h*V2h.
vector_dot_product([V1h|V1c],[V2h|V2c],DotProduct):-
		vector_dot_product([V1h|[]],[V2h|[]],DotProductParz1),
		vector_dot_product(V1c,V2c,DotProductParz2),
		DotProduct is DotProductParz1 + DotProductParz2.


%% vector_dot_product(+Vector1,+Vector2,?Result,+Gf) is det.
%
%  Prodotto scalare tra due vettori su GF.
%
%  @author Moreno

vector_dot_product(Vin,Vout,DotProduct,0):- vector_dot_product(Vin,Vout,DotProduct), !.
vector_dot_product([V1h|[]],[V2h|[]],DotProduct,Gf):-!, DotProduct is (V1h*V2h) mod Gf.		
vector_dot_product([V1h|V1c],[V2h|V2c],DotProduct,Gf):-
		vector_dot_product([V1h|[]],[V2h|[]],DotProductParz1,Gf),
		vector_dot_product(V1c,V2c,DotProductParz2,Gf),
		DotProduct is (DotProductParz1 + DotProductParz2) mod Gf.
		

%% vector_dot_products(+Mn,+N,?Rn,+Gf)
%
%	NOTA: dal libro del prof.

vector_dot_products([],_,[],_).
vector_dot_products([M1|Mn],N,[R1|Rn],Gf):- vector_dot_products_1(M1,N,R1,Gf), vector_dot_products(Mn,N,Rn,Gf).


%% vector_dot_products_1(+M,+Nn,?Rn,+Gf).
%
%	NOTA: dal libro del prof.

vector_dot_products_1(_,[],[],_).
vector_dot_products_1(M,[N1|Nn],[R1|Rn],Gf):- vector_dot_product(M,N1,R1,Gf), vector_dot_products_1(M,Nn,Rn,Gf).


%% vector_sum(+Vector1,+Vector2,?Result) is det.
%
%  somma di due vettori
%
%  @author Andrea

vector_sum([],[],[]).
vector_sum([V1h|V1c],[V2h|V2c],[VOh|VOc]):- VOh is (V1h + V2h), vector_sum(V1c,V2c,VOc).


%% vector_sum_if0(+Vector1,+Vector2,?Result) is det.
%
%  Sostituisce l'n-esimo elemento di Vector1 con quello di Vector2 se e' = 0.
%  Lo lascia invariato altrimenti, e mette il risultato in Result.
%
%  @author Moreno

vector_sum_if0([],[],[]).
vector_sum_if0([0|V1c],[V2h|V2c],[V2h|VOc]):- vector_sum_if0(V1c,V2c,VOc), !.
vector_sum_if0([V1h|V1c],[_|V2c],[V1h|VOc]):- vector_sum_if0(V1c,V2c,VOc).


%% vector_sum_gf(+Vector1,+Vector2,?Result,+Gf) is nondet.
%
%  somma di due vettori su GF(p).
%
%  @author Andrea

vector_sum_gf([],[],[],_).
vector_sum_gf([V1h|V1c],[V2h|V2c],[VOh|VOc],Gf):- VOh is (V1h + V2h) mod Gf, vector_sum_gf(V1c,V2c,VOc,Gf).
		

%% vector_random_gf(?Vector,+Rows,+Columns,+Gf) is det.
%
% inizializza un vettore random su GF(Gf).
%
%  @author Andrea

vector_random_gf([Vh|[]],1,Gf):-!, Vh is random(Gf).
vector_random_gf([Vh|Vc],Rows,Gf):-!,
		vector_random_gf([Vh|[]],1,Gf),
		RowsMinus1 is Rows - 1,
		vector_random_gf(Vc,RowsMinus1,Gf).


%% vector_random_int(+N,+Intervallo,?Vout) is det.
%  
%  Genera un vettore random nell'intervallo {-l......+l}
% 
%  @author Andrea

vector_random_int(0,_,[]):-!, true.
vector_random_int(Dim,Int,[VOh|VOc]):-
	X is Int - random(Int*2),
	VOh is X,
	Dim1 is Dim - 1,
	vector_random_int(Dim1, Int, VOc).

		
%% vector_error(+Dimensione,+Sigma,?Vout) is det.
%  
%  Genera un vettore di dimensione N, ed in ogni dimensione
%  mette il valore +sigma o -sigma.
%
%  @author Andrea

vector_error(0,_,[]):-!, true.
vector_error(N,Sigma,[VOh|VOc]):-
    random_omo(X),
    VOh is Sigma*X,
    N1 is N - 1,
    vector_error(N1, Sigma, VOc).
	

%% vector_uno(+Dim,+Pos,?Vout)
%	
%  L = lunghezza vettore
%  P = posizione in cui inserire 1
%  Vout = Vettore in uscita
%  Utilizzando il predicato vector_unoi, mette uno nella posizione P
%
%  @author Andrea
	
vector_uno(Dim,Pos,Vout):- 
	X is (Dim+1) - Pos,
	vector_unoi(Dim,X,Vout). 


%% vector_unoi(+Lunghezza,+PosizioneUno,?Vettore) is det.
%	
%  Mette 1 nella posizione P partendo dal fondo
%
%  @author Andrea

vector_unoi(0,_,[]):-!,true.
vector_unoi(L,L,[1|Vc]):-!,
	L1 is L-1,
	vector_unoi(L1,L,Vc).
vector_unoi(L,P,[0|Vc]):-
	L1 is L-1,
	vector_unoi(L1,P,Vc).


%% vector_random_noise(?VettoreRandom,+Rows).
%
%  Genera un vettore di rumore con valori compresi tra {-1,0,1}
%
%  @author Andrea

vector_random_noise([Vh|[]],1):-!, random_ng(Vh).
vector_random_noise([Vh|Vc],Rows):-!,
		vector_random_noise([Vh|[]],1),
		RowsMinus1 is Rows - 1,
		vector_random_noise(Vc,RowsMinus1).


%% vector_round(+Vettore,?VettoreRounded) is det.
%
%  Arrotonda un vettore di reali, e ogni componente contiene l'intero piu' vicino.
%
%  @author Andrea

vector_round([],[]).
vector_round([V1h|V1b],[V2h|V2b]):-
    V2h is round(V1h),
    vector_round(V1b,V2b).