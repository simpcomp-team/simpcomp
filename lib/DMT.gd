################################################################################
##
##  simpcomp / DMT.gd
##
##  Functions for discrete Morse theory, manifold recognition 
##  and simply connectivity testing
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="DMT">
## 
## In this chapter a framework is provided to use Forman's discrete Morse 
## theory <Cite Key="Forman95DiscrMorseTheoryCellCompl" />
## within  <Package>simpcomp</Package>. See Section <Ref Chap="sec:DMT" /> 
## for a brief introduction.<P/>
##
## Note: this is not to be confused with Banchoff and Kühnel's theory of 
## regular simplexwise linear functions which is described in Chapter 
## <Ref Chap="chap:morse" />.<P/>
##
## <Section>
## <Heading>Functions using discrete Morse theory</Heading>
##
## <#Include Label="SCCollapseGreedy"/>
## <#Include Label="SCCollapseLex"/>
## <#Include Label="SCCollapseRevLex"/>
## <#Include Label="SCHasseDiagram"/>
## <#Include Label="SCMorseEngstroem"/>
## <#Include Label="SCMorseRandom"/>
## <#Include Label="SCMorseRandomLex"/>
## <#Include Label="SCMorseRandomRevLex"/>
## <#Include Label="SCMorseSpec"/>
## <#Include Label="SCMorseUST"/>
## <#Include Label="SCSpanningTreeRandom"/>
## <#Include Label="SCHomology"/>
## <#Include Label="SCHomologyEx"/>
## <#Include Label="SCIsSimplyConnected"/>
## <#Include Label="SCIsSimplyConnectedEx"/>
## <#Include Label="SCIsSphere"/>
## <#Include Label="SCIsManifold"/>
## <#Include Label="SCIsManifoldEx"/>
##
## </Section>
##<#/GAPDoc>

DeclareAttribute("SCHasseDiagram",SCIsSimplicialComplex);
DeclareAttribute("SCIsCollapsible",SCIsSimplicialComplex);

DeclareOperation("SCCollapseGreedy",[SCIsSimplicialComplex]);
DeclareOperation("SCCollapseLex",[SCIsSimplicialComplex]);
DeclareOperation("SCCollapseRevLex",[SCIsSimplicialComplex]);

DeclareGlobalFunction("SCMorseEngstroem");
DeclareGlobalFunction("SCMorseRandom");
DeclareGlobalFunction("SCMorseRandomLex");
DeclareGlobalFunction("SCMorseRandomRevLex");
DeclareGlobalFunction("SCMorseSpec");
DeclareGlobalFunction("SCMorseUST");
DeclareGlobalFunction("SCSpanningTreeRandom");

DeclareAttribute("SCHomology",SCIsPolyhedralComplex);
DeclareGlobalFunction("SCHomologyEx");

DeclareAttribute("SCIsSimplyConnected",SCIsSimplicialComplex);
DeclareGlobalFunction("SCIsSimplyConnectedEx");

DeclareAttribute("SCIsSphere",SCIsSimplicialComplex);

DeclareAttribute("SCIsManifold",SCIsSimplicialComplex);
DeclareGlobalFunction("SCIsManifoldEx");
