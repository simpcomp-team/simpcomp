################################################################################
##
##  simpcomp / operations.gd
##
##  Operations on simplicial complexes.
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="operations">
## <Section> 
## <Heading>Operations on simplicial complexes</Heading>
##
##  The following functions perform operations on simplicial complexes. Most of them return simplicial complexes. Thus, this section is closely related to the Sections <Ref Chap="sec:generateFromOld"/> ''Generate new complexes from old''. However, the data generated here is rather seen as an intrinsic attribute of the original complex and not as an independent complex.
##
## <#Include Label="SCAlexanderDual"/>
## <#Include Label="SCClose"/>
## <#Include Label="SCCone"/>
## <#Include Label="SCDeletedJoin"/>
## <#Include Label="SCDifference"/>
## <#Include Label="SCFillSphere"/>
## <#Include Label="SCHandleAddition"/>
## <#Include Label="SCIntersection"/>
## <#Include Label="SCIsIsomorphic"/>
## <#Include Label="SCIsSubcomplex"/>
## <#Include Label="SCIsomorphism"/>
## <#Include Label="SCIsomorphismEx"/>
## <#Include Label="SCJoin"/>
## <#Include Label="SCNeighbors"/>
## <#Include Label="SCNeighborsEx"/>
## <#Include Label="SCShelling"/>
## <#Include Label="SCShellingExt"/>
## <#Include Label="SCShellings"/>
## <#Include Label="SCSpan"/>
## <#Include Label="SCSuspension"/>
## <#Include Label="SCUnion"/>
## <#Include Label="SCVertexIdentification"/>
## <#Include Label="SCWedge"/>
##
## </Section>
## <#/GAPDoc>

#DeclareOperation("SCAlexanderDual",[IsObject]);
DeclareOperation("SCAntiStar",[SCIsPolyhedralComplex,IsObject]);
DeclareGlobalFunction("SCClose");
#DeclareGlobalFunction("SCCone");
#DeclareOperation("SCDeletedJoin",[IsObject,IsObject]);
DeclareGlobalFunction("SCFillSphere");
DeclareOperation("SCHandleAddition",[SCIsSimplicialComplex,IsList,IsList]);
DeclareOperation("SCIsIsomorphic",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCIsSubcomplex",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCIsomorphism",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCIsomorphismEx",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
#DeclareOperation("SCJoin",[IsObject,IsObject]);
#DeclareOperation("SCLink",[IsObject,IsObject]);
DeclareOperation("SCLinks",[SCIsPolyhedralComplex,IsInt]);
DeclareOperation("SCNeighbors",[SCIsSimplicialComplex,IsList]);
DeclareOperation("SCNeighborsEx",[SCIsSimplicialComplex,IsList]);
#DeclareOperation("SCShelling",[SCIsSimplicialComplex]);
DeclareOperation("SCShellingExt",[SCIsSimplicialComplex,IsBool,IsList]);
DeclareOperation("SCShellings",[SCIsSimplicialComplex]);
DeclareOperation("SCSpan",[SCIsSimplicialComplex,IsList]);
#DeclareOperation("SCStar",[IsObject,IsObject]);
DeclareOperation("SCStars",[SCIsPolyhedralComplex,IsInt]);
#DeclareOperation("SCSuspension",[IsObject]);
DeclareOperation("SCVertexIdentification",[SCIsSimplicialComplex,IsObject,IsObject]);
#DeclareOperation("SCWedge",[IsObject,IsObject]);

################################################################################
