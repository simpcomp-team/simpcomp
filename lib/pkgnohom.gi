################################################################################
##
##  simpcomp / pkgnohom.gi
##
##  Loaded when `homology' package is not available
##
##  $Id$
##
################################################################################

InstallMethod(SCHomology,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
	function(complex)

	if(not SCIsSimplicialComplex(complex)) then
		Info(InfoSimpcomp,1,"SCHomology: first argument must be of type SCSimplicialComplex.");
		return fail;
	fi;

	return SCHomologyInternal(complex);
end);

