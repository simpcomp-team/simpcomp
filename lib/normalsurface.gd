################################################################################
##
##  simpcomp / normalsurface.gd
##
##  Normal surfaces
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="normalsurface">
##
##
## <Section Label="sec:NSNormalSurface">
## <Heading>The object type <C>SCNormalSurface</C></Heading>
##
## The &GAP; object type <C>SCNormalSurface</C> is designed to describe slicings (level sets of discrete Morse functions) of combinatorial <M>3</M>-manifolds, i. e. discrete normal surfaces.
## Internally <C>SCNormalSurface</C> is a subtype of <C>SCPolyhedralComplex</C> and, thus, mostly behaves like a <C>SCSimplicialComplex</C> object (see Section <Ref Chap="sec:SCSimplComplObj" />).
##
## For a very short introduction to normal surfaces see <Ref Chap="sec:NormSurfTheory"/>, for a more thorough introduction to the field see <Cite Key="Spreer10NormSurfsCombSlic"/>. For some fundamental methods and functions for <C>SCNormalSurface</C> see below. For more functions related to the <C>SCNormalSurface</C> object type see Chapter <Ref Chap="chap:NormSurfFunc"/>.
##
## </Section>
## <Section>
## <Heading>Overloaded operators of <C>SCNormalSurface</C></Heading>
## 
## As with the object type <C>SCSimplicialComplex</C>, <Package>simpcomp</Package> overloads some standard operations for the object type <C>SCNormalSurface</C>. See a list of overloaded operators below. 
##
##	
## <#Include Label="NSOpPlusSCInt"/>
## <#Include Label="NSOpMinusSCInt"/>
## <#Include Label="NSOpModSCInt"/>
##	
## </Section>
##
## <Section>
## <Heading><C>SCNormalSurface</C> as a subtype of <C>Set</C></Heading>
##	
## Like objects of type <C>SCSimplicialComplex</C>, an object of type <C>SCNormalSurface</C> behaves like a &GAP; <C>Set</C> type. The elements of the set are given by the facets of the normal surface, grouped by their dimensionality and type, i.e. if <C>complex</C> is an object of type <C>SCNormalSurface</C>, <C>c[1]</C> refers to the 0-faces of <C>complex</C>, <C>c[2]</C> to the 1-faces, <C>c[3]</C> to the triangles and <C>c[4]</C> to the quadrilaterals.
##
## See below for some examples and Section <Ref Chap="sec:SubtypeOfSet"/> for details.
## 
## <#Include Label="NSOpUnionSCSC"/>
##
## </Section>
## <#/GAPDoc>
##
## <#GAPDoc Label="normalsurfaceFunc">
##
## <Section>
## <Heading>Creating an <C>SCNormalSurface</C> object</Heading>
##
##  This section contains functions to construct discrete normal surfaces that are slicings from a list of <M>2</M>-dimensional facets (triangles and quadrilaterals) or combinatorial <M>3</M>-manifolds.<P/>
##
## For a very short introduction to the theory of discrete normal surfaces and slicings see Section <Ref Chap="sec:NormSurfTheory"/> and Section <Ref Chap="sec:MorseTheory"/>, for an introduction to the &GAP; object type <C>SCNormalSurface</C> see <Ref Chap="sec:NSNormalSurface"/>, for more information see the article <Cite Key="Spreer10NormSurfsCombSlic"/>.
##
## <#Include Label="SCNSEmpty"/>
## <#Include Label="SCNSFromFacets"/>
## <#Include Label="SCNS"/>
## <#Include Label="SCNSSlicing"/>
##
## </Section>
##
## <Section>
## <Heading>Generating new objects from discrete normal surfaces</Heading>
##
## <Package>simpcomp</Package> provides the possibility to copy and / or triangulate normal surfaces. Note that other constructions like the connected sum or the cartesian product do not make sense for (embedded) normal surfaces in general.
##
## <#Include Label="SCNSCopy"/>
## <#Include Label="SCNSTriangulation"/>
##
## </Section>
##
## <Section>
## <Heading>Properties of <C>SCNormalSurface</C> objects</Heading>
##
## Although some properties of a discrete normal surface can be computed by using the functions for simplicial complexes, there is a variety of properties needing specially designed functions. See below for a list.
##
## <#Include Label="SCNSConnectedComponents"/>
## <#Include Label="SCNSDim"/>
## <#Include Label="SCNSEulerCharacteristic"/>
## <#Include Label="SCNSFVector"/>
## <#Include Label="SCNSFaceLattice"/>
## <#Include Label="SCNSFaceLatticeEx"/>
## <#Include Label="SCNSFpBettiNumbers"/>
## <#Include Label="SCNSGenus"/>
## <#Include Label="SCNSHomology"/>
## <#Include Label="SCNSIsConnected"/>
## <#Include Label="SCNSIsEmpty"/>
## <#Include Label="SCNSIsOrientable"/>
## <#Include Label="SCNSSkel"/>
## <#Include Label="SCNSSkelEx"/>
## <#Include Label="SCNSTopologicalType"/>
## <#Include Label="SCNSUnion"/>
##
## </Section>
##
## <#/GAPDoc>

DeclareCategory("SCIsNormalSurface",SCIsPolyhedralComplex);

DeclareAttribute("SCGenus",SCIsNormalSurface);
DeclareAttribute("SCNSTriangulation",SCIsNormalSurface);

DeclareOperation("SCNSFromFacets",[IsList]);
DeclareOperation("SCNS",[IsList]);

DeclareGlobalFunction("SCNSEmpty");
DeclareGlobalFunction("SCNSSlicing");

DeclareGlobalVariable("SCNSPropertyHandlers");
DeclareGlobalVariable("SCNSViewProperties");


