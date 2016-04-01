################################################################################
##
##  simpcomp / pkghomalg.gd
##
##  Loaded when package `homalg' is available
##
##  $Id$
##
################################################################################



## <#GAPDoc Label="homalg">
##
## <Section Label="sec:PkgHomalg">
## <Heading>Interface to the &GAP;-package <Package>homalg</Package></Heading>
##
## As of Version 1.5, <Package>simpcomp</Package> is equipped with an 
## interface to the &GAP;-package <Package>homalg</Package> 
## <Cite Key="HomAlg" /> by Mohamed Barakat. This allows to use 
## <Package>homalg</Package>'s powerful capabilities in the field of 
## homological algebra to compute topological properties of simplicial 
## complexes.<P/>
## For the time being, the only functions provided are ones allowing to 
## compute the homology and cohomology groups of simplicial complexes with 
## arbitrary coefficients. It is planned to extend the functionality in 
## future releases of <Package>simpcomp</Package>. See below for a list of 
## functions that provide an interface to <Package>homalg</Package>.
##  
## <#Include Label="SCHomalgBoundaryMatrices"/>
## <#Include Label="SCHomalgCoboundaryMatrices"/>
## <#Include Label="SCHomalgHomology"/>
## <#Include Label="SCHomalgHomologyBasis"/>
## <#Include Label="SCHomalgCohomology"/>
## <#Include Label="SCHomalgCohomologyBasis"/>
##  
## </Section>
##
## <#/GAPDoc>

KeyDependentOperation("SCHomalgBoundaryMatrices",SCIsSimplicialComplex,
 IsInt,ReturnTrue);
KeyDependentOperation("SCHomalgCoboundaryMatrices",SCIsSimplicialComplex,
 IsInt,ReturnTrue);
KeyDependentOperation("SCHomalgHomology",SCIsSimplicialComplex,IsInt,
 ReturnTrue);
KeyDependentOperation("SCHomalgHomologyBasis",SCIsSimplicialComplex,IsInt,
 ReturnTrue);
KeyDependentOperation("SCHomalgCohomology",SCIsSimplicialComplex,IsInt,
 ReturnTrue);
KeyDependentOperation("SCHomalgCohomologyBasis",SCIsSimplicialComplex,IsInt,
 ReturnTrue);

