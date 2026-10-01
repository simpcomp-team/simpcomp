################################################################################
##
##  simpcomp / init.g
##
##  init.g for package simpcomp
##
################################################################################

DeclareInfoClass("InfoSimpcomp");
SetInfoLevel(InfoSimpcomp,1);

DeclareGlobalFunction("SCInfoLevel");

BindGlobal("SCIntFunc",rec());

ReadPackage("simpcomp","lib/propobject.gd");
ReadPackage("simpcomp","lib/tools.gd");
ReadPackage("simpcomp","lib/complex.gd");
ReadPackage("simpcomp","lib/io.gd");
ReadPackage("simpcomp","lib/lib.gd");
ReadPackage("simpcomp","lib/DMT.gd");
ReadPackage("simpcomp","lib/glprops.gd");
ReadPackage("simpcomp","lib/operations.gd");
ReadPackage("simpcomp","lib/labelops.gd");
ReadPackage("simpcomp","lib/generate.gd");
ReadPackage("simpcomp","lib/class3mflds.gd");
ReadPackage("simpcomp","lib/bistellar.gd");
ReadPackage("simpcomp","lib/homology.gd");
ReadPackage("simpcomp","lib/normalsurface.gd");
ReadPackage("simpcomp","lib/morse.gd");
ReadPackage("simpcomp","lib/fromgroup.gd");
ReadPackage("simpcomp","lib/blowups.gd");
ReadPackage("simpcomp","lib/highlySymmetricSurfaces.gd");
ReadPackage("simpcomp","lib/isosig.gd");



# checks if package 'homology' is present and working
SCIntFunc.SetupHomology:=function()
	local success;
	success:=IsPackageMarkedForLoading("homology", ">=1.4.2");
	if success=true and IsBoundGlobal("SimplicialHomology") and not ForAny( ["homology_gap","smithform_gap"], file -> Filename(DirectoriesPackagePrograms("homology"), file) = fail) then
		return true;
	else
		return false;
	fi;
end;


if(SCIntFunc.SetupHomology()=false) then
	LogPackageLoadingMessage(PACKAGE_ERROR,"package `homology' not installed or its binaries are not available, falling back to (slower) internal homology algorithms.","simpcomp");
fi;

