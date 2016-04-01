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
## By default, <Package>simpcomp</Package> uses an algorithm based on discrete Morse theory (see Chapter <Ref Chap="chap:DMT" />, <Ref Meth="SCHomology" />) 
## for its homology computations. However, some additional (co-)homology related functionality cannot be realised using this algorithm. 
## For this, <Package>simpcomp</Package> contains an additional (co-)homology algorithm (cf. <Ref Func="SCHomologyInternal" />), which will be presented in this chapter.<P />
##
## Furthermore, whenever possible <Package>simpcomp</Package> makes use of the &GAP; package ''homology'' <Cite Key="Dumas04Homology" />, for an alternative method to calculate
## homology groups (cf. <Ref Func="SCHomologyClassic" />) which sometimes is much faster than the built-in discrete Morse theory algorithm. 
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

