################################################################################
##
##  simpcomp / pkgnohom.gi
##
##  Loaded when `homology' package is not available
##
##  $Id$
##
################################################################################

InstallGlobalFunction(SCHomologyClassic,
	function(complex)

	if(not SCIsPolyhedralComplex(complex)) then
		Info(InfoSimpcomp,1,"SCHomologyClassic: first argument must be of type SCIsPolyhedralComplex.");
		return fail;
	fi;

	if HasSCHomology(complex) then
		return SCHomology(complex);
	fi;

	return SCHomologyInternal(complex);
end);

