################################################################################
##
##  simpcomp / operations.gi
##
##  Operations on simplicial complexes.
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCJoin">
## <ManSection>
## <Meth Name="SCJoin" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the simplicial join of the simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg>. If facet lists instead of <C>SCSimplicialComplex</C> objects are passed as arguments, the function internally falls back to the homology package <Cite Key="Dumas04Homology" />, if available. Note that the vertex labelings of the complexes passed as arguments are not propagated to the new complex.
## <Example>
## gap&gt; sphere:=SCJoin(SCBdSimplex(2),SCBdSimplex(2));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="S^1_3 join S^1_3"
##  Dim=3
## 
## /SimplicialComplex]
## gap&gt; SCHasBoundary(sphere);
## false
## gap&gt; sphere.Facets;
## [ [ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ] ], 
##   [ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 3 ] ], 
##   [ [ 1, 1 ], [ 1, 2 ], [ 2, 2 ], [ 2, 3 ] ], 
##   [ [ 1, 1 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ] ], 
##   [ [ 1, 1 ], [ 1, 3 ], [ 2, 1 ], [ 2, 3 ] ], 
##   [ [ 1, 1 ], [ 1, 3 ], [ 2, 2 ], [ 2, 3 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 3 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ], [ 2, 2 ], [ 2, 3 ] ] ]
## gap&gt; sphere.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## </Example>
## <Example>
## gap&gt; ball:=SCJoin(SC([[1]]),SCBdSimplex(2));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="unnamed complex 4 join S^1_3"
##  Dim=2
## 
## /SimplicialComplex]
## gap&gt; ball.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ] ]
## gap&gt; ball.Facets;
## [ [ [ 1, 1 ], [ 2, 1 ], [ 2, 2 ] ], [ [ 1, 1 ], [ 2, 1 ], [ 2, 3 ] ], 
##   [ [ 1, 1 ], [ 2, 2 ], [ 2, 3 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSuspension">
## <ManSection>
## <Meth Name="SCSuspension" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the simplicial suspension of the simplicial complex <Arg>complex</Arg>. Internally falls back to the homology package <Cite Key="Dumas04Homology" /> (if available) if a facet list is passed as argument. Note that the vertex labelings of the complexes passed as arguments are not propagated to the new complex.
## <Example>
## gap&gt; SCLib.SearchByName("Poincare");
## [ [ 7469, "Poincare_sphere" ] ]
## gap&gt; phs:=SCLib.Load(last[1][1]);
## [SimplicialComplex
## 
##  Properties known: AltshulerSteinberg, AutomorphismGroup, 
##                    AutomorphismGroupSize, AutomorphismGroupStructure, 
##                    AutomorphismGroupTransitivity, ConnectedComponents, 
##                    Dim, DualGraph, EulerCharacteristic, FVector, 
##                    FacetsEx, GVector, GeneratorsEx, HVector, 
##                    HasBoundary, HasInterior, Homology, Interior, 
##                    IsCentrallySymmetric, IsConnected, 
##                    IsEulerianManifold, IsManifold, IsOrientable, 
##                    IsPseudoManifold, IsPure, IsStronglyConnected, 
##                    MinimalNonFacesEx, Name, Neighborliness, 
##                    NumFaces[], Orientation, SkelExs[], Vertices.
## 
##  Name="Poincare_sphere"
##  Dim=3
##  AltshulerSteinberg=115400413872363901952
##  AutomorphismGroupSize=1
##  AutomorphismGroupStructure="1"
##  AutomorphismGroupTransitivity=0
##  EulerCharacteristic=0
##  FVector=[ 16, 106, 180, 90 ]
##  GVector=[ 11, 52 ]
##  HVector=[ 12, 64, 12, 1 ]
##  HasBoundary=false
##  HasInterior=true
##  Homology=[ [ 0, [ ] ], [ 0, [ ] ], [ 0, [ ] ], [ 1, [ ] ] ]
##  IsCentrallySymmetric=false
##  IsConnected=true
##  IsEulerianManifold=true
##  IsOrientable=true
##  IsPseudoManifold=true
##  IsPure=true
##  IsStronglyConnected=true
##  Neighborliness=1
## 
## /SimplicialComplex]
## gap&gt; susp:=SCSuspension(phs);;
## gap&gt; edwardsSphere:=SCSuspension(susp);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="susp of susp of Poincare_sphere"
##  Dim=5
## 
## /SimplicialComplex]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDeletedJoin">
## <ManSection>
## <Meth Name="SCDeletedJoin" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the simplicial deleted join of the simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg>. If called with a facet list instead of a <C>SCSimplicialComplex</C> object, the function internally falls back to the <Package>homology</Package> package <Cite Key="Dumas04Homology" />, if available.
## <Example>
## gap&gt; deljoin:=SCDeletedJoin(SCBdSimplex(3),SCBdSimplex(3));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="S^2_4 deljoin S^2_4"
##  Dim=3
## 
## /SimplicialComplex]
## gap&gt; bddeljoin:=SCBoundary(deljoin);;
## gap&gt; bddeljoin.Homology;
## [ [ 1, [  ] ], [ 0, [  ] ], [ 2, [  ] ] ]
## gap&gt; deljoin.Facets;
## [ [ [ 1, 1 ], [ 2, 1 ], [ 3, 1 ], [ 4, 2 ] ], 
##   [ [ 1, 1 ], [ 2, 1 ], [ 3, 2 ], [ 4, 1 ] ], 
##   [ [ 1, 1 ], [ 2, 1 ], [ 3, 2 ], [ 4, 2 ] ], 
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 1 ], [ 4, 1 ] ], 
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 1 ], [ 4, 2 ] ], 
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 2 ], [ 4, 1 ] ], 
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 2 ], [ 4, 2 ] ], 
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 1 ], [ 4, 1 ] ], 
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 1 ], [ 4, 2 ] ], 
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 2 ], [ 4, 1 ] ], 
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 2 ], [ 4, 2 ] ], 
##   [ [ 1, 2 ], [ 2, 2 ], [ 3, 1 ], [ 4, 1 ] ], 
##   [ [ 1, 2 ], [ 2, 2 ], [ 3, 1 ], [ 4, 2 ] ], 
##   [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ], [ 4, 1 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCWedge">
## <ManSection>
## <Meth Name="SCWedge" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the wedge product of the complexes supplied as arguments. Note that the vertex labelings of the complexes passed as arguments are not propagated to the new complex.
## <Example>
## gap&gt; wedge:=SCWedge(SCBdSimplex(2),SCBdSimplex(2));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="unnamed complex 17"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; wedge.Facets;
## [ [ 1, [ 1, 2 ] ], [ 1, [ 1, 3 ] ], [ 1, [ 2, 2 ] ], [ 1, [ 2, 3 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ] ], [ [ 2, 2 ], [ 2, 3 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCollapseGreedy">
## <ManSection>
## <Meth Name="SCCollapseGreedy" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm in order to collapse the simplicial complex <Arg>complex</Arg>. The source code of this function is taken from <Cite Key="Lutz08ManifoldPage" />. 
## <Example>
## gap&gt; SCLib.SearchByName("T^2"){[1..6]}; 
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 18, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap&gt; torus:=SCLib.Load(last[1][1]);;
## gap&gt; bdtorus:=SCDifference(torus,SC([torus.Facets[1]]));;
## gap&gt; coll:=SCCollapseGreedy(bdtorus);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="collapsed version of T^2 (VT) \ unnamed complex 18"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; coll.Facets;
## [ [ 3, 6 ], [ 3, 7 ], [ 5, 6 ], [ 5, 7 ], [ 6, 7 ] ]
## gap&gt; sphere:=SCBdSimplex(4);;                              
## gap&gt; bdsphere:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap&gt; coll:=SCCollapseGreedy(bdsphere);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="collapsed version of S^3_5 \ unnamed complex 22"
##  Dim=0
## 
## /SimplicialComplex]
## gap&gt; coll.Facets;                     
## [ [ 5 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDifference">
## <ManSection>
## <Meth Name="SCDifference" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the ``difference'' of two simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> as the simplicial complex formed by the difference of the face lattices of <Arg>complex1</Arg> minus <Arg>complex2</Arg>. The two arguments are not altered. Note: for the difference process the vertex labelings of the complexes are taken into account, see also <Ref Meth="Operation Difference (SCSimplicialComplex, SCSimplicialComplex)"/>.
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; d:=SC([[1,2,3]]);;
## gap&gt; disc:=SCDifference(c,d);;
## gap&gt; disc.Facets;
## [ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
## gap&gt; empty:=SCDifference(d,c);;
## gap&gt; empty.Dim;
## -1
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNeighborsEx">
## <ManSection>
## <Meth Name="SCNeighborsEx" Arg="complex, face"/>
## <Returns>a list of faces upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a simplicial complex <Arg>complex</Arg> all neighbors of the <C>k</C>-face  <Arg>face</Arg>, i. e. all <C>k</C>-faces distinct from <Arg>face</Arg> intersecting with <Arg>face</Arg> in a common <M>(k-1)</M>-face, are returned in the standard labeling.
## <Example>
## gap&gt; c:=SCFromFacets(Combinations(["a","b","c"],2));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="unnamed complex 28"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; SCLabels(c);
## [ "a", "b", "c" ]
## gap&gt; SCNeighborsEx(c,[1,2]);
## [ [ 1, 3 ], [ 2, 3 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
##<#GAPDoc Label="SCNeighbors">
## <ManSection>
## <Meth Name="SCNeighbors" Arg="complex, face"/>
## <Returns>a list of faces upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a simplicial complex <Arg>complex</Arg> all neighbors of the <C>k</C>-face  <Arg>face</Arg>, i. e. all <C>k</C>-faces distinct from <Arg>face</Arg> intersecting with <Arg>face</Arg> in a common <M>(k-1)</M>-face, are returned in the original labeling.
## <Example>
## gap&gt; c:=SCFromFacets(Combinations(["a","b","c"],2));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="unnamed complex 29"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; SCNeighbors(c,["a","d"]);
## [ [ "a", "b" ], [ "a", "c" ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
##<#GAPDoc Label="SCIntersection">
## <ManSection>
## <Meth Name="SCIntersection" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the ``intersection'' of two simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> as the simplicial complex formed by the intersection of the face lattices of <Arg>complex1</Arg> and <Arg>complex2</Arg>. The two arguments are not altered. Note: for the intersection process the vertex labelings of the complexes are taken into account. See also <Ref Meth="Operation Intersection (SCSimplicialComplex, SCSimplicialComplex)"/>.
## <Example>
## gap&gt; c:=SCBdSimplex(3);;        
## gap&gt; d:=SCBdSimplex(3)+1;;      
## gap&gt; d.Facets;
## [ [ 2, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ] ]
## gap&gt; c:=SCBdSimplex(3);;  
## gap&gt; d:=SCBdSimplex(3);;  
## gap&gt; d:=SCMove(d,[[1,2,3],[]])+1;;
## gap&gt; s1:=SCIntersection(c,d);;
## gap&gt; s1.Facets;               
## [ [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
##<#GAPDoc Label="SCUnion">
## <ManSection>
## <Meth Name="SCUnion" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the union of two simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> as the simplicial complex formed by the union of their facets sets. The two arguments are not altered. Note: for the union process the vertex labelings of the complexes are taken into account, see also <Ref Meth="Operation Union (SCSimplicialComplex, SCSimplicialComplex)" />. Facets occurring in both arguments are treated as one facet in the new complex.
## <Example>
## gap&gt; c:=SCUnion(SCBdSimplex(3),SCBdSimplex(3)+3); #a wedge of two 2-spheres
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="S^2_4 cup S^2_4"
##  Dim=2
## 
## /SimplicialComplex]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsSubcomplex">
## <ManSection>
## <Meth Name="SCIsSubcomplex" Arg="sc1,sc2"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> if the simplicial complex <Arg>sc2</Arg> is a sub-complex of simplicial complex <Arg>sc1</Arg>, <K>false</K> otherwise. If dim(<Arg>sc2</Arg>) <M>\leq</M> dim(<Arg>sc1</Arg>) the facets of <Arg>sc2</Arg> are compared with the dim(<Arg>sc2</Arg>)-skeleton of <Arg>sc1</Arg>. Only works for pure simplicial complexes. Note: for the intersection process the vertex labelings of the complexes are taken into account. 
## <Example>
## gap&gt; SCLib.SearchByAttribute("F[1]=10"){[1..10]};
## [ [ 17, "K^2 (VT)" ], [ 18, "T^2 (VT)" ], [ 19, "S^3 (VT)" ], 
##   [ 20, "(T^2)#2" ], [ 21, "S^3 (VT)" ], [ 22, "S^2xS^1 (VT)" ], 
##   [ 23, "S^3 (VT)" ], [ 24, "(T^2)#3" ], [ 25, "(P^2)#7 (VT)" ], 
##   [ 26, "S^3 (VT)" ] ]
## gap&gt; k:=SCLib.Load(last[1][1]);;
## gap&gt; c:=SCBdSimplex(9);;
## gap&gt; k.F;
## [ 10, 30, 20 ]
## gap&gt; c.F;
## [ 10, 45, 120, 210, 252, 210, 120, 45, 10 ]
## gap&gt; SCIsSubcomplex(c,k);
## true
## gap&gt; SCIsSubcomplex(k,c);
## false
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAlexanderDual">
## <ManSection>
## <Meth Name="SCAlexanderDual" Arg="complex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The Alexander dual of a simplicial complex <Arg>complex</Arg> with set of vertices <M>V</M> is the simplicial complex where any subset of <M>V</M> spans a face if and only if its complement in <M>V</M> is a non-face of <Arg>complex</Arg>.
## <Example>
## gap&gt; c:=SC([[1,2],[2,3],[3,4],[4,1]]);;
## gap&gt; dual:=SCAlexanderDual(c);;
## gap&gt; dual.F;
## [ 4, 2 ]
## gap&gt; dual.IsConnected;
## false
## gap&gt; dual.Facets;
## [ [ 1, 3 ], [ 2, 4 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHandleAddition">
## <ManSection>
## <Meth Name="SCHandleAddition" Arg="complex,f1,f2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C>, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a simplicial complex obtained by identifying the vertices of facet <Arg>f1</Arg> with the ones from facet <Arg>f2</Arg> in <Arg>complex</Arg>. A combinatorial handle addition is possible, whenever we have d<M>(v,w) \geq 3</M> for any two vertices <M>v \in </M><Arg>f1</Arg> and <M>w \in </M><Arg>f2</Arg>, where d<M>(\cdot,\cdot)</M> is the length of the shortest path from <M>v</M> to <M>w</M>. This condition is not checked by this algorithm. See <Cite Key="Bagchi08OnWalkupKd"/> for further information.
## <Example>
## gap&gt; c:=SC([[1,2,4],[2,4,5],[2,3,5],[3,5,6],[1,3,6],[1,4,6]]);;
## gap&gt; c:=SCUnion(c,SCUnion(SCCopy(c)+3,SCCopy(c)+6));;
## gap&gt; c:=SCUnion(c,SC([[1,2,3],[10,11,12]]));;
## gap&gt; c.Facets;
## [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 6 ], [ 1, 4, 6 ], [ 2, 3, 5 ], 
##   [ 2, 4, 5 ], [ 3, 5, 6 ], [ 4, 5, 7 ], [ 4, 6, 9 ], [ 4, 7, 9 ], 
##   [ 5, 6, 8 ], [ 5, 7, 8 ], [ 6, 8, 9 ], [ 7, 8, 10 ], [ 7, 9, 12 ], 
##   [ 7, 10, 12 ], [ 8, 9, 11 ], [ 8, 10, 11 ], [ 9, 11, 12 ], [ 10, 11, 12 ] ]
## gap&gt; c.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap&gt; torus:=SCHandleAddition(c,[1,2,3],[10,11,12]);;
## gap&gt; torus.Homology;
## [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
## gap&gt; ism:=SCIsManifold(torus);;
## gap&gt; ism;
## true
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCVertexIdentification">
## <ManSection>
## <Meth Name="SCVertexIdentification" Arg="complex,v1,v2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Identifies vertex <Arg>v1</Arg> with vertex <Arg>v2</Arg> in a simplicial complex <Arg>complex</Arg> and returns the result as a new object. A vertex identification of <Arg>v1</Arg> and <Arg>v2</Arg> is possible whenever d(<Arg>v1</Arg>,<Arg>v2</Arg>) <M>\geq 3</M>. This is not checked by this algorithm. 
## <Example>
## gap&gt; c:=SC([[1,2],[2,3],[3,4]]);;
## gap&gt; circle:=SCVertexIdentification(c,[1],[4]);;
## gap&gt; circle.Facets;
## [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ]
## gap&gt; circle.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLinks">
## <ManSection>
## <Meth Name="SCLinks" Arg="complex,k"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the link of all <Arg>k</Arg>-faces of the polyhedral complex <Arg>complex</Arg> and returns them as a list of simplicial complexes. Internally calls <Ref Meth="SCLink"/> for every <Arg>k</Arg>-face of <Arg>complex</Arg>.
## <Example>
## gap&gt; c:=SCBdSimplex(4);;
## gap&gt; SCLinks(c,0);
## [ [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 1 ]) in S^3_5"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 2 ]) in S^3_5"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 3 ]) in S^3_5"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 4 ]) in S^3_5"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 5 ]) in S^3_5"
##      Dim=2
##     
##     /SimplicialComplex] ]
## gap&gt; SCLinks(c,1);
## [ [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 1, 2 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 1, 3 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 1, 4 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 1, 5 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 2, 3 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 2, 4 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 2, 5 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 3, 4 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 3, 5 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="lk([ 4, 5 ]) in S^3_5"
##      Dim=1
##     
##     /SimplicialComplex] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCStars">
## <ManSection>
## <Meth Name="SCStars" Arg="complex,k"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the star of all <Arg>k</Arg>-faces of the polyhedral complex <Arg>complex</Arg> and returns them as a list of simplicial complexes. Internally calls <Ref Meth="SCStar"/> for every <Arg>k</Arg>-face of <Arg>complex</Arg>.
## <Example>
## gap&gt; SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 18, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap&gt; torus:=SCLib.Load(last[1][1]);; # the minimal 7-vertex torus
## gap&gt; SCStars(torus,0); # 7 2-discs as vertex stars
## [ [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 1 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 2 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 3 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 4 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 5 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 6 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex], [SimplicialComplex
##     
##      Properties known: Dim, FacetsEx, Name, Vertices.
##     
##      Name="star([ 7 ]) in T^2 (VT)"
##      Dim=2
##     
##     /SimplicialComplex] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLink">
## <ManSection>
## <Meth Name="SCLink" Arg="complex,face"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the link of <Arg>face</Arg> (a face given as a list of vertices or a scalar interpreted as vertex) in a polyhedral complex <Arg>complex</Arg>, i. e. all facets containing <Arg>face</Arg>, reduced by <Arg>face</Arg>. if <Arg>complex</Arg> is pure, the resulting complex is of dimension dim(<Arg>complex</Arg>) - dim(<Arg>face</Arg>) <M>-1</M>. If <Arg>face</Arg> is not a face of <Arg>complex</Arg> the empty complex is returned.
## <Example>
## gap&gt; SCLib.SearchByName("RP^2");     
## [ [ 3, "RP^2 (VT)" ], [ 635, "RP^2xS^1" ] ]
## gap&gt; rp2:=SCLib.Load(last[1][1]);;
## gap&gt; SCVertices(rp2);
## [ 1, 2, 3, 4, 5, 6 ]
## gap&gt; SCLink(rp2,[1]);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="lk([ 1 ]) in RP^2 (VT)"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; last.Facets;
## [ [ 2, 3 ], [ 2, 6 ], [ 3, 5 ], [ 4, 5 ], [ 4, 6 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCStar">
## <ManSection>
## <Meth Name="SCStar" Arg="complex,face"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise .</Returns>
## <Description>
## Computes the star of <Arg>face</Arg> (a face given as a list of vertices or a scalar interpreted as vertex) in a polyhedral complex <Arg>complex</Arg>, i. e. the set of facets of <Arg>complex</Arg> that contain <Arg>face</Arg>.
## <Example>
## gap&gt; SCLib.SearchByName("RP^2");     
## [ [ 3, "RP^2 (VT)" ], [ 635, "RP^2xS^1" ] ]
## gap&gt; rp2:=SCLib.Load(last[1][1]);;
## gap&gt; SCVertices(rp2);
## [ 1, 2, 3, 4, 5, 6 ]
## gap&gt; SCStar(rp2,1);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="star([ 1 ]) in RP^2 (VT)"
##  Dim=2
## 
## /SimplicialComplex]
## gap&gt; last.Facets;
## [ [ 1, 2, 3 ], [ 1, 2, 6 ], [ 1, 3, 5 ], [ 1, 4, 5 ], [ 1, 4, 6 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAntiStar">
## <ManSection>
## <Meth Name="SCAntiStar" Arg="complex,face"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise .</Returns>
## <Description>
## Computes the anti star of <Arg>face</Arg> (a face given as a list of vertices or a scalar interpreted as vertex) in <Arg>complex</Arg>, i. e. the complement of <Arg>face</Arg> in <Arg>complex</Arg>.
## <Example>
## gap&gt; SCLib.SearchByName("RP^2");     
## [ [ 3, "RP^2 (VT)" ], [ 635, "RP^2xS^1" ] ]
## gap&gt; rp2:=SCLib.Load(last[1][1]);;
## gap&gt; SCVertices(rp2);
## [ 1, 2, 3, 4, 5, 6 ]
## gap&gt; SCAntiStar(rp2,1);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="ast([ 1 ]) in RP^2 (VT)"
##  Dim=2
## 
## /SimplicialComplex]
## gap&gt; last.Facets;
## [ [ 2, 3, 4 ], [ 2, 4, 5 ], [ 2, 5, 6 ], [ 3, 4, 6 ], [ 3, 5, 6 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFillSphere">
## <ManSection>
## <Func Name="SCFillSphere" Arg="complex[, vertex]"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise .</Returns>
## <Description>
## Fills the given simplicial sphere <Arg>complex</Arg> by forming the suspension of the anti star of <Arg>vertex</Arg> over <Arg>vertex</Arg>. This is a triangulated <M>(d+1)</M>-ball with the boundary <Arg>complex</Arg>, see <Cite Key="Bagchi08LBTNormPseudoMnf" />. If the optional argument <Arg>vertex</Arg> is not supplied, the first vertex of <Arg>complex</Arg> is chosen.<P/>
## Note that it is not checked whether <Arg>complex</Arg> really is a simplicial sphere -- this has to be done by the user!
## <Example>
## gap&gt; SCLib.SearchByName("S^4");
## [ [ 36, "S^4 (VT)" ], [ 37, "S^4 (VT)" ], [ 38, "S^4 (VT)" ], 
##   [ 130, "S^4 (VT)" ], [ 463, "S^4~S^1 (VT)" ], [ 713, "S^4xS^1 (VT)" ], 
##   [ 1472, "S^4xS^1 (VT)" ], [ 1473, "S^4~S^1 (VT)" ], 
##   [ 1474, "S^4~S^1 (VT)" ], [ 1475, "S^4xS^1 (VT)" ], 
##   [ 2477, "S^4~S^1 (VT)" ], [ 2478, "S^4 (VT)" ], [ 3435, "S^4 (VT)" ], 
##   [ 4395, "S^4~S^1 (VT)" ], [ 4396, "S^4~S^1 (VT)" ], 
##   [ 4397, "S^4~S^1 (VT)" ], [ 4398, "S^4~S^1 (VT)" ], 
##   [ 4399, "S^4~S^1 (VT)" ], [ 4402, "S^4~S^1 (VT)" ], 
##   [ 4403, "S^4~S^1 (VT)" ], [ 4404, "S^4~S^1 (VT)" ], [ 7479, "S^4xS^2" ], 
##   [ 7539, "S^4xS^3" ], [ 7573, "S^4xS^4" ] ]
## gap&gt; s:=SCLib.Load(last[1][1]);;
## gap&gt; filled:=SCFillSphere(s);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="FilledSphere(S^4 (VT)) at vertex [ 1 ]"
##  Dim=5
## 
## /SimplicialComplex]
## gap&gt; SCHomology(filled);
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], 
##   [ 0, [  ] ] ]
## gap&gt; SCCollapseGreedy(filled);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="collapsed version of FilledSphere(S^4 (VT)) at vertex [ 1 ]"
##  Dim=0
## 
## /SimplicialComplex]
## gap&gt; bd:=SCBoundary(filled);;
## gap&gt; bd=s;
## true
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSpan">
## <ManSection>
## <Meth Name="SCSpan" Arg="complex,subset"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the reduced face lattice of all faces of a simplicial complex <Arg>complex</Arg> that are spanned by <Arg>subset</Arg>, a subset of the set of vertices of <Arg>complex</Arg>. 
## <Example>
## gap&gt; c:=SCBdCrossPolytope(4);;
## gap&gt; SCVertices(c);
## [ 1, 2, 3, 4, 5, 6, 7, 8 ]
## gap&gt; span:=SCSpan(c,[1,2,3,4]);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="span([ 1, 2, 3, 4 ]) in Bd(\beta^4)"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; span.Facets;
## [ [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ] ]
## </Example>
## <Example>
## gap&gt; c:=SC([[1,2],[1,4,5],[2,3,4]]);;
## gap&gt; span:=SCSpan(c,[2,3,5]);
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="span([ 2, 3, 5 ]) in unnamed complex 119"
##  Dim=1
## 
## /SimplicialComplex]
## gap&gt; SCFacets(span);
## [ [ 2, 3 ], [ 5 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsomorphismEx">
## <ManSection>
## <Meth Name="SCIsomorphismEx" Arg="complex1,complex2"/>
## <Returns> a list of pairs of vertex labels or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns an isomorphism of simplicial complex <Arg>complex1</Arg> to simplicial complex <Arg>complex2</Arg> in the standard labeling if they are combinatorially isomorphic, <K>false</K> otherwise. If the <M>f</M>-vector and the Altshuler-Steinberg determinant of <Arg>complex1</Arg> and <Arg>complex2</Arg> are equal, the internal function <C>SCIntFunc.SCComputeIsomorphismsEx(complex1,complex2,true)</C> is called.
## <Example>
## gap&gt; c1:=SC([[11,12,13],[11,12,14],[11,13,14],[12,13,14]]);;
## gap&gt; c2:=SCBdSimplex(3);;
## gap&gt; SCIsomorphism(c1,c2);
## [ [ 11, 1 ], [ 12, 2 ], [ 13, 3 ], [ 14, 4 ] ]
## gap&gt; SCIsomorphismEx(c1,c2);
## [ [ [ 1, 1 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsomorphism">
## <ManSection>
## <Meth Name="SCIsomorphism" Arg="complex1,complex2"/>
## <Returns> a list of pairs of vertex labels or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns an isomorphism of simplicial complex <Arg>complex1</Arg> to simplicial complex <Arg>complex2</Arg> in the standard labeling if they are combinatorially isomorphic, <K>false</K> otherwise. Internally calls <Ref Meth="SCIsomorphismEx"/>.
## <Example>
## gap&gt; c1:=SC([[11,12,13],[11,12,14],[11,13,14],[12,13,14]]);;
## gap&gt; c2:=SCBdSimplex(3);;
## gap&gt; SCIsomorphism(c1,c2);
## [ [ 11, 1 ], [ 12, 2 ], [ 13, 3 ], [ 14, 4 ] ]
## gap&gt; SCIsomorphismEx(c1,c2);
## [ [ [ 1, 1 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsIsomorphic">
## <ManSection>
## <Meth Name="SCIsIsomorphic" Arg="complex1,complex2"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The function returns <K>true</K>, if the simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> are combinatorially isomorphic, <K>false</K> if not.
## <Example>
## gap&gt; c1:=SC([[11,12,13],[11,12,14],[11,13,14],[12,13,14]]);;
## gap&gt; c2:=SCBdSimplex(3);;
## gap&gt; SCIsIsomorphic(c1,c2);
## true
## gap&gt; c3:=SCBdCrossPolytope(3);;
## gap&gt; SCIsIsomorphic(c1,c3);
## false
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCone">
## <ManSection>
## <Func Name="SCCone" Arg="complex, apex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If the second argument is passed every facet of the simplicial complex <Arg>complex</Arg> is united with <Arg>apex</Arg>. If not, an arbitrary vertex label <M>v</M> is used (which is not a vertex of <Arg>complex</Arg>). In the first case the vertex labeling remains unchanged. In the second case the function returns the new complex in the standard vertex labeling from <M>1</M> to <M>n+1</M> and the apex of the cone is <M>n+1</M>.<P/>
## If called with a facet list instead of a <C>SCSimplicialComplex</C> object and <Arg>apex</Arg> is not specified, internally falls back to the homology package <Cite Key="Dumas04Homology" />, if available. 
## <Example>
## gap&gt; SCLib.SearchByName("RP^3");
## [ [ 45, "RP^3" ], [ 113, "RP^3=L(2,1) (VT)" ], [ 589, "(S^2~S^1)#RP^3" ], 
##   [ 590, "(S^2xS^1)#RP^3" ], [ 632, "(S^2~S^1)#2#RP^3" ], 
##   [ 633, "(S^2xS^1)#2#RP^3" ], [ 2414, "RP^3#RP^3" ], 
##   [ 2426, "RP^3=L(2,1) (VT)" ], [ 2488, "(S^2~S^1)#3#RP^3" ], 
##   [ 2489, "(S^2xS^1)#3#RP^3" ], [ 2502, "RP^3=L(2,1) (VT)" ], 
##   [ 7473, "(S^2~S^1)#4#RP^3" ], [ 7474, "(S^2xS^1)#4#RP^3" ], 
##   [ 7504, "(S^2~S^1)#5#RP^3" ], [ 7505, "(S^2xS^1)#5#RP^3" ] ]
## gap&gt; rp3:=SCLib.Load(last[1][1]);;
## gap&gt; rp3.F;
## [ 11, 51, 80, 40 ]
## gap&gt; cone:=SCCone(rp3);;
## gap&gt; cone.F;
## [ 12, 62, 131, 120, 40 ]
## </Example>
## <Example>
## gap&gt; s:=SCBdSimplex(4)+12;;
## gap&gt; s.Facets;             
## [ [ 13, 14, 15, 16 ], [ 13, 14, 15, 17 ], [ 13, 14, 16, 17 ], 
##   [ 13, 15, 16, 17 ], [ 14, 15, 16, 17 ] ]
## gap&gt; cc:=SCCone(s,13);;    
## gap&gt; cc:=SCCone(s,12);;
## gap&gt; cc.Facets;
## [ [ 12, 13, 14, 15, 16 ], [ 12, 13, 14, 15, 17 ], [ 12, 13, 14, 16, 17 ], 
##   [ 12, 13, 15, 16, 17 ], [ 12, 14, 15, 16, 17 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCClose">
## <ManSection>
## <Func Name="SCClose" Arg="complex [, apex]"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Closes a simplicial complex <Arg>complex</Arg> by building a cone over its boundary. If <Arg>apex</Arg> is specified it is assigned to the apex of the cone and the original vertex labeling of <Arg>complex</Arg> is preserved, otherwise an arbitrary vertex label is chosen and <Arg>complex</Arg> is returned in the standard labeling. 
## <Example>
## gap&gt; s:=SCSimplex(5);;                                       
## gap&gt; b:=SCSimplex(5);;
## gap&gt; s:=SCClose(b,13);;
## gap&gt; SCIsIsomorphic(s,SCBdSimplex(6));                       
## true
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCShellingExt">
## <ManSection>
## <Meth Name="SCShellingExt" Arg="complex, all,checkvector"/>
## <Returns> a list of facet lists (if <Arg>checkvector = []</Arg>) or <K>true</K> or <K>false</K> (if <Arg>checkvector</Arg> is not empty), <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure of dimension <M>d</M>, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary (cf. <Ref Meth="SCBoundary"/>).<P/>
## An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>.<P/>
## If <Arg>all</Arg> is set to <K>true</K> all possible shellings of <Arg>complex</Arg> are computed. If <Arg>all</Arg> is set to <K>false</K>, at most one shelling is computed.<P/>
## Every shelling is represented as a permuted version of the facet list of <Arg>complex</Arg>. The list <Arg>checkvector</Arg> encodes a shelling in a shorter form. It only contains the indices of the facets. If an order of indices is assigned to <Arg>checkvector</Arg> the function tests whether it is a valid shelling or not.<P/>
## See <Cite Key="Ziegler95LectPolytopes"/>, <Cite Key="Pachner87KonstrMethKombHomeo" /> to learn more about shellings.
## <Example>
## gap&gt; c:=SCBdSimplex(4);;
## gap&gt; c:=SCDifference(c,SC([c.Facets[1]]));; # bounded version
## gap&gt; all:=SCShellingExt(c,true,[]);;
## gap&gt; Size(all);                                  
## 24
## gap&gt; all[1];
## [ [ 1, 2, 3, 5 ], [ 1, 2, 4, 5 ], [ 1, 3, 4, 5 ], [ 2, 3, 4, 5 ] ]
## gap&gt; all:=SCShellingExt(c,false,[]);
## [ [ [ 1, 2, 3, 5 ], [ 1, 2, 4, 5 ], [ 1, 3, 4, 5 ], [ 2, 3, 4, 5 ] ] ]
## gap&gt; all:=SCShellingExt(c,true,[1..4]);
## true
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCShelling">
## <ManSection>
## <Meth Name="SCShelling" Arg="complex"/>
## <Returns> a facet list or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary (cf. <Ref Meth="SCBoundary"/>).<P/>
## An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>.<P/>
## The function checks whether <Arg>complex</Arg> is shellable or not. In the first case a permuted version of the facet list of <Arg>complex</Arg> is returned encoding a shelling of <Arg>complex</Arg>, otherwise <K>false</K> is returned.<P/>
## Internally calls <Ref Meth="SCShellingExt"/><C>(complex,false,[]);</C>. To learn more about shellings see <Cite Key="Ziegler95LectPolytopes"/>, <Cite Key="Pachner87KonstrMethKombHomeo"/>.
## <Example>
## gap&gt; c:=SC([[1,2,3],[1,2,4],[1,3,4]]);;
## gap&gt; SCShelling(c);
## [ [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCShellings">
## <ManSection>
## <Meth Name="SCShellings" Arg="complex"/>
## <Returns> a list of facet lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary  (cf. <Ref Meth="SCBoundary"/>).<P/>
## An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>.<P/>
## The function checks whether <Arg>complex</Arg> is shellable or not. In the first case a list of permuted facet lists of <Arg>complex</Arg> is returned containing all possible shellings of <Arg>complex</Arg>, otherwise <K>false</K> is returned.<P/>
## Internally calls <Ref Meth="SCShellingExt"/><C>(complex,true,[]);</C>. To learn more about shellings see <Cite Key="Ziegler95LectPolytopes"/>, <Cite Key="Pachner87KonstrMethKombHomeo"/>.
## <Example>
## gap&gt; c:=SC([[1,2,3],[1,2,4],[1,3,4]]);;
## gap&gt; SCShellings(c);
## [ [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ] ], 
##   [ [ 1, 2, 3 ], [ 1, 3, 4 ], [ 1, 2, 4 ] ], 
##   [ [ 1, 2, 4 ], [ 1, 2, 3 ], [ 1, 3, 4 ] ], 
##   [ [ 1, 3, 4 ], [ 1, 2, 3 ], [ 1, 2, 4 ] ], 
##   [ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 1, 2, 3 ] ], 
##   [ [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
