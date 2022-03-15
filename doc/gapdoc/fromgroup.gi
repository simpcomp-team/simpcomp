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
## <Func Name="SCsFromGroupExt" Arg="G,n,d,objectType,cache,removeDoubleEntries,
## outfile,maxLinkSize,subset"/>
## <Returns>a list of simplicial complexes of type <C>SCSimplicialComplex</C> 
## upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d=2</M> / all 
## strongly connected combinatorial <Arg>d</Arg>-pseudomanifolds, 
## <M>d \geq 3</M>, as a union of orbits of the group action of <Arg>G</Arg> 
## on <C>(d+1)</C>-tuples on the set of <Arg>n</Arg> vertices, see 
## <Cite Key="Lutz03TrigMnfFewVertVertTrans" />. The integer argument 
## <Arg>objectType</Arg> specifies, whether complexes exceeding the maximal 
## size of each vertex link for combinatorial manifolds are sorted out 
## (<C>objectType = 0</C>) or not (<C>objectType = 1</C>, in this case some 
## combinatorial pseudomanifolds won't be found, but no combinatorial manifold 
## will be sorted out). The integer argument <Arg>cache</Arg> specifies if the 
## orbits are held in memory during the computation, a value of <C>0</C> means 
## that the orbits are discarded, trading speed for memory, any other value 
## means that they are kept, trading memory for speed. The boolean argument 
## <Arg>removeDoubleEntries</Arg> specifies whether the results are checked for 
## combinatorial isomorphism, preventing isomorphic entries. The argument 
## <Arg>outfile</Arg> specifies an output file containing all complexes found 
## by the algorithm, if <Arg>outfile</Arg> is anything else than a string, not 
## output file is generated. The argument <Arg>maxLinkSize</Arg> determines a 
## maximal link size of any output complex. If <Arg>maxLinkSize</Arg><M>=0</M> 
## or if <Arg>maxLinkSize</Arg> is anything else than an integer the argument 
## is ignored. The argument <Arg>subset</Arg> specifies a set of orbits (given 
## by a list of indices of <C>repHigh</C>) which have to be contained in any 
## output complex. If <Arg>subset</Arg> is anything else than a subset of 
## <C>matrixAllowedRows</C> the argument is ignored.
## <Example><![CDATA[
## gap> G:=PrimitiveGroup(8,5);
## PGL(2, 7)
## gap> Size(G);
## 336
## gap> Transitivity(G);
## 3
## gap> list:=SCsFromGroupExt(G,8,3,1,0,true,false,0,[]);
## [ "defgh.g.h.fah.e.gaf.h.eag.e.faf.a.haa.g.fah.a.gjhzh" ]
## gap> c:=SCFromIsoSig(list[1]);
## <SimplicialComplex: unnamed complex 6 | dim = 3 | n = 8>
## gap> SCNeighborliness(c); 
## 3
## gap> c.F;
## [ 8, 28, 56, 28 ]
## gap> c.IsManifold; 
## false
## gap> SCLibDetermineTopologicalType(SCLink(c,1));
## <SimplicialComplex: lk([ 1 ]) in unnamed complex 6 | dim = 2 | n = 7>
## gap> # there are no 3-neighborly 3-manifolds with 8 vertices
## gap> list:=SCsFromGroupExt(PrimitiveGroup(8,5),8,3,0,0,true,false,0,[]); 
## gap> [  ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
  ##############################################################################
  ##############################################################################
  ##########################
  ### SETUP BACKTRACKING ###
  ##########################
################################################################################
##<#GAPDoc Label="SCsFromGroupByTransitivity">
## <ManSection>
## <Func Name="SCsFromGroupByTransitivity" Arg="n,d,k,maniflag,computeAutGroup,
## removeDoubleEntries"/>
## <Returns>a list of simplicial complexes of type <C>SCSimplicialComplex</C> 
## upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d = 2</M> / all 
## strongly connected combinatorial <Arg>d</Arg>-pseudomanifolds, 
## <M>d \geq 3</M>, as union of orbits of group actions for all 
## <Arg>k</Arg>-transitive groups on <C>(d+1)</C>-tuples on the set of 
## <Arg>n</Arg> vertices, see <Cite Key="Lutz03TrigMnfFewVertVertTrans" />. 
## The boolean argument <Arg>maniflag</Arg> specifies, whether the resulting 
## complexes should be listed separately by combinatorial manifolds, 
## combinatorial pseudomanifolds and complexes where the verification that the 
## object is at least a combinatorial pseudomanifold failed. The boolean 
## argument <Arg>computeAutGroup</Arg> specifies whether or not the real 
## automorphism group should be computed (note that a priori the generating 
## group is just a subgroup of the automorphism group). The boolean argument 
## <Arg>removeDoubleEntries</Arg> specifies whether the results are checked 
## for combinatorial isomorphism, preventing isomorphic entries. Internally 
## calls <Ref Func="SCsFromGroupExt" /> for every group.
## <Example><![CDATA[
## gap> list:=SCsFromGroupByTransitivity(8,3,2,true,true,true);
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
## #I  SCsFromGroupByTransitivity: ...done dim = 3, deg =  8, 0 manifolds, 1 pseudomanifolds, 0 candidates found.
## #I  SCsFromGroupByTransitivity: ...done dim = 3.
## [ [  ], [  ], [  ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
