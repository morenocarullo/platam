/** <module> Utilita` varie.

    $Id: utils.pl 27 2007-06-25 19:42:15Z utente33 $
*/


%% random_omo(?Numero)
%
%  Genera in N un numero pari a -1 o +1.
%
%  @author Andrea

random_omo(N):- X is random(2), random_omo_u(X, N).
random_omo_u(0, -1):- true. 
random_omo_u(1, 1):- true.


%% random_ng(?Numero)
%
%  Genera -1, 0 o +1 .
%
%  @author Andrea

random_ng(N):- X is random(3), random_ng_u(X, N).
random_ng_u(0, 0):- true.
random_ng_u(1, 1):- true.
random_ng_u(2, -1):- true.
