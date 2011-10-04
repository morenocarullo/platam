/** <module> Programma per esecuzione test automatici.
  
  @version $Id: test-runall.pl 23 2007-06-05 14:09:44Z utente33 $
*/
:- ensure_loaded('test-liste').
:- ensure_loaded('test-vettori').
:- ensure_loaded('test-matrici').

platam_test:- show_coverage(run_tests).
