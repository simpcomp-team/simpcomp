################################################################################
##
##  simpcomp / glprops.gd
##
##  Compute Global Properties of Simplicial Complexes.  
##
##  $Id$
##
################################################################################

## GAPDoc include
## <#GAPDoc Label="glprops">
## <Section Label="sec:glprops"> 
## <Heading>Computing properties of simplicial complexes</Heading>
##
## The following functions compute basic properties of simplicial complexes of type <C>SCSimplicialComplex</C>. None of these functions alter the complex. All properties are returned as immutable objects (this ensures data consistency of the cached properties of a simplicial complex). Use <C>ShallowCopy</C> or the internal <Package>simpcomp</Package> function <C>SCIntFunc.DeepCopy</C> to get a mutable copy.<P/>
## Note: every simplicial complex is internally stored with the standard vertex labeling from <M>1</M> to <M>n</M> and a maptable to restore the original vertex labeling. Thus, we have to relabel some of the complex properties (facets, face lattice, generators, etc...) whenever we want to return them to the user. As a consequence, some of the functions exist twice, one of them with the appendix "Ex". These functions return the standard labeling whereas the other ones relabel the result to the original labeling.
##
## <#Include Label="SCAltshulerSteinberg"/>
## <#Include Label="SCAutomorphismGroup"/>
## <#Include Label="SCAutomorphismGroupInternal"/>
## <#Include Label="SCAutomorphismGroupSize"/>
## <#Include Label="SCAutomorphismGroupStructure"/>
## <#Include Label="SCAutomorphismGroupTransitivity"/>
## <#Include Label="SCBoundary"/>
## <#Include Label="SCDehnSommervilleCheck"/>
## <#Include Label="SCDehnSommervilleMatrix"/>
## <#Include Label="SCDifferenceCycles"/>
## <#Include Label="SCDim"/>
## <#Include Label="SCDualGraph"/>
## <#Include Label="SCEulerCharacteristic"/>
## <#Include Label="SCFVector"/>
## <#Include Label="SCFaceLattice"/>
## <#Include Label="SCFaceLatticeEx"/>
## <#Include Label="SCFaces"/>
## <#Include Label="SCFacesEx"/>
## <#Include Label="SCFacets"/>
## <#Include Label="SCFacetsEx"/>
## <#Include Label="SCFpBettiNumbers"/>
## <#Include Label="SCFundamentalGroup"/>
## <#Include Label="SCGVector"/>
## <#Include Label="SCGenerators"/>
## <#Include Label="SCGeneratorsEx"/>
## <#Include Label="SCHVector"/>
## <#Include Label="SCHasBoundary"/>
## <#Include Label="SCHasInterior"/>
## <#Include Label="SCHeegaardSplittingSmallGenus"/>
## <#Include Label="SCHeegaardSplitting"/>
## <#Include Label="SCHomologyClassic"/>
## <#Include Label="SCIncidences"/>
## <#Include Label="SCIncidencesEx"/>
## <#Include Label="SCInterior"/>
## <#Include Label="SCIsCentrallySymmetric"/>
## <#Include Label="SCIsConnected"/>
## <#Include Label="SCIsEmpty"/>
## <#Include Label="SCIsEulerianManifold"/>
## <#Include Label="SCIsFlag"/>
## <#Include Label="SCIsHeegaardSplitting"/>
## <#Include Label="SCIsHomologySphere"/>
## <#Include Label="SCIsInKd"/>
## <#Include Label="SCIsKNeighborly"/>
## <#Include Label="SCIsOrientable"/>
## <#Include Label="SCIsPseudoManifold"/>
## <#Include Label="SCIsPure"/>
## <#Include Label="SCIsShellable"/>
## <#Include Label="SCIsStronglyConnected"/>
## <#Include Label="SCMinimalNonFaces"/>
## <#Include Label="SCMinimalNonFacesEx"/>
## <#Include Label="SCNeighborliness"/>
## <#Include Label="SCNumFaces"/>
## <#Include Label="SCOrientation"/>
## <#Include Label="SCSkel"/>
## <#Include Label="SCSkelEx"/>
## <#Include Label="SCSpanningTree"/>
## </Section>
## <#/GAPDoc>

if not IsBound(IsEmpty) then
  DeclareFilter("IsEmpty");
fi;

DeclareAttribute("SCAltshulerSteinberg",SCIsPolyhedralComplex);
DeclareAttribute("SCAutomorphismGroup",SCIsPolyhedralComplex);
DeclareAttribute("SCAutomorphismGroupSize",SCIsPolyhedralComplex);
DeclareAttribute("SCAutomorphismGroupStructure",SCIsPolyhedralComplex);
DeclareAttribute("SCAutomorphismGroupTransitivity",SCIsPolyhedralComplex);
DeclareAttribute("SCBoundaryEx",SCIsPolyhedralComplex);
DeclareAttribute("SCCentrallySymmetricElement",SCIsPolyhedralComplex);
DeclareAttribute("SCDifferenceCycles",SCIsPolyhedralComplex);
DeclareAttribute("SCDim",SCIsPolyhedralComplex);
DeclareAttribute("SCDualGraph",SCIsPolyhedralComplex);
DeclareAttribute("SCEulerCharacteristic",SCIsPolyhedralComplex);
DeclareAttribute("SCFacetsEx",SCIsPolyhedralComplex);
DeclareAttribute("SCFundamentalGroup",SCIsPolyhedralComplex);
DeclareAttribute("SCFVector",SCIsPolyhedralComplex);
DeclareAttribute("SCGVector",SCIsPolyhedralComplex);
DeclareAttribute("SCGeneratorsEx",SCIsPolyhedralComplex);
DeclareAttribute("SCHVector",SCIsPolyhedralComplex);
DeclareAttribute("SCHasBoundary",SCIsPolyhedralComplex);
DeclareAttribute("SCHasInterior",SCIsPolyhedralComplex);
DeclareGlobalFunction("SCHomologyClassic");
DeclareAttribute("SCInterior",SCIsPolyhedralComplex);
DeclareAttribute("SCIsCentrallySymmetric",SCIsPolyhedralComplex);
DeclareAttribute("SCIsConnected",SCIsPolyhedralComplex);
DeclareAttribute("SCIsEmpty",SCIsPolyhedralComplex);
DeclareAttribute("SCIsEulerianManifold",SCIsPolyhedralComplex);
DeclareAttribute("SCIsFlag",SCIsPolyhedralComplex);
DeclareAttribute("SCIsHomologySphere",SCIsPolyhedralComplex);
DeclareAttribute("SCIsOrientable",SCIsPolyhedralComplex);
DeclareAttribute("SCIsPseudoManifold",SCIsPolyhedralComplex);
DeclareAttribute("SCIsPure",SCIsPolyhedralComplex);
DeclareAttribute("SCIsShellable",SCIsPolyhedralComplex);
DeclareAttribute("SCIsStronglyConnected",SCIsPolyhedralComplex);
DeclareAttribute("SCMinimalNonFacesEx",SCIsPolyhedralComplex);
DeclareAttribute("SCNeighborliness",SCIsPolyhedralComplex);
DeclareAttribute("SCOrientation",SCIsPolyhedralComplex);
DeclareAttribute("SCShelling",SCIsPolyhedralComplex); # implemented in operations.gi
DeclareAttribute("SCSpanningTree",SCIsPolyhedralComplex);
DeclareAttribute("SCTopologicalType",SCIsPolyhedralComplex);
DeclareAttribute("SCVertices",SCIsPolyhedralComplex);

DeclareOperation("SCIsHeegaardSplitting",[SCIsPolyhedralComplex,IsList]);
DeclareOperation("SCHeegaardSplittingSmallGenus",[SCIsPolyhedralComplex]);
DeclareOperation("SCHeegaardSplitting",[SCIsPolyhedralComplex]);
DeclareOperation("SCAutomorphismGroupInternal",[SCIsPolyhedralComplex]);
DeclareOperation("SCBoundary",[SCIsPolyhedralComplex]);
DeclareOperation("SCDehnSommervilleCheck",[SCIsPolyhedralComplex]);
DeclareOperation("SCDehnSommervilleMatrix",[IsPosInt]);
DeclareOperation("SCFaceLattice",[SCIsPolyhedralComplex]);
DeclareOperation("SCFaceLatticeEx",[SCIsPolyhedralComplex]);
DeclareOperation("SCFacets",[SCIsPolyhedralComplex]);
DeclareOperation("SCGenerators",[SCIsPolyhedralComplex]);
DeclareOperation("SCIncidences",[SCIsPolyhedralComplex,IsInt]);
#DeclareOperation("SCMinimalNonFaces",[IsObject]); #bound in pkghom.gd
DeclareOperation("SCSkel",[SCIsPolyhedralComplex,IsInt]);
DeclareOperation("SCVerticesEx",[SCIsPolyhedralComplex]);

KeyDependentOperation("SCFpBettiNumbers",SCIsPolyhedralComplex,IsInt,"prime");
KeyDependentOperation("SCIncidencesEx",SCIsPolyhedralComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCIsInKd",SCIsPolyhedralComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCIsKNeighborly",SCIsPolyhedralComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCNumFaces",SCIsPolyhedralComplex,IsInt,ReturnTrue);
KeyDependentOperation("SCSkelEx",SCIsPolyhedralComplex,IsInt,ReturnTrue);

DeclareSynonymAttr("SCFaces",SCSkel);
DeclareSynonymAttr("SCFacesEx",SCSkelEx);









