################################################################################
##
##  simpcomp / fromgroup.gi
##
##  Compute Simplicial Complexes from given Permutation Groups.  
##
##  $Id: glprops.gi 68 2010-04-23 14:08:15Z felix $
##
################################################################################
################################################################################
##<#GAPDoc Label="SCsFromGroupExt">
## <ManSection>
## <Func Name="SCsFromGroupExt" Arg="G,n,d,objectType,cache,removeDoubleEntries"/>
## <Returns>a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d=2</M> / all  strongly connected combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d \geq 3</M>, as a union of orbits of the group action of <Arg>G</Arg> on <C>(d+1)</C>-tuples on the set of <Arg>n</Arg> vertices, see <Cite Key="Lutz03TrigMnfFewVertVertTrans" />. The integer argument <Arg>objectType</Arg> specifies, whether complexes exceeding the maximal size of each vertex link for combinatorial manifolds are sorted out (<C>objectType = 0</C>) or not (<C>objectType = 1</C>, in this case some combinatorial pseudomanifolds won't be found, but no combinatorial manifold will be sorted out). The integer argument <Arg>cache</Arg> specifies if the orbits are held in memory during the computation, a value of <C>0</C> means that the orbits are discarded, trading speed for memory, any other value means that they are kept, trading memory for speed. The boolean argument <Arg>removeDoubleEntries</Arg> specifies whether the results are checked for combinatorial isomorphism, preventing isomorphic entries.
## <Example>
## gap&gt; G:=PrimitiveGroup(8,5);
## PGL(2, 7)
## gap&gt; Size(G);
## 336
## gap&gt; Transitivity(G);
## 3
## gap&gt; list:=SCsFromGroupExt(G,8,3,1,0,true);
## [ [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="Complex 1 of PGL(2, 7) (single orbit)"
##      Dim=3
##     
##     /SimplicialComplex] ]
## gap&gt; SCNeighborliness(list[1]); 
## 3
## gap&gt; list[1].F;
## [ 8, 28, 56, 28 ]
## gap&gt; list[1].IsManifold; 
## false
## gap&gt; SCLibDetermineTopologicalType(SCLink(list[1],1));
## [SimplicialComplex
## 
##  Properties known: BoundaryEx, Dim, FacetsEx, HasBoundary, 
##                    IsPseudoManifold, Name, SkelExs[], Vertices.
## 
##  Name="lk([ 1 ]) in Complex 1 of PGL(2, 7) (single orbit)"
##  Dim=2
##  HasBoundary=false
##  IsPseudoManifold=true
## 
## /SimplicialComplex]
## gap&gt; # there are no 3-neighborly 3-manifolds with 8 vertices
## gap> list:=SCsFromGroupExt(PrimitiveGroup(8,5),8,3,0,0,true); 
## gap&gt; [  ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
  ###############################################################################
  ###############################################################################
################################################################################
##<#GAPDoc Label="SCsFromGroupByTransitivity">
## <ManSection>
## <Func Name="SCsFromGroupByTransitivity" Arg="n,d,k,maniflag,computeAutGroup,removeDoubleEntries"/>
## <Returns>a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d = 2</M> / all strongly connected combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d \geq 3</M>, as union of orbits of group actions for all <Arg>k</Arg>-transitive groups on <C>(d+1)</C>-tuples on the set of <Arg>n</Arg> vertices, see <Cite Key="Lutz03TrigMnfFewVertVertTrans" />. The boolean argument <Arg>maniflag</Arg> specifies, whether the resulting complexes should be listed separately by combinatorial manifolds, combinatorial pseudomanifolds and complexes where the verification that the object is at least a combinatorial pseudomanifold failed. The boolean argument <Arg>computeAutGroup</Arg> specifies whether or not the real automorphism group should be computed (note that a priori the generating group is just a subgroup of the automorphism group). The boolean argument <Arg>removeDoubleEntries</Arg> specifies whether the results are checked for combinatorial isomorphism, preventing isomorphic entries. Internally calls <Ref Func="SCsFromGroupExt" /> for every group.
## <Example>
## gap&gt; list:=SCsFromGroupByTransitivity(8,3,2,true,true,true);
## #I  SCsFromGroupByTransitivity: Building list of groups...
## #I  SCsFromGroupByTransitivity: ...2 groups found.
## #I  degree 8: [ AGL(1, 8), PSL(2, 7) ]
## #I  SCsFromGroupByTransitivity: Processing dimension 3.
## #I  SCsFromGroupByTransitivity: Processing degree 8.
## #I  SCsFromGroupByTransitivity: 1 / 2 groups calculated, found 0 complexes.
## #I  SCsFromGroupByTransitivity: Calculating 0 automorphism and homology groups...
## #I  SCsFromGroupByTransitivity: ...all automorphism groups calculated for group 1 / 2.
## #I  SCsFromGroupByTransitivity: 2 / 2 groups calculated, found 1 complexes.
## #I  SCsFromGroupByTransitivity: Calculating 1 automorphism and homology groups...
## #I  group not listed
## #I  SCsFromGroupByTransitivity: 1 / 1 automorphism groups calculated.
## #I  SCsFromGroupByTransitivity: ...all automorphism groups calculated for group 2 / 2.
## #I  SCsFromGroupByTransitivity: Checking for double entries...
## #I  SCsFromGroupByTransitivity: ...done dim = 3, deg =  8, 0 manifolds, 1 pseudomanifolds, 0 candidates found.
## #I  SCsFromGroupByTransitivity: ...done dim = 3.
## [ [  ], [ [SimplicialComplex
##         
##          Properties known: AutomorphismGroup, AutomorphismGroupSize, 
##                            AutomorphismGroupStructure, 
##                            AutomorphismGroupTransitivity, BoundaryEx, Dim, 
##                            FVector, FacetsEx, GeneratorsEx, HasBoundary, 
##                            Homology, IsEmpty, IsManifold, IsPseudoManifold, 
##                            IsStronglyConnected, Name, NumFaces[], SkelExs[], 
##                            Vertices.
##         
##          Name="Complex 1 of PSL(2, 7) (multiple orbits)"
##          Dim=3
##          AutomorphismGroupSize=336
##          AutomorphismGroupStructure="PSL(3,2) : C2"
##          AutomorphismGroupTransitivity=3
##          FVector=[ 8, 28, 56, 28 ]
##          HasBoundary=false
##          Homology=[ [ 0, [ ] ], [ 0, [ ] ], [ 8, [ ] ], [ 1, [ ] ] ]
##          IsPseudoManifold=true
##          IsStronglyConnected=true
##         
##         /SimplicialComplex] ], [  ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
