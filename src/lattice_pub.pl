/** <module> criptografia a chiave pubblica.

	USA: modulo 'matrici'.
	
	@author A.Carcano, M.Carullo
	@version $Id: lattice_pub.pl 37 2007-06-29 15:49:41Z utente33 $
*/
:- ensure_loaded('matrici').


%% lattice_pk_encrypt(+Messaggio,?MessaggioCriptato,+ChiavePubblica) is det.
%
% Cripta un messaggio lungo a piacere usando una chiave pubblica.
%
% @author Moreno

lattice_pk_encrypt(Messaggio,CriptMessaggio,ChiavePubblica):-
		matrix_rows(ChiavePubblica,BlockSize),
		lunghezza(Messaggio,Lunghezza),
		lista_join([Lunghezza],Messaggio,Messaggio1),
		asserta(matrix_rows(ChiavePubblica,BlockSize)),
		lista_split(Messaggio1,BlockSize,MessageList),
		lattice_pk_encrypt_list(MessageList,CriptMessaggio,ChiavePubblica),
		retract(matrix_rows(ChiavePubblica,BlockSize)).

lattice_pk_encrypt_list([],[],_):-!,true.
lattice_pk_encrypt_list([Lh|Lb],CriptMessaggio,ChiavePubblica):-
		matrix_rows(ChiavePubblica,Rows), lista_fillto(Lh,LhFilled,Rows),
		lattice_pk_encrypt_base(LhFilled,CriptBlocco,ChiavePubblica),
		lattice_pk_encrypt_list(Lb,CriptResto,ChiavePubblica),
		lista_join(CriptBlocco,CriptResto,CriptMessaggio).
	
lattice_pk_encrypt_base(Mex,Cript,PK):-
		matrix_vector_mult(PK,Mex,VTmp,0),
		matrix_rows(PK,Size),
		SigmaError is 0.5 - random(65536)/65536,
		vector_error(Size,SigmaError,VError),
		vector_sum(VTmp,VError,Cript).


%% lattice_pk_decrypt(+CypherText,?PlainText,+PrivateKey,+PublicKey) is det.
%
%
% @author Moreno

lattice_pk_decrypt(CriptMessaggio,Messaggio,ChiavePrivata,ChiavePubblica):-
		matrix_rows(ChiavePubblica,BlockSize),
		asserta(matrix_rows(ChiavePubblica,BlockSize)),
		lista_split(CriptMessaggio,BlockSize,CriptMessageList),
		lattice_pk_decrypt_list(CriptMessageList,[Mh|Mb],ChiavePrivata,ChiavePubblica),
		lista_cut_length(Mb,Mh,Messaggio),
		retract(matrix_rows(ChiavePubblica,BlockSize)).


%% lattice_pk_decrypt_list(+ListaBlocchiCypher,?PlainText,+PrivateKey,+PublicKey) is det.
%
% Decripta una lista di blocchi di messaggi.
%
% @author Moreno

lattice_pk_decrypt_list([],[],_,_):-!.
lattice_pk_decrypt_list([Lh|Lb],Messaggio,ChiavePrivata,ChiavePubblica):-
		matrix_rows(ChiavePubblica,Rows), lista_fillto(Lh,LhFilled,Rows),
		lattice_pk_decrypt_base(LhFilled,DeCriptBlocco,ChiavePrivata,ChiavePubblica),
		lattice_pk_decrypt_list(Lb,DeCriptResto,ChiavePrivata,ChiavePubblica),
		lista_join(DeCriptBlocco,DeCriptResto,Messaggio).


%% lattice_pk_decrypt_base(?CriptMessaggio,+Messaggio,+R,+B) is det.
%  
%  Dato un messaggio, lo decripta.
%
%  Rif dal paper: trova p', molt. R' da p' ritrova x invertendo B
%
%  @author Andrea

lattice_pk_decrypt_base(CriptMessaggio,Messaggio,R,B):-
		matrix_invert(R, Rinv), matrix_vector_mult(Rinv, CriptMessaggio, Coeff, 0),
		vector_round(Coeff, CoeffInteri), matrix_vector_mult(R, CoeffInteri, PiPrimo, 0),
		matrix_invert(B,Binv), matrix_vector_mult(Binv, PiPrimo, Messaggio1, 0),
		vector_round(Messaggio1,Messaggio).


%% lattice_pk_priv_gen(+Size,+Gf,?R) is det.
%	
%  Genera la base R, ovvero la chiave privata.
%  Rows e' il numero di vettori della base, Cols la dimensione dei vettori,
%  Gf il campo di Galois su cui generarle, R la base risultante.
%
% @author Andrea

lattice_pk_priv_gen(Size,Int,Mpk):-
	matrix_i(Mi,Size,Size), 
	matrix_random_interval(Mrp,Size,Size,Int),
	Times is Rows * 2,
	matrix_number_mult(Mi,Times,Mik),
	matrix_sum(Mik,Mrp,Mpk).


%% lattice_pk_pub_gen(+PrivateKey, ?PublicKey) is det.
%
% Prende la privata e la moltiplica n volte per l'identica "modificata" con rumore.
%
% @author Andrea

lattice_pk_pub_gen(PrivK, PubK):-
		matrix_rows(PrivK, Rows),
		matrix_i(Mi,Rows,Rows),
		asserta(matrix_rows(PrivK, Rows)),
		asserta(matrix_i(Mi,Rows,Rows)),
		lattice_pk_pub_gen_u(PrivK, Rows , PubK),
		retract(matrix_rows(PrivK, Rows)),
		retract(matrix_i(Mi,Rows,Rows)).	

lattice_pk_pub_gen_u(M, 0, M).
lattice_pk_pub_gen_u(Mr, N, Mo):-
		matrix_rows(Mr, Rows),
		matrix_i(Mi, Rows, Rows), 
		matrix_addnoise(Mi, N, Rows, Minoise),
		matrix_matrix_mult(Mr, Minoise, 0, Mt),
		N1 is N - 1,
		lattice_pk_pub_gen_u(Mt, N1, Mo).
		

%
% Prova di query:
%  ?- lattice_pk_priv_gen(8,2,Private), lattice_pk_pub_gen(Private,Public),
%     lattice_pk_encrypt("Corso di Logica II", CypherText, Public),
%     lattice_pk_decrypt(CypherText, PlainText, Private, Public),
%     string_to_list(Testo,PlainText).
%