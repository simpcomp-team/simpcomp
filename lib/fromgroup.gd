################################################################################
##
##  simpcomp / fromgroup.gd
##
##  Compute Simplicial Complexes from given Permutation Groups.
##
##  $Id$
##
################################################################################

# NOTE: the label "fromgroup" is included in the file generate.gd 
## <#GAPDoc Label="fromgroup">
## 
## <Section>
## <Heading>Simplicial complexes from transitive permutation groups</Heading>
##
## Beginning from Version 1.3.0, <Package>simpcomp</Package> is able to generate triangulations from a prescribed transitive group action on its set of vertices. Note that the corresponding group is a subgroup of the full automorphism group, but not necessarily the full automorphism group of the triangulations obtained in this way. The methods and algorithms are based on the works of Frank H. Lutz <Cite Key="Lutz03TrigMnfFewVertVertTrans" />, <Cite Key="Lutz08ManifoldPage" />	and in particular his program <C>MANIFOLD_VT</C>. <P/>   
##
## <#Include Label="SCsFromGroupExt"/>
## <#Include Label="SCsFromGroupByTransitivity"/>
## 
## </Section>
## 
## <#/GAPDoc>
################################################################################

DeclareGlobalFunction("SCsFromGroupExt");
DeclareGlobalFunction("SCsFromGroupByTransitivity");

