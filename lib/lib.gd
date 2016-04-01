################################################################################
##
##  simpcomp / lib.gd
##
##  simplicial complexes library
##
##  $Id$
##
################################################################################


## <#GAPDoc Label="lib">
## <Section Label="sec:lib">
## <Heading>Simplicial complex library</Heading>
##		
## <Package>simpcomp</Package> contains a library of simplicial complexes on few vertices, most of them (combinatorial) triangulations of manifolds and pseudomanifolds. The user can load these known triangulations from the library in order to study their properties or to construct new triangulations out of the known ones. For example, a user could determine the topological type of a given triangulation -- which can be quite tedious if done by hand -- by establishing a PL equivalence to a complex in the library.<P/>
##
## Among other known triangulations, the library contains all of the vertex transitive triangulations of combinatorial manifolds with up to <M>15</M> vertices (for <M>d \in \{ 2,3,9,10,11,12\}</M>) and up to <M>13</M> vertices (for <M>d \in \{ 4,5,6,7,8 \}</M>) and all of the vertex transitive combinatorial pseudomanifolds with up to <M>15</M> vertices (for <M>d=3</M>) and up to <M>13</M> vertices (for <M>d \in \{ 4,5,6,7 \} </M>) classified by Frank Lutz that can be found on his ``Manifold Page'' <URL>http://www.math.tu-berlin.de/diskregeom/stellar/</URL>, along with some triangulations of sphere bundles and some bounded triangulated PL-manifolds.<P/>
##
## See <Ref Var="SCLib"/> for a naming convention used for the global library of <Package>simpcomp</Package>.
##
## Note: Another way of storing and loading complexes is provided by the functions <Ref Func="SCExportIsoSig"/>, <Ref Func="SCExportToString"/> and <Ref Func="SCFromIsoSig"/>, see Section <Ref Chap="sec:IsoSigs"/> for details.
##
## <#Include Label="SCIsLibRepository"/>
##
## <#Include Label="SCLib"/>
##
## <#Include Label="SCLibAdd"/>
## <#Include Label="SCLibAllComplexes"/>
## <#Include Label="SCLibDelete"/>
## <#Include Label="SCLibDetermineTopologicalType"/>
## <#Include Label="SCLibFlush"/>
## <#Include Label="SCLibInit"/>
## <#Include Label="SCLibIsLoaded"/>
## <#Include Label="SCLibSearchByAttribute"/>
## <#Include Label="SCLibSearchByName"/>
## <#Include Label="SCLibSize"/>
## <#Include Label="SCLibUpdate"/>
## <#Include Label="SCLibStatus"/>
##
## </Section>
## <#/GAPDoc>


DeclareCategory("SCIsLibRepository",SCIsPropertyObject);

DeclareGlobalVariable("SCLib");

DeclareGlobalFunction("SCLibAdd");
DeclareGlobalFunction("SCLibAllComplexes");
DeclareGlobalFunction("SCLibDelete");
DeclareGlobalFunction("SCLibDetermineTopologicalType");
DeclareGlobalFunction("SCLibFlush");
DeclareGlobalFunction("SCLibInit");
DeclareGlobalFunction("SCLibIsLoaded");
DeclareGlobalFunction("SCLibLoad");
DeclareGlobalFunction("SCLibSearchByAttribute");
DeclareGlobalFunction("SCLibSearchByName");
DeclareGlobalFunction("SCLibSize");
DeclareGlobalFunction("SCLibStatus");
DeclareGlobalFunction("SCLibUpdate");
################################################################################
