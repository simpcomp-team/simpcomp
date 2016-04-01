################################################################################
##
##  simpcomp / isosig.gd
##
##  Functions to compute the isomorphism signature of a complex
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="isosig">
##
## <Section Label="sec:IsoSigs">
## <Heading>Isomorphism signatures</Heading>
##
## This section contains functions to construct simplicial complexes from isomorphism signatures and to 
## compress closed and strongly connected weak pseudomanifolds to strings. <P/>
##
## The isomorphism signature of a closed and strongly connected weak pseudomanifold
## is a representation which is invariant under relabelings of the underlying complex and
## thus unique for a combinatorial type, i.e. two complexes are isomorphic iff they have the
## same isomorphism signature.  <P/>
##
## To compute the isomorphism signature of a closed and strongly connected weak pseudomanifold <M>P</M> 
## we have to compute all canonical labelings of <M>P</M>  and chose the one that is lexicographically
## minimal. <P/>
##
## A canonical labeling of <M>P</M> is determined by chosing a facet <M>\Delta \in P</M> and a numbering
## <M>1, 2, \ldots , d+1</M> of the vertices of <M>\Delta</M> (which in turn determines a 
## numbering of the co-dimension one faces of <M>\Delta</M>
## by identifying each face with its opposite vertex). This numbering can then be uniquely extended to a
## numbering (and thus a labeling) on all vertices of <M>P</M> by the weak pseudomanifold property:
## start at face <M>1</M> of <M>\Delta</M> and label the opposite vertex of the unique other facet <M>\delta</M>
## meeting face <M>1</M> by <M>d+2</M>, go on with face <M>2</M> of <M>\Delta</M> and so on. After finishing with the first
## facet we now have a numbering on <M>\delta</M>, repeat the procedure for <M>\delta</M>, 
## etc. Whenever the opposite vertex of a face is already labeled (and also, if the vertex occurs for the first time) we note
## this label. Whenever a facet is already visited we skip this step and keep track of the number of skippings between any
## two newly discovered facets. This results in a sequence of <M>m-1</M> vertex labels together with <M>m-1</M> skipping
## numbers (where <M>m</M> denotes the number of facets in <M>P</M>) which then can by encoded by characters via a lookup table. <P/>
##
## Note that there are precisely <M>(d+1)! m</M> canonical labelings we have to check in order to find the lexicographically
## minimal one. Thus, computing the isomorphism signature of a large or highly dimensional complex can be time consuming. 
## If you are not interested in the isomorphism signature but just in the compressed string representation
## use <Ref Func="SCExportToString" /> which just computes the first canonical labeling of the complex provided as argument
## and returns the resulting string. <P/>
##
## Note: Another way of storing and loading complexes is provided by simpcomp's library functionality, see Section <Ref Chap="sec:lib"/> for details. <P/>
##
## <#Include Label="SCExportToString"/>
## <#Include Label="SCExportIsoSig"/>
## <#Include Label="SCFromIsoSig"/>
##
## </Section>
##<#/GAPDoc>

DeclareAttribute("SCExportIsoSig",SCIsSimplicialComplex);
DeclareGlobalFunction("SCExportToString");
DeclareOperation("SCFromIsoSig",[IsString]);

