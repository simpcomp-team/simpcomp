################################################################################
##
##  simpcomp / homology.gd
##
##  Homology related functions
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="homology">
##
## Although <Package>simpcomp</Package> makes use of the &GAP; package ''homology'' <Cite Key="Dumas04Homology" /> for its homology calculations whenever possible (due to efficiency reasons), <Package>simpcomp</Package> comes with an own (co-)homology algorithm as well as some additional homology related functionality, which will be explained in this chapter. 
##
## <Section>
## <Heading>Homology computation</Heading>
##
## Apart from calculating boundaries of simplices, boundary matrices or the simplicial homology of a given complex, <Package>simpcomp</Package> is also able to compute a basis of the homology groups.
##
## <#Include Label="SCBoundaryOperatorMatrix"/>
## <#Include Label="SCBoundarySimplex"/>
## <#Include Label="SCHomologyBasis"/>
## <#Include Label="SCHomologyBasisAsSimplices"/>
## <#Include Label="SCHomologyInternal"/>
##
## </Section>
##
## <Section>
## <Heading>Cohomology computation</Heading>
## 
## <Package>simpcomp</Package> can also compute the cohomology groups of simplicial complexes, bases of these cohomology groups, the cup product of two cocycles and the intersection form of (orientable) 4-manifolds.
##
## <#Include Label="SCCoboundaryOperatorMatrix"/>
## <#Include Label="SCCohomology"/>
## <#Include Label="SCCohomologyBasis"/>
## <#Include Label="SCCohomologyBasisAsSimplices"/>
## <#Include Label="SCCupProduct"/>
## <#Include Label="SCIntersectionForm"/>
## <#Include Label="SCIntersectionFormParity"/>
## <#Include Label="SCIntersectionFormDimensionality"/>
## <#Include Label="SCIntersectionFormSignature"/>
##
## </Section>
##
##
##<#/GAPDoc>

DeclareGlobalFunction("SCBoundarySimplex");
DeclareGlobalFunction("SCCupProduct");
DeclareGlobalFunction("SCHomologyInternal");

KeyDependentOperation("SCBoundaryOperatorMatrix",SCIsSimplicialComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCCoboundaryOperatorMatrix",SCIsSimplicialComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCCohomologyBasis",SCIsSimplicialComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCCohomologyBasisAsSimplices",SCIsSimplicialComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCHomologyBasis",SCIsSimplicialComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCHomologyBasisAsSimplices",SCIsSimplicialComplex,IsInt,ReturnTrue);

DeclareAttribute("SCCohomology",SCIsPolyhedralComplex);
DeclareAttribute("SCIntersectionForm",SCIsPolyhedralComplex);
DeclareAttribute("SCIntersectionFormParity",SCIsPolyhedralComplex);
DeclareAttribute("SCIntersectionFormDimensionality",SCIsPolyhedralComplex);
DeclareAttribute("SCIntersectionFormSignature",SCIsPolyhedralComplex);

################################################################################

