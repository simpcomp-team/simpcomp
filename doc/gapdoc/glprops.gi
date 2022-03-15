###############################################################################
##
##  simpcomp / glprops.gi
##
##  Compute Global Properties of Simplicial Complexes.  
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCSpanningTree">
## <ManSection>
## <Meth Name="SCSpanningTree" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a spanning tree of a connected simplicial complex <Arg>complex</Arg> using a greedy algorithm.
## <Example><![CDATA[
## gap> c:=SC([["a","b","c"],["a","b","d"], ["a","c","d"], ["b","c","d"]]);;
## gap> s:=SCSpanningTree(c);
## <SimplicialComplex: spanning tree of unnamed complex 1 | dim = 1 | n = 4>
## gap> s.Facets;
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFundamentalGroup">
## <ManSection>
## <Meth Name="SCFundamentalGroup" Arg="complex"/>
## <Returns>a &GAP; fp group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the first fundamental group of <Arg>complex</Arg>, which must be a connected simplicial complex, and returns it in form of a finitely presented group. The generators of the group are given as 2-tuples that correspond to the edges of <Arg>complex</Arg> in standard labeling. You can use GAP's <C>SimplifiedFpGroup</C> to simplify the group presenation.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("RP^2");
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> c:=SCLib.Load(list[1][1]);
## <SimplicialComplex: RP^2 (VT) | dim = 2 | n = 6>
## gap> g:=SCFundamentalGroup(c);;
## gap> StructureDescription(g);
## "C2"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMinimalNonFaces">
## <ManSection>
## <Meth Name="SCMinimalNonFaces" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all missing proper faces of a simplicial complex <Arg>complex</Arg> by calling <Ref Meth="SCMinimalNonFacesEx"/>. The simplices are returned in the original labeling of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SCFromFacets(["abc","abd"]);;
## gap> SCMinimalNonFaces(c);           
## [ [  ], [ "cd" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMinimalNonFacesEx">
## <ManSection>
## <Meth Name="SCMinimalNonFacesEx" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all missing proper faces of a simplicial complex <Arg>complex</Arg>, i.e. the missing <M>(i+1)</M>-tuples in the <M>i</M>-dimensional skeleton of a <Arg>complex</Arg>. A missing <M>i+1</M>-tuple is not listed if it only consists of missing <M>i</M>-tuples. Note that whenever <Arg>complex</Arg> is <M>k</M>-neighborly the first <M>k+1</M> entries are empty. The simplices are returned in the standard labeling <M>1,\dots,n</M>, where <M>n</M> is the number of vertices of <Arg>complex</Arg>. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..10]}; 
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ], [ 24, "(T^2)#3" ], 
##   [ 41, "T^2 (VT)" ], [ 44, "(T^2)#4" ], [ 65, "T^2 (VT)" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> SCFVector(torus);
## [ 7, 21, 14 ]
## gap> SCMinimalNonFacesEx(torus);
## [ [  ], [  ] ]
## gap> SCMinimalNonFacesEx(SCBdCrossPolytope(4));
## [ [  ], [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ], [ 7, 8 ] ], [  ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsEmpty">
## <ManSection>
## <Meth Name="SCIsEmpty" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is the empty complex, i. e. a <C>SCSimplicialComplex</C> object with empty facet list.
## <Example><![CDATA[
## gap> c:=SC([[1]]);;
## gap> SCIsEmpty(c);
## false
## gap> c:=SC([]);;
## gap> SCIsEmpty(c);
## true
## gap> c:=SC([[]]);;
## gap> SCIsEmpty(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFacetsEx">
## <ManSection>
## <Meth Name="SCFacetsEx" Arg="complex"/>
## <Returns> a facet list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the facets of a simplicial complex as they are stored, i. e. with standard vertex labeling from 1 to n.
## <Example><![CDATA[
## gap> c:=SC([[2,3],[3,4],[4,2]]);;
## gap> SCFacetsEx(c);
## [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFacets">
## <ManSection>
## <Meth Name="SCFacets" Arg="complex"/>
## <Returns> a facet list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the facets of a simplicial complex in the original vertex labeling.
## <Example><![CDATA[
## gap> c:=SC([[2,3],[3,4],[4,2]]);;
## gap> SCFacets(c);
## [ [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFaces">
## <ManSection>
## <Meth Name="SCFaces" Arg="complex,k"/>
## <Returns> a face list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This is a synonym of the function <Ref Meth="SCSkel" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFacesEx">
## <ManSection>
## <Meth Name="SCFacesEx" Arg="complex,k"/>
## <Returns> a face list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This is a synonym of the function <Ref Meth="SCSkelEx" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDim">
## <ManSection>
## <Meth Name="SCDim" Arg="complex"/>
## <Returns> an integer <M>\geq -1</M> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dimension of a simplicial complex. If the complex is not pure, the dimension of the highest dimensional simplex is returned.
## <Example><![CDATA[
## gap> complex:=SC([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCDim(complex);                                    
## 2
## gap> c:=SC([[1], [2,4], [3,4], [5,6,7,8]]);;
## gap> SCDim(c);
## 3
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOrientation">
## <ManSection>
## <Meth Name="SCOrientation" Arg="complex"/>
## <Returns> a list of the type <M>\{ \pm 1 \}^{f_d}</M> or <C>[ ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function tries to compute an orientation of a pure simplicial complex <Arg>complex</Arg> that fulfills the weak pseudomanifold property. If <Arg>complex</Arg> is orientable, an orientation in form of a list of orientations for the facets of <Arg>complex</Arg> is returned, otherwise an empty set.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCOrientation(c);
## [ 1, -1, -1, 1, -1, 1, 1, -1, -1, 1, 1, -1, 1, -1, -1, 1 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsPure">
## <ManSection>
## <Meth Name="SCIsPure" Arg="complex"/>
## <Returns> a boolean upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is pure.
## <Example><![CDATA[
## gap> c:=SC([[1,2], [1,4], [2,4], [2,3,4]]);;
## gap> SCIsPure(c);
## false
## gap> c:=SC([[1,2], [1,4], [2,4]]);;
## gap> SCIsPure(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsKNeighborly">
## <ManSection>
## <Meth Name="SCIsKNeighborly" Arg="complex,k"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");   
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCFVector(rp2_6);
## [ 6, 15, 10 ]
## gap> SCIsKNeighborly(rp2_6,2);
## true
## gap> SCIsKNeighborly(rp2_6,3);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsFlag">
## <ManSection>
## <Meth Name="SCIsFlag" Arg="complex,k"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if <Arg>complex</Arg> is flag. A connected simplicial complex of dimension at least one is a flag complex if all cliques in its 1-skeleton span a face of the complex (cf. <Cite Key="Frohmader08FaceVecFlagCompl" />). 
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");   
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCIsFlag(rp2_6);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFVector">
## <ManSection>
## <Meth Name="SCFVector" Arg="complex"/>
## <Returns> a list of non-negative integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the simplicial complex <Arg>complex</Arg>, i. e. the number of <M>i</M>-dimensional faces for <M> 0 \leq i \leq d </M>, where <M>d</M> is the dimension of <Arg>complex</Arg>. A memory-saving implicit algorithm is used that avoids calculating the face lattice of the complex. Internally calls <Ref Meth="SCNumFaces"/>.
## <Example><![CDATA[
## gap> complex:=SC([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCFVector(complex);
## [ 4, 6, 4 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
###############################################################################
##<#GAPDoc Label="SCNumFaces">
## <ManSection>
## <Meth Name="SCNumFaces" Arg="complex [, i]"/>
## <Returns> an integer or a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <Arg>i</Arg> is not specified the function computes the <M>f</M>-vector of the simplicial complex <Arg>complex</Arg> (cf. <Ref Meth="SCFVector"/>). If the optional integer parameter <Arg>i</Arg> is passed, only the <Arg>i</Arg>-th position of the <M>f</M>-vector of <Arg>complex</Arg> is calculated. In any case a memory-saving implicit algorithm is used that avoids calculating the face lattice of the complex. 
## <Example><![CDATA[
## gap> complex:=SC([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCNumFaces(complex,1);
## 6
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHVector">
## <ManSection>
## <Meth Name="SCHVector" Arg="complex"/>
## <Returns> a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>h</M>-vector of a simplicial complex. The <M>h</M>-vector is defined as <Math> h_{k}:= \sum \limits_{i=-1}^{k-1} (-1)^{k-i-1}{d-i-1 \choose k-i-1} f_i</Math> for <M>0 \leq k \leq d</M>, where <M>f_{-1} := 1</M>. For all simplicial complexes we have <M>h_0 = 1</M>, hence the returned list starts with the second entry of the <M>h</M>-vector.
##
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCFVector(rp2_6);
## [ 6, 15, 10 ]
## gap> SCHVector(rp2_6);
## [ 3, 6, 0 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCGVector">
## <ManSection>
## <Meth Name="SCGVector" Arg="complex"/>
## <Returns> a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the g-vector of a simplicial complex. The <M>g</M>-vector is defined as follows:<P/>
## 
## Let <M>h</M> be the <M>h</M>-vector of a <M>d</M>-dimensional simplicial complex C, then <Math>g_i:=h_{i+1} - h_{i} ; \quad \frac{d}{2} 
## \geq i \geq 0 </Math> is called the <M>g</M>-vector of <M>C</M>. For the definition of the <M>h</M>-vector see <Ref Meth="SCHVector" />. The information contained in <M>g</M> suffices to determine the <M>f</M>-vector of <M>C</M>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCFVector(rp2_6);
## [ 6, 15, 10 ]
## gap> SCHVector(rp2_6);
## [ 3, 6, 0 ]
## gap> SCGVector(rp2_6);
## [ 2, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCEulerCharacteristic">
## <ManSection>
## <Meth Name="SCEulerCharacteristic" Arg="complex"/>
## <Returns> integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Euler characteristic <Math> \chi(C)=\sum \limits_{i=0}^{d} (-1)^{i} f_i </Math> of a simplicial complex <M>C</M>, where <M>f_i</M> denotes the <M>i</M>-th component of the <M>f</M>-vector.
## <Example><![CDATA[
## gap> complex:=SCFromFacets([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCEulerCharacteristic(complex);
## 2
## gap> s2:=SCBdSimplex(3);;
## gap> s2.EulerCharacteristic;
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsPseudoManifold">
## <ManSection>
## <Meth Name="SCIsPseudoManifold" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> fulfills the weak pseudomanifold property, i. e. if every <M>d-1</M>-face of <Arg>complex</Arg> is contained in at most <M>2</M> facets.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4],[2,3,4],[1,5,6],[1,5,7],[1,6,7],[5,6,7]]);;
## gap> SCIsPseudoManifold(c);
## true
## gap> c:=SC([[1,2],[2,3],[3,1],[1,4],[4,5],[5,1]]);;
## gap> SCIsPseudoManifold(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsConnected">
## <ManSection>
## <Meth Name="SCIsConnected" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is connected.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(1);;
## gap> SCIsConnected(c);
## false
## gap> c:=SCBdSimplex(2);;
## gap> SCIsConnected(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsStronglyConnected">
## <ManSection>
## <Meth Name="SCIsStronglyConnected" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is strongly connected, i. e. if for any pair of facets <M>(\hat{\Delta},\tilde{\Delta})</M> there exists a sequence of facets <M>( \Delta_1 , \ldots , \Delta_k )</M> with <M>\Delta_1 = \hat{\Delta}</M> and <M>\Delta_k = \tilde{\Delta}</M> and dim<M>(\Delta_i , \Delta_{i+1} ) = d - 1</M> for all <M>1 \leq i \leq k - 1</M>.  
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4],[2,3,4], [1,5,6],[1,5,7],[1,6,7],[5,6,7]]);
## <SimplicialComplex: unnamed complex 27 | dim = 2 | n = 7>
## gap> SCIsConnected(c);        
## true
## gap> SCIsStronglyConnected(c);                                                
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAltshulerSteinberg">
## <ManSection>
## <Meth Name="SCAltshulerSteinberg" Arg="complex"/>
## <Returns> a non-negative integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Altshuler-Steinberg determinant.<P/>
## Definition: Let <M>v_i</M>, <M>1 \leq i \leq n</M> be the vertices and let  <M>F_j</M>, <M>1 \leq j \leq m</M> be the facets of a pure simplicial complex <M>C</M>, then the determinant of <M>AS \in \mathbb{Z}^{n \times m}</M>, <M>AS_{ij}=1</M> if <M>v_i \in F_j</M>, <M>AS_{ij}=0</M> otherwise, is called the Altshuler-Steinberg matrix. The Altshuler-Steinberg determinant is the determinant of the quadratic matrix <M>AS \cdot AS^T</M>.<P/>
## The Altshuler-Steinberg determinant is a combinatorial invariant of <M>C</M> and can be checked before searching for an isomorphism between two simplicial complexes. 
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("T^2");; 
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> SCAltshulerSteinberg(torus);
## 73728
## gap> c:=SCBdSimplex(3);;
## gap> SCAltshulerSteinberg(c);
## 9
## gap> c:=SCBdSimplex(4);;
## gap> SCAltshulerSteinberg(c);
## 16
## gap> c:=SCBdSimplex(5);;
## gap> SCAltshulerSteinberg(c);
## 25
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomologyClassic">
## <ManSection>
## <Func Name="SCHomologyClassic" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ integer, list ]</C>.</Returns>
## <Description>
## Computes the integral simplicial homology groups of a simplicial complex <Arg>complex</Arg> 
## (internally calls the function <C>SimplicialHomology(complex.FacetsEx)</C> from the 
## <Package>homology</Package> package, see <Cite Key="Dumas04Homology" />).<P/>
##
## If the <Package>homology</Package> package is not available, this function call 
## falls back to <Ref Func="SCHomologyInternal" />.
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, where 
## <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the homology groups 
## <M>H_i</M> is given in terms of their maximal cyclic subgroups, i.e. a homology group 
## <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> 
## is returned in form of a list <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> is the (integer) 
## free part of <M>H_i</M> and <M>t_i</M> denotes the torsion parts of <M>H_i</M> ordered in 
## weakly increasing size.<P/>
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2");
## [ [ 18, "K^2 (VT)" ], [ 221, "K^2 (VT)" ] ]
## gap> kleinBottle:=SCLib.Load(last[1][1]);;
## gap> kleinBottle.Homology;          
## [ [ 0, [  ] ], [ 1, [ 2 ] ], [ 0, [  ] ] ]
## gap> SCLib.SearchByName("L_"){[1..10]};
## [ [ 123, "L_3_1" ], [ 265, "L_4_1" ], [ 289, "L_5_2" ], 
##   [ 368, "(S^2~S^1)#L_3_1" ], [ 369, "(S^2xS^1)#L_3_1" ], [ 400, "L_5_1" ], 
##   [ 403, "(S^2~S^1)#2#L_3_1" ], [ 406, "(S^2xS^1)#2#L_3_1" ], 
##   [ 496, "L_7_2" ], [ 498, "L_8_3" ] ]
## gap> c:=SCConnectedSum(SCLib.Load(last[9][1]),
##                        SCConnectedProduct(SCLib.Load(last[10][1]),2));
## > <SimplicialComplex: L_7_2#+-L_8_3#+-L_8_3 | dim = 3 | n = 40>
## gap> SCHomology(c);
## [ [ 0, [  ] ], [ 0, [ 8, 56 ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> SCFpBettiNumbers(c,2);
## [ 1, 2, 2, 1 ]
## gap> SCFpBettiNumbers(c,3);
## [ 1, 0, 0, 1 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFpBettiNumbers">
## <ManSection>
## <Meth Name="SCFpBettiNumbers" Arg="complex,p"/>
## <Returns> a list of non-negative integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Betti numbers of a simplicial complex with respect to the field <M>\mathbb{F}_p</M> for any prime number <C>p</C>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2");    
## [ [ 18, "K^2 (VT)" ], [ 221, "K^2 (VT)" ] ]
## gap> kleinBottle:=SCLib.Load(last[1][1]);; 
## gap> SCHomology(kleinBottle);      
## [ [ 0, [  ] ], [ 1, [ 2 ] ], [ 0, [  ] ] ]
## gap> SCFpBettiNumbers(kleinBottle,2);
## [ 1, 2, 1 ]
## gap> SCFpBettiNumbers(kleinBottle,3);
## [ 1, 1, 0 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDualGraph">
## <ManSection>
## <Meth Name="SCDualGraph" Arg="complex"/>
## <Returns>1-dimensional simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dual graph of the pure simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> sphere:=SCBdSimplex(5);;
## gap> graph:=SCFaces(sphere,1);       
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 4 ], 
##   [ 2, 5 ], [ 2, 6 ], [ 3, 4 ], [ 3, 5 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], 
##   [ 5, 6 ] ]
## gap> graph:=SC(graph);;              
## gap> dualGraph:=SCDualGraph(sphere); 
## <SimplicialComplex: dual graph of S^4_6 | dim = 1 | n = 6>
## gap> graph.Facets = dualGraph.Facets;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAutomorphismGroup">
## <ManSection>
## <Meth Name="SCAutomorphismGroup" Arg="complex"/>
## <Returns>a &GAP; permutation group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, i. e. the group of all automorphisms on the set of vertices of <Arg>complex</Arg> that do not change the complex as a whole. Necessarily the group is a subgroup of the symmetric group <M>S_n</M> where <M>n</M> is the number of vertices of the simplicial complex.<P/>
## The function uses an efficient algorithm provided by the package <Package>GRAPE</Package> (see <Cite Key="Soicher06GRAPE"/>, which is based on the program <C>nauty</C> by Brendan McKay <Cite Key="McKay84Nauty"/>).
## If the package <Package>GRAPE</Package> is not available, this function call falls back to <Ref Meth="SCAutomorphismGroupInternal"/>.<P/>
## The position of the group in the &GAP; libraries of small groups, transitive groups or primitive groups is given. If the group is not listed, its structure description, provided by the &GAP; function <C>StructureDescription()</C>, is returned as the name of the group. Note that the latter form is not always unique, since every non trivial semi-direct product is denoted by ''<C>:</C>''.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");            
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> k3surf:=SCLib.Load(last[1][1]);; 
## gap> SCAutomorphismGroup(k3surf);               
## Group([ (1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16), (1,2,8,14,5)
##   (3,11,9,4,13)(6,7,12,15,10), (1,3,2)(5,11,14)(6,9,15)(7,10,13)(8,12,16) ])
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAutomorphismGroupSize">
## <ManSection>
## <Meth Name="SCAutomorphismGroupSize" Arg="complex"/>
## <Returns>a positive integer group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the size of the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, see <Ref Meth="SCAutomorphismGroup"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");            
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> k3surf:=SCLib.Load(last[1][1]);;           
## gap> SCAutomorphismGroupSize(k3surf);               
## 240
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAutomorphismGroupStructure">
## <ManSection>
## <Meth Name="SCAutomorphismGroupStructure" Arg="complex"/>
## <Returns>the &GAP; structure description upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the &GAP; structure description of the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, see <Ref Meth="SCAutomorphismGroup"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");     
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> k3surf:=SCLib.Load(last[1][1]);;      
## gap> SCAutomorphismGroupStructure(k3surf);
## "(C2 x C2 x C2 x C2) : C15"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAutomorphismGroupTransitivity">
## <ManSection>
## <Meth Name="SCAutomorphismGroupTransitivity" Arg="complex"/>
## <Returns>a positive integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the transitivity of the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, i. e. the maximal integer <M>t</M> such that for any two ordered <M>t</M>-tuples <M>T_1</M> and <M>T_2</M> of vertices of <Arg>complex</Arg>, there exists an element <M>g</M> in the automorphism group of <Arg>complex</Arg> for which <M>gT_1=T_2</M>, see <Cite Key="Huppert67EndlGruppen" />. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");            
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> k3surf:=SCLib.Load(last[1][1]);;           
## gap> SCAutomorphismGroupTransitivity(k3surf);               
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAutomorphismGroupInternal">
## <ManSection>
## <Meth Name="SCAutomorphismGroupInternal" Arg="complex"/>
## <Returns>a &GAP; permutation group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, i. e. the group of all automorphisms on the set of vertices of <Arg>complex</Arg> that do not change the complex as a whole. Necessarily the group is a subgroup of the symmetric group <M>S_n</M> where <M>n</M> is the number of vertices of the simplicial complex.<P/>
## The position of the group in the &GAP; libraries of small groups, transitive groups or primitive groups is given. If the group is not listed, its structure description, provided by the &GAP; function <C>StructureDescription()</C>, is returned as the name of the group. Note that the latter form is not always unique, since every non trivial semi-direct product is denoted by ''<C>:</C>''.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCAutomorphismGroupInternal(c);
## Sym( [ 1 .. 6 ] )
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[1,3]]);;
## gap> g:=SCAutomorphismGroupInternal(c);
## Group([ (2,3), (1,2,3) ])
## gap> List(g);
## [ (), (1,2,3), (1,3,2), (2,3), (1,2), (1,3) ]
## gap> StructureDescription(g);
## "S3"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCGeneratorsEx">
## <ManSection>
## <Meth Name="SCGeneratorsEx" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ list, integer ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the generators of a simplicial complex in the standard vertex labeling.<P/>
## The generating set of a simplicial complex is a list of simplices that will generate the complex by uniting their <M>G</M>-orbits if <M>G</M> is the automorphism group of <Arg>complex</Arg>.<P/>
## The function returns the simplices together with the length of their orbits.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("T^2");;
## gap> torus:=SCLib.Load(list[1][1]);;
## gap> SCGeneratorsEx(torus); 
## [ [ [ 1, 2, 4 ], 14 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> SCLib.Load(last[1][1]);
## <SimplicialComplex: K3_16 | dim = 4 | n = 16>
## gap> SCGeneratorsEx(last);
## [ [ [ 1, 2, 3, 8, 12 ], 240 ], [ [ 1, 2, 5, 8, 14 ], 48 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCGenerators">
## <ManSection>
## <Meth Name="SCGenerators" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ list, integer ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the generators of a simplicial complex in the original vertex labeling.<P/>
## The generating set of a simplicial complex is a list of simplices that  will generate the complex by uniting their <M>G</M>-orbits if <M>G</M> is the automorphism group of <Arg>complex</Arg>.<P/>
## The function returns the simplices together with the length of their orbits.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("T^2");;
## gap> torus:=SCLib.Load(list[1][1]);;
## gap> SCGenerators(torus); 
## [ [ [ 1, 2, 4 ], 14 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> SCLib.Load(last[1][1]);
## <SimplicialComplex: K3_16 | dim = 4 | n = 16>
## gap> SCGenerators(last);
## [ [ [ 1, 2, 3, 8, 12 ], 240 ], [ [ 1, 2, 5, 8, 14 ], 48 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDifferenceCycles">
## <ManSection>
## <Meth Name="SCDifferenceCycles" Arg="complex"/>
## <Returns> a list of lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the difference cycles of <Arg>complex</Arg> in standard labeling
## if <Arg>complex</Arg> is invariant under a shift of the vertices of type
## <M>v \mapsto v+1 \mod n</M>.
##
## The function returns the difference cycles as lists where the sum of the entries
## equals the number of vertices <M>n</M> of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> torus:=SCFromDifferenceCycles([[1,2,4],[1,4,2]]);
## <SimplicialComplex: complex from diffcycles [ [ 1, 2, 4 ], [ 1, 4, 2 ] ] | dim\
##  = 2 | n = 7>
## gap> torus.Homology;
## [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
## gap> torus.DifferenceCycles;
## [ [ 1, 2, 4 ], [ 1, 4, 2 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsCentrallySymmetric">
## <ManSection>
## <Meth Name="SCIsCentrallySymmetric" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is centrally symmetric, i. e. if its automorphism group contains a fixed point free involution.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCIsCentrallySymmetric(c);
## true
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> SCIsCentrallySymmetric(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCentrallySymmetricElement">
## <ManSection>
## <Meth Name="SCCentrallySymmetricElement" Arg="complex"/>
## <Returns>an automorphism of <Arg>complex</Arg> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the centrally symmetric element of the automorphism group of  <Arg>complex</Arg> if the simplicial complex <Arg>complex</Arg> is centrally symmetric.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCCentrallySymmetricElement(c);
## (1,2)(3,4)(5,6)(7,8)
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNeighborliness">
## <ManSection>
## <Meth Name="SCNeighborliness" Arg="complex"/>
## <Returns> a positive integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <M>k</M> if a simplicial complex <Arg>complex</Arg> is <M>k</M>-neighborly but not  <M>(k+1)</M>-neighborly. See also <Ref Meth="SCIsKNeighborly" />.<P/>
## Note that every complex is at least <M>1</M>-neighborly.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> SCNeighborliness(c);
## 4
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCNeighborliness(c);
## 1
## gap> SCLib.SearchByAttribute("F[3]=Binomial(F[1],3) and Dim=4");
## [ [ 16, "CP^2 (VT)" ], [ 520, "K3_16" ] ]
## gap> cp2:=SCLib.Load(last[1][1]);;
## gap> SCNeighborliness(cp2);
## 3
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsShellable">
## <ManSection>
## <Meth Name="SCIsShellable" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary (cf. <Ref Meth="SCBoundary"/>).<P/>
## The function checks whether <Arg>complex</Arg> is shellable or not. An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is called a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>. A simplicial complex is called shellable, if at least one shelling exists.<P/>
## See <Cite Key="Ziegler95LectPolytopes" />, <Cite Key="Pachner87KonstrMethKombHomeo" /> to learn more about shellings.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;       
## gap> c:=Difference(c,SC([[1,3,5,7]]));; # bounded version
## gap> SCIsShellable(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsOrientable">
## <ManSection>
## <Meth Name="SCIsOrientable" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg>, satisfying the weak pseudomanifold property, is orientable.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCIsOrientable(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCBoundary">
## <ManSection>
## <Meth Name="SCBoundary" Arg="complex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The function computes the boundary of a simplicial complex <Arg>complex</Arg> satisfying the weak pseudomanifold property and returns it as a simplicial complex. In addition, it is stored as a property of <Arg>complex</Arg>.<P/>
## The boundary of a simplicial complex is defined as the simplicial complex consisting of all <M>d-1</M>-faces that are contained in exactly one facet. <P/>
## If <Arg>complex</Arg> does not fulfill the weak pseudomanifold property (i. e. if the valence of any <M>d-1</M>-face exceeds <M>2</M>) the function returns <K>fail</K>.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);
## <SimplicialComplex: unnamed complex 63 | dim = 3 | n = 5>
## gap> SCBoundary(c);
## <SimplicialComplex: Bd(unnamed complex 63) | dim = 2 | n = 4>
## gap> c;  
## <SimplicialComplex: unnamed complex 63 | dim = 3 | n = 5>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHasBoundary">
## <ManSection>
## <Meth Name="SCHasBoundary" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> that fulfills the weak pseudo manifold property has a boundary, i. e. <M>d-1</M>-faces of valence <M>1</M>. If <Arg>complex</Arg> is closed <K>false</K> is returned, if <Arg>complex</Arg> does not fulfill the weak pseudomanifold property, <K>fail</K> is returned, otherwise <K>true</K> is returned.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2"); 
## [ [ 18, "K^2 (VT)" ], [ 221, "K^2 (VT)" ] ]
## gap> kleinBottle:=SCLib.Load(last[1][1]);;
## gap> SCHasBoundary(kleinBottle);
## false
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);;
## gap> SCHasBoundary(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCInterior">
## <ManSection>
## <Meth Name="SCInterior" Arg="complex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all <M>d-1</M>-faces of valence <M>2</M> of a simplicial complex <Arg>complex</Arg> that fulfills the weak pseudomanifold property, i. e. the function returns the part of the <M>d-1</M>-skeleton of <M>C</M> that is not part of the boundary. 
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);;
## gap> SCInterior(c).Facets;
## [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 2, 5 ], [ 1, 3, 4 ], [ 1, 3, 5 ], 
##   [ 1, 4, 5 ] ]
## gap> c:=SC([[1,2,3,4]]);;
## gap> SCInterior(c).Facets;
## [  ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHasInterior">
## <ManSection>
## <Meth Name="SCHasInterior" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> if a simplicial complex <Arg>complex</Arg> that fulfills the weak pseudomanifold property has at least one <M>d-1</M>-face of valence <M>2</M>, i. e. if there exist at least one <M>d-1</M>-face that is not in the boundary of <Arg>complex</Arg>, if no such face can be found <K>false</K> is returned. It <Arg>complex</Arg> does not fulfill the weak pseudomanifold property <K>fail</K> is returned.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);;
## gap> SCHasInterior(c)
## true
## gap> c:=SC([[1,2,3,4]]);;
## gap> SCHasInterior(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsEulerianManifold">
## <ManSection>
## <Meth Name="SCIsEulerianManifold" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether a given simplicial complex <Arg>complex</Arg> is a Eulerian manifold or not, i. e. checks if all vertex links of <Arg>complex</Arg> have the Euler characteristic of a sphere. In particular the function returns <K>false</K> in case <Arg>complex</Arg> has a non-empty boundary.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> SCIsEulerianManifold(c);
## true
## gap> SCLib.SearchByName("Moebius");
## [ [ 1, "Moebius Strip" ] ]
## gap> moebius:=SCLib.Load(last[1][1]); # a moebius strip
## <SimplicialComplex: Moebius Strip | dim = 2 | n = 5>
## gap> SCIsEulerianManifold(moebius);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSkelEx">
## <ManSection>
## <Meth Name="SCSkelEx" Arg="complex,k"/>
## <Returns> a face list or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <Arg>k</Arg> is an integer, the <Arg>k</Arg>-skeleton of a simplicial complex <Arg>complex</Arg>, i. e. all <Arg>k</Arg>-faces of <Arg>complex</Arg>, is computed. If <Arg>k</Arg> is a list, a list of all <Arg>k</Arg><C>[i]</C>-faces of <Arg>complex</Arg> for each entry <Arg>k</Arg><C>[i]</C> (which has to be an integer) is returned. The faces are returned in the standard labeling.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2"); 
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;      
## gap> rp2_6:=SC(rp2_6.Facets+10);;
## gap> SCSkelEx(rp2_6,1);
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 4 ], 
##   [ 2, 5 ], [ 2, 6 ], [ 3, 4 ], [ 3, 5 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], 
##   [ 5, 6 ] ]
## gap> SCSkel(rp2_6,1);  
## [ [ 11, 12 ], [ 11, 13 ], [ 11, 14 ], [ 11, 15 ], [ 11, 16 ], [ 12, 13 ], 
##   [ 12, 14 ], [ 12, 15 ], [ 12, 16 ], [ 13, 14 ], [ 13, 15 ], [ 13, 16 ], 
##   [ 14, 15 ], [ 14, 16 ], [ 15, 16 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSkel">
## <ManSection>
## <Meth Name="SCSkel" Arg="complex,k"/>
## <Returns> a face list or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <Arg>k</Arg> is an integer, the <Arg>k</Arg>-skeleton of a simplicial complex <Arg>complex</Arg>, i. e. all <Arg>k</Arg>-faces of <Arg>complex</Arg>, is computed. If <Arg>k</Arg> is a list, a list of all <Arg>k</Arg><C>[i]</C>-faces of <Arg>complex</Arg> for each entry <Arg>k</Arg><C>[i]</C> (which has to be an integer) is returned. The faces are returned in the original labeling.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2"); 
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;      
## gap> rp2_6:=SC(rp2_6.Facets+10);;
## gap> SCSkelEx(rp2_6,1);
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 4 ], 
##   [ 2, 5 ], [ 2, 6 ], [ 3, 4 ], [ 3, 5 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], 
##   [ 5, 6 ] ]
## gap> SCSkel(rp2_6,1);  
## [ [ 11, 12 ], [ 11, 13 ], [ 11, 14 ], [ 11, 15 ], [ 11, 16 ], [ 12, 13 ], 
##   [ 12, 14 ], [ 12, 15 ], [ 12, 16 ], [ 13, 14 ], [ 13, 15 ], [ 13, 16 ], 
##   [ 14, 15 ], [ 14, 16 ], [ 15, 16 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFaceLatticeEx">
## <ManSection>
## <Meth Name="SCFaceLatticeEx" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the entire face lattice of a <M>d</M>-dimensional simplicial complex, i. e. all of its <M>i</M>-skeletons for <M>0 \leq i \leq d</M>. The faces are returned in the standard labeling.
## <Example><![CDATA[
## gap> c:=SC([["a","b","c"],["a","b","d"], ["a","c","d"], ["b","c","d"]]);;
## gap> SCFaceLatticeEx(c);
## [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ], 
##   [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFaceLattice">
## <ManSection>
## <Meth Name="SCFaceLattice" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the entire face lattice of a <M>d</M>-dimensional simplicial complex, i. e. all of its <M>i</M>-skeletons for <M>0 \leq i \leq d</M>. The faces are returned in the original labeling.
## <Example><![CDATA[
## gap> c:=SC([["a","b","c"],["a","b","d"], ["a","c","d"], ["b","c","d"]]);;
## gap> SCFaceLattice(c);
## [ [ [ "a" ], [ "b" ], [ "c" ], [ "d" ] ], 
##   [ [ "a", "b" ], [ "a", "c" ], [ "a", "d" ], [ "b", "c" ], [ "b", "d" ], 
##       [ "c", "d" ] ], 
##   [ [ "a", "b", "c" ], [ "a", "b", "d" ], [ "a", "c", "d" ], 
##       [ "b", "c", "d" ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIncidencesEx">
## <ManSection>
## <Meth Name="SCIncidencesEx" Arg="complex,k"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all <Arg>k</Arg>-faces of the simplicial complex <Arg>complex</Arg>. The list is sorted by the valence of the faces in the <Arg>k</Arg>+1-skeleton of the complex, i. e. the <M>i</M>-th entry of the list contains all <Arg>k</Arg>-faces of valence <M>i</M>. The faces are returned in the standard labeling.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[2,3,4],[3,4,5],[4,5,6],[1,5,6],[1,4,6],[2,3,6]]);;
## gap> SCIncidences(c,1);
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 6 ], [ 3, 5 ], 
##       [ 3, 6 ] ], [ [ 1, 6 ], [ 3, 4 ], [ 4, 5 ], [ 4, 6 ], [ 5, 6 ] ], 
##   [ [ 2, 3 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIncidences">
## <ManSection>
## <Meth Name="SCIncidences" Arg="complex,k"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all <Arg>k</Arg>-faces of the simplicial complex <Arg>complex</Arg>. The list is sorted by the valence of the faces in the <Arg>k</Arg>+1-skeleton of the complex, i. e. the <M>i</M>-th entry of the list contains all <Arg>k</Arg>-faces of valence <M>i</M>. The faces are returned in the original labeling.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[2,3,4],[3,4,5],[4,5,6],[1,5,6],[1,4,6],[2,3,6]]);;
## gap> SCIncidences(c,1);
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 6 ], [ 3, 5 ], 
##       [ 3, 6 ] ], [ [ 1, 6 ], [ 3, 4 ], [ 4, 5 ], [ 4, 6 ], [ 5, 6 ] ], 
##   [ [ 2, 3 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCVerticesEx">
## <ManSection>
## <Meth Name="SCVerticesEx" Arg="complex"/>
## <Returns> <M>[ 1, \ldots , n ]</M> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <M>\left[1, \ldots , n \right]</M>, where <M>n</M> is the number of vertices of a simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SC([[1,4,5],[4,9,8],[12,13,14,15,16,17]]);;
## gap> SCVerticesEx(c);
## [ 1 .. 11 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCVertices">
## <ManSection>
## <Meth Name="SCVertices" Arg="complex"/>
## <Returns> a list of vertex labels of <Arg>complex</Arg> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the vertex labels of a simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> sphere:=SC([["x",45,[1,1]],["x",45,["b",3]],["x",[1,1],
##   ["b",3]],[45,[1,1],["b",3]]]);;
## gap> SCVerticesEx(sphere);
## [ 1 .. 4 ]
## gap> SCVertices(sphere);
## [ 45, [ 1, 1 ], "x", [ "b", 3 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsHomologySphere">
## <ManSection>
## <Meth Name="SCIsHomologySphere" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether a simplicial complex <Arg>complex</Arg> is a homology sphere, i. e. has the homology of a sphere, or not.
## <Example><![CDATA[
## gap> c:=SC([[2,3],[3,4],[4,2]]);;
## gap> SCIsHomologySphere(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsInKd">
## <ManSection>
## <Meth Name="SCIsInKd" Arg="complex, k"/>
## <Returns> <K>true</K> / <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether the simplicial complex <Arg>complex</Arg> that must be a combinatorial <M>d</M>-manifold is in the class <M>\mathcal{K}^k(d)</M>, <M>1\leq k\leq \lfloor\frac{d+1}{2}\rfloor</M>, of simplicial complexes that only have <M>k</M>-stacked spheres as vertex links, see <Cite Key="Effenberger09StackPolyTightTrigMnf" />. Note that it is not checked whether <Arg>complex</Arg> is a combinatorial manifold -- if not, the algorithm will not succeed.
## Returns <K>true</K> / <K>false</K> upon success. If <K>true</K> is returned this means that <Arg>complex</Arg> is at least <Arg>k</Arg>-stacked and thus that the complex is in the class <M>\mathcal{K}^k(d)</M>, i.e. all vertex links are <C>i</C>-stacked spheres. If <K>false</K> is returnd the complex cannot be <Arg>k</Arg>-stacked. In some cases the question can not be decided. In this case <K>fail</K> is returned.<P/>
## Internally calls <Ref Meth="SCIsKStackedSphere"/> for all links. Please note that this is a radomized algorithm that may give an indefinite answer to the membership problem.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2~S^1"){[1..3]};;
## gap> c:=SCLib.Load(list[1][1]);;
## gap> c.AutomorphismGroup;
## Group([ (1,2,3,4,5,6,7,8,9), (1,3)(4,9)(5,8)(6,7) ])
## gap> SCIsInKd(c,1);
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDehnSommervilleMatrix">
## <ManSection>
## <Meth Name="SCDehnSommervilleMatrix" Arg="d"/>
## <Returns> a <C>(d+1)</C><M>\times</M><C>Int(d+1/2)</C> matrix with integer entries upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the coefficients of the Dehn Sommerville equations for dimension <C>d</C>: <M>h_j - h_{d+1-j} = (-1)^{d+1-j} { d+1 \choose j } (\chi (M) - 2)</M> for <M>0 \leq j \leq \frac{d}{2}</M> and <M>d</M> even, and <M>h_j - h_{d+1-j} = 0</M> for <M>0 \leq j \leq \frac{d-1}{2}</M> and <M>d</M> odd. Where <M>h_j</M> is the <M>j</M>th component of the <M>h</M>-vector, see <Ref Func="SCHVector"/>.
## <Example><![CDATA[
## gap> m:=SCDehnSommervilleMatrix(6);;
## gap> PrintArray(m);
## [ [    1,   -1,    1,   -1,    1,   -1,    1 ],
##   [    0,   -2,    3,   -4,    5,   -6,    7 ],
##   [    0,    0,    0,   -4,   10,  -20,   35 ],
##   [    0,    0,    0,    0,    0,   -6,   21 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDehnSommervilleCheck">
## <ManSection>
## <Meth Name="SCDehnSommervilleCheck" Arg="c"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if the simplicial complex <Arg>c</Arg> fulfills the Dehn Sommerville equations: <M>h_j - h_{d+1-j} = (-1)^{d+1-j} { d+1 \choose j } (\chi (M) - 2)</M> for <M>0 \leq j \leq \frac{d}{2}</M> and <M>d</M> even, and <M>h_j - h_{d+1-j} = 0</M> for <M>0 \leq j \leq \frac{d-1}{2}</M> and <M>d</M> odd. Where <M>h_j</M> is the <M>j</M>th component of the <M>h</M>-vector, see <Ref Func="SCHVector"/>.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(6);;
## gap> SCDehnSommervilleCheck(c);
## true
## gap> c:=SC([[1,2,3],[1,4,5]]);;
## gap> SCDehnSommervilleCheck(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHeegaardSplitting">
## <ManSection>
## <Meth Name="SCHeegaardSplitting" Arg="M"/>
##  <Returns> a list of an integer, a list of two sublists and a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a Heegaard splitting of the combinatorial <M>3</M>-manifold  <Arg>M</Arg>. The function returns the genus of the Heegaard splitting, the vertex partition of the Heegaard splitting and a note, that splitting is arbitrary and in particular possibly not minimal.
## 
## See also <Ref Func="SCHeegaardSplittingSmallGenus"/> for the calculation of a Heegaard splitting of small genus and <Ref Func="SCIsHeegaardSplitting"/> for a test whether or not a given splitting defines a Heegaard splitting.
## <Example><![CDATA[
## gap> M:=SCSeriesBdHandleBody(3,12);;
## gap> list:=SCHeegaardSplitting(M);
## [ 1, [ [ 1, 2, 3, 5, 9 ], [ 4, 6, 7, 8, 10, 11, 12 ] ], "arbitrary" ]
## gap> sl:=SCSlicing(M,list[2]);
## <NormalSurface: slicing [ [ 1, 2, 3, 5, 9 ], [ 4, 6, 7, 8, 10, 11, 12 ] ] of S\
## phere bundle S^2 x S^1 | dim = 2>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHeegaardSplittingSmallGenus">
## <ManSection>
## <Meth Name="SCHeegaardSplittingSmallGenus" Arg="M"/>
## <Returns> a list of an integer, a list of two sublists and a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a Heegaard splitting of the combinatorial <M>3</M>-manifold  <Arg>M</Arg> of small genus. The function returns the genus of the Heegaard splitting, the vertex partition of the Heegaard splitting and information whether the splitting is minimal or just small (i. e. the Heegaard genus could not be determined).
## 
## See also <Ref Func="SCHeegaardSplitting"/> for a faster computation of a Heegaard splitting of arbitrary genus and <Ref Func="SCIsHeegaardSplitting"/> for a test whether or not a given splitting defines a Heegaard splitting.
## <Example><![CDATA[ 
## gap> c:=SCSeriesBdHandleBody(3,10);;
## gap> M:=SCConnectedProduct(c,3);;
## gap> list:=SCHeegaardSplittingSmallGenus(M);
## This creates an error
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsHeegaardSplitting">
## <ManSection>
## <Meth Name="SCIsHeegaardSplitting" Arg="c,list"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether <Arg>list</Arg> defines a Heegaard splitting of <Arg>c</Arg> or not.
## 
## See also <Ref Func="SCHeegaardSplitting"/> and <Ref Func="SCHeegaardSplittingSmallGenus"/> for functions to compute Heegaard splittings.
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(3,9);;
## gap> list:=[[1..3],[4..9]];
## [ [ 1 .. 3 ], [ 4 .. 9 ] ]
## gap> SCIsHeegaardSplitting(c,list);
## false
## gap> splitting:=SCHeegaardSplitting(c);
## [ 1, [ [ 1, 2, 3, 6 ], [ 4, 5, 7, 8, 9 ] ], "arbitrary" ]
## gap> SCIsHeegaardSplitting(c,splitting[2]);                                         
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
