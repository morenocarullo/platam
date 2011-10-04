#
# Universita' degli Studi dell'Insubria
# Progetto di Logica Computazionale II
#  di A.Carcano, M.Carullo
#
# $Id: Makefile 22 2007-06-04 13:37:38Z utente33 $
#

PROLOG=swipl

#
# Esegue i test automatici
tests:
	@cd src; ${PROLOG} -t platam_test -s test-runall.pl
