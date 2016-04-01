################################################################################
##
##  simpcomp / pkggrape.gi
##
##  Loaded when `GRAPE' package is not available
##
##  $Id$
##
################################################################################
InstallMethod(SCAutomorphismGroup,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
	function(complex)

	local G;
	
	G:=SCAutomorphismGroupInternal(complex);
	if G = fail then
		return fail;
	else
			return G;
	fi;
end);

