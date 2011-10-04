/*
   MODULO: liste

   $Id: liste.pl 37 2007-06-29 15:49:41Z utente33 $
*/

%
%   lista(L)
%
% PARAM (I): L lista
% OUT:       yes se L e' una lista
%
lista([]).
lista([_|C]) :- lista(C).

%
%   appartiene(E, L)
%  
% PARAM (I): E elemento
% PARAM (I): L lista
%
appartiene(E, [E|_]).
appartiene(E, [_|C]):- appartiene(E, C).

%
%   lunghezza(L, N)
%
% PARAM (I): L lista
% PARAM (O): N lunghezza
%
lunghezza([], 0).
lunghezza([_|C], N):- lunghezza(C, N0), N is N0 +1.

%
%   posizione(E, L, N)
%
% PARAM (I): E elemento
% PARAM (I): L lista
% PARAM (O): N posizione intera (si parte da 1)
%
posizione(E, [E|_], 1).
posizione(E, [_|C], N):- appartiene(E, C), posizione(E, C, N0), N is N0 + 1.

%
%   minimo(L, N)
%
% PARAM (I): L lista
% PARAM (O): N elem. minimo
%
minimo([E|[]], E):-!.
minimo([E|C], E):- minimo(C, N), E < N, !.
minimo([_|C], N):- minimo(C, N).


%
%   massimo(L, N)
%
% PARAM (I): L lista
% PARAM (O): N elem. massimo
%
massimo([E|[]], E):-!.
massimo([E|C], E):- massimo(C, N), E > N, !.
massimo([_|C], N):- massimo(C, N).


%% lista_elem(+Lista, +Posizione, ?EnnesimoElemento) is det.
%
%  Ottiene l'N esimo elemento
%
%  @author Andrea

lista_elem([E|_],1,E):-!.
lista_elem([_|C],N,O):- N1 is N-1, lista_elem(C,N1,O).

%% lista_elem_canc(+Lin,+N,?Lout) is det.
%
%  Elimina l'N esimo elemento.
%
%  @author Andrea

lista_elem_canc([],_,[]):-!.
lista_elem_canc([_|C],1,C):-!.
lista_elem_canc([E|Lin],N,[E|Lout]):- N1 is N - 1, lista_elem_canc(Lin,N1,Lout).


%% liste_elem_canc(+Lista, +Elemento, ?ListaRisultato) is det.
%
%  Elimina l'N esimo elemento da ogni lista di una lista di liste
%
%  @author Andrea

liste_elem_canc([],_,[]):-!.
liste_elem_canc([EIn|LItail],N,[EOut|LOtail]):-
		lista_elem_canc(EIn,N,EOut),
		liste_elem_canc(LItail,N,LOtail).


%% lista_notnull(+Lista,?Pos,?A) is nondet,
%
%  Preleva gli elementi della lista non nulli. Istanzia in Pos la posizione e in A l'elemento.
%
%  @author Moreno

lista_notnull([E|_],1,E):- E =\= 0.
lista_notnull([_|L],Pos,E):- lista_notnull(L,Pos1,E), Pos is Pos1 + 1.


%
% Unisce due liste
%
%  @author Moreno

lista_join([],L,L).
lista_join([X|L1],L2,[X|L3]):- lista_join(L1,L2,L3).


%% lista_inverti(+Lista,?ListaInvertita) is det.
%
%  @author Moreno

lista_inverti([],[]):-!.
lista_inverti([E|C],L):- lista_inverti(C,L1), lista_join(L1,[E],L).


%
% Crea una lista lunga N di 'zeri'.
%
%  @author Moreno

lista_blank([], 0):- !,true.
lista_blank([0|C], N):- N1 is N - 1, lista_blank(C,N1).


%% lista_fillto(+ListaIniziale,?ListaRiempita,+LunghezzaDesiderata) is det.
%
%  Appende ad una lista degli 0 fino al raggiungimento della lunghezza desiderata.
%
%  @author Moreno 

lista_fillto(L,ListaTotale,LunghDesiderata):-
            lunghezza(L,LunghezzaAttuale),
            LunghezzaAttuale < LunghDesiderata,!,
            LunghBlank is LunghDesiderata - LunghezzaAttuale,
            lista_blank(Gen,LunghBlank),
            lista_join(L,Gen,ListaTotale).

lista_fillto(L,L,LunghDesiderata):- lunghezza(L,LunghDesiderata).


%% lista_scroll(+Lista,?ListaRisult) is nondet.
%
%  @author Moreno

lista_scroll([E|C],L):- lista_join(C,[E],L).
		

%% lista_cut_length(+Lista,+Lunghezza,?ListaTagliata) is det.
%
%  Prende Lista e mette in ListaTagliata i primi `Lunghezza' elementi.
%
%  @author Moreno

lista_cut_length(_,0,[]):- !.
lista_cut_length([E|C1],N,[E|C2]):- N1 is N - 1, lista_cut_length(C1,N1,C2).


%% lista_split(+Lista,+Block,?Out) is det.
%
%  Splitta la Lista in blocchi di lunghezza Block.
%  si ottengono |Lista|/Block blocchi, visti come elementi
%  di una lista.
%	
%  proceduralmente: leggi il vettore, se hai letto Block splitta.
%  nota:            l`uso attento del cut permette di ottimizzare.
%  prova di query:
%	
%  ?:- lista_split([0,1,0,1],2,X).
%
%	X = [[0,1], [0,1]]
%
%  @author Moreno

lista_split(Lista,Block,Out):-
                lista_split_aux(Lista,Block,[],0,[],Out1),
                lista_inverti(Out1,Out).
		
lista_split_aux([Vh|Vc],BlSize,Tc,N,BList,Out):-
		N < BlSize,!,
		N1 is N + 1,
                lista_join(Tc,[Vh],Tmplist),
		lista_split_aux(Vc,BlSize,Tmplist,N1,BList,Out).

lista_split_aux([],_,[],_,Out,Out):-!.
lista_split_aux(V,BlSize,T,_,Bc,Out):-
		lista_split_aux(V,BlSize,[],0,[T|Bc],Out).
