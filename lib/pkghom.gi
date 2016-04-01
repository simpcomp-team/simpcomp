################################################################################
##
##  simpcomp / pkghom.gi
##
##  Loaded when `homology' package is available
##
##  $Id$
##
################################################################################


#setup homology package settings
SetHomologyAlgorithm(EliminateGMPAlgorithm);
SetHomologyGroupFormat(GapFormat);
HomologyInfo(0);

InstallGlobalFunction(SCHomologyClassic,
function(complex)

	local hom,facets;

	if(not SCIsSimplicialComplex(complex)) then
		Info(InfoSimpcomp,1,"SCHomologyClassic: first argument must be of type SCSimplicialComplex.");
		return fail;
	fi;

	if HasSCHomology(complex) then
		return SCHomology(complex);
	fi;
	
	if not IsBoundGlobal("SimplicialHomology") then
		return SCHomologyInternal(complex);
	fi;
	
	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;
	
	SetHomologyAlgorithm(EliminateGMPAlgorithm);
	SetHomologyGroupFormat(GapFormat);
	HomologyInfo(0);
	hom:=SimplicialHomology(facets);
	
	if(hom=fail) then
		Info(InfoSimpcomp,1,"SCHomologyClassic: computing homology failed.");
		return fail;
	fi;
	
	if IsBound(hom[1]) and hom[1]=[0,[]] then
		SetSCIsConnected(complex,true);
	else
		SetSCIsConnected(complex,false);
	fi;

	SetSCHomology(complex,hom);
	return hom;
end);

