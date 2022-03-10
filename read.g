################################################################################
##
##  simpcomp / read.g
##
##  read.g for package simpcomp
##
##  $Id$
##
################################################################################

BindGlobal("SCSettings",
rec(
BreakOnError:=false,
MailOnError:=false
));

SCIntFunc.Version:=GAPInfo.PackageCurrent.Version;

InstallGlobalFunction(SCInfoLevel,
function(level)
  SetInfoLevel(InfoSimpcomp,level);
  return true;
end);

ReadPackage("simpcomp","lib/propobject.gi");
ReadPackage("simpcomp","lib/complex.gi");
ReadPackage("simpcomp","lib/tools.gi");
ReadPackage("simpcomp","lib/io.gi");
ReadPackage("simpcomp","lib/lib.gi");

#overlay some functions of homology packge, if present
ReadPackage("simpcomp", "lib/pkghom.gd");

ReadPackage("simpcomp", "lib/DMT.gi");
ReadPackage("simpcomp","lib/glprops.gi");
ReadPackage("simpcomp","lib/operations.gi");
ReadPackage("simpcomp","lib/labelops.gi");
ReadPackage("simpcomp","lib/generate.gi");
ReadPackage("simpcomp","lib/class3mflds.gi");
ReadPackage("simpcomp","lib/bistellar.gi");
ReadPackage("simpcomp", "lib/homology.gi");
ReadPackage("simpcomp", "lib/normalsurface.gi");
ReadPackage("simpcomp", "lib/morse.gi");
ReadPackage("simpcomp", "lib/fromgroup.gi");
ReadPackage("simpcomp", "lib/blowups.gi");
ReadPackage("simpcomp", "lib/highlySymmetricSurfaces.gi");
ReadPackage("simpcomp", "lib/isosig.gi");


#load `homology' package specific functions if available
if(SCIntFunc.SetupHomology()=false) then
	ReadPackage("simpcomp", "lib/pkgnohom.gi");
else
	ReadPackage("simpcomp", "lib/pkghom.gi");
fi;

#load `GRAPE' package specific functions if available
if(SCIntFunc.SetupGrape()=false) then
	ReadPackage("simpcomp", "lib/pkgnogrape.gi");
else
	ReadPackage("simpcomp", "lib/pkggrape.gi");
fi;

#load `homalg' package specific functions if available
if(SCIntFunc.SetupHomalg()=true) then
	ReadPackage("simpcomp", "lib/pkghomalg.gi");
fi;

SCSettings.ComplexCounter:=1;
SCIntFunc.CheckExternalProgramsAvailability();
ReadPackage("simpcomp", "lib/prophandler.gd");

#load global library
InstallValue(SCLib,SCIntFunc.SCLibGlobalInit());
