################################################################################
##
##  simpcomp / generate.gd
##
##  Generate simplicial complexes or construct them using existing
##  complexes.
##
##  $Id$
##
################################################################################

## GAPDoc include
## <#GAPDoc Label="generate">
## <Section Label="sec:FromScratch">
## <Heading>Creating an <C>SCSimplicialComplex</C> object from a facet list</Heading>
##
##  This section contains functions to generate or to construct new simplicial  complexes. Some of them obtain new complexes from existing ones, some generate  new complexes from scratch.
##
## <#Include Label="SCFromFacets"/>
## <#Include Label="SC"/>
## <#Include Label="SCFromDifferenceCycles"/>
## <#Include Label="SCFromGenerators"/>
##
## </Section>
##
## <#Include Label="isosig"/>
##
## <Section Label="sec:Standard">
## <Heading>Generating some standard triangulations</Heading>
##
## <#Include Label="SCBdCyclicPolytope"/>
## <#Include Label="SCBdSimplex"/>
## <#Include Label="SCEmpty"/>
## <#Include Label="SCSimplex"/>
## <#Include Label="SCSeriesTorus"/>
## <#Include Label="SCSurface"/>
## <#Include Label="SCFVectorBdCrossPolytope"/>
## <#Include Label="SCFVectorBdCyclicPolytope"/>
## <#Include Label="SCFVectorBdSimplex"/>
## </Section>
##
## <Section Label="sec:Series">
## <Heading>Generating infinite series of transitive triangulations</Heading>
##
## <#Include Label="SCSeriesAGL"/>
## <#Include Label="SCSeriesBrehmKuehnelTorus"/>
## <#Include Label="SCSeriesBdHandleBody"/>
## <#Include Label="SCSeriesBid"/>
## <#Include Label="SCSeriesC2n"/>
## <#Include Label="SCSeriesConnectedSum"/>
## <#Include Label="SCSeriesCSTSurface"/>
## <#Include Label="SCSeriesD2n"/>
## <#Include Label="SCSeriesHandleBody"/>
## <#Include Label="SCSeriesHomologySphere"/>
## <#Include Label="SCSeriesK"/>
## <#Include Label="SCSeriesKu"/>
## <#Include Label="SCSeriesL"/>
## <#Include Label="SCSeriesLe"/>
## <#Include Label="SCSeriesLensSpace"/>
## <#Include Label="SCSeriesPrimeTorus"/>
## <#Include Label="SCSeriesSeifertFibredSpace"/>
## <#Include Label="SCSeriesS2xS2"/>
##
## </Section >
## <Section Label="sec:RegularAndChiralMaps">
## <Heading>A census of regular and chiral maps</Heading>
##
## <#Include Label="highlysymmetricsurfaces"/>
## 
## See also <Ref Func="SCSurface" /> for example triangulations of all compact closed surfaces 
## with transitive cyclic automorphism group.
##
## </Section >
## <Section Label="sec:generateFromOld">
## <Heading>Generating new complexes from old</Heading>
##
## <#Include Label="SCCartesianPower"/>
## <#Include Label="SCCartesianProduct"/>
## <#Include Label="SCConnectedComponents"/>
## <#Include Label="SCConnectedProduct"/>
## <#Include Label="SCConnectedSum"/>
## <#Include Label="SCConnectedSumMinus"/>
## <#Include Label="SCDifferenceCycleCompress"/>
## <#Include Label="SCDifferenceCycleExpand"/>
## <#Include Label="SCStronglyConnectedComponents"/>
## 
## </Section>
##
## <#Include Label="fromgroup"/>
##
## <#Include Label="class3mflds"/>
##
## <#/GAPDoc>

DeclareAttribute("SCConnectedComponents",SCIsPolyhedralComplex);
DeclareAttribute("SCStronglyConnectedComponents",SCIsSimplicialComplex);

DeclareOperation("SCCartesianPower",[SCIsSimplicialComplex,IsInt]);
DeclareOperation("SCCartesianProduct",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCConnectedProduct",[SCIsSimplicialComplex,IsInt]);
DeclareOperation("SCConnectedSum",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCConnectedSumMinus",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCFromDifferenceCycles",[IsList]);
DeclareOperation("SCFromGenerators",[IsPermGroup,IsList]);

DeclareGlobalFunction("SCBdCrossPolytope");
DeclareGlobalFunction("SCBdCyclicPolytope");
DeclareGlobalFunction("SCBdSimplex");
DeclareGlobalFunction("SCDifferenceCycleCompress");
DeclareGlobalFunction("SCDifferenceCycleExpand");
DeclareGlobalFunction("SCEmpty");
DeclareGlobalFunction("SCFVectorBdCrossPolytope");
DeclareGlobalFunction("SCFVectorBdCyclicPolytope");
DeclareGlobalFunction("SCFVectorBdSimplex");
DeclareGlobalFunction("SCSeriesAGL");
DeclareGlobalFunction("SCSeriesBdHandleBody");
DeclareGlobalFunction("SCSeriesBid");
DeclareGlobalFunction("SCSeriesBrehmKuehnelTorus");
DeclareGlobalFunction("SCSeriesC2n");
DeclareGlobalFunction("SCSeriesConnectedSum");
DeclareGlobalFunction("SCSeriesCSTSurface");
DeclareGlobalFunction("SCSeriesD2n");
DeclareGlobalFunction("SCSeriesHandleBody");
DeclareGlobalFunction("SCSeriesHomologySphere");
DeclareGlobalFunction("SCSeriesK");
DeclareGlobalFunction("SCSeriesKu");
DeclareGlobalFunction("SCSeriesL");
DeclareGlobalFunction("SCSeriesLe");
DeclareGlobalFunction("SCSeriesLensSpace");
DeclareGlobalFunction("SCSeriesNSB1");
DeclareGlobalFunction("SCSeriesNSB2");
DeclareGlobalFunction("SCSeriesNSB3");
DeclareGlobalFunction("SCSeriesPrimeTorus");
DeclareGlobalFunction("SCSeriesSeifertFibredSpace");
DeclareGlobalFunction("SCSimplex");
DeclareGlobalFunction("SCSeriesTorus");
DeclareGlobalFunction("SCSurface");
DeclareGlobalFunction("SCSeriesS2xS2");
