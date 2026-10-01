################################################################################
##
##  simpcomp / pkggrape.g
##
##  Package extension, read by GAP once `GRAPE' is loaded. GRAPE needs its
##  dreadnaut binary to compute automorphism groups.
##
################################################################################

if Filename(DirectoriesPackagePrograms("grape"),"dreadnaut")<>fail then
	ReadPackage("simpcomp", "lib/pkggrape.gi");
fi;
