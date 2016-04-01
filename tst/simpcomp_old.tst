gap> 
gap> START_TEST("simpcomp package test");
gap> 
gap> SCInfoLevel(0);
true
gap> 
gap> complexes:=[
> SCEmpty(),
> SCBdSimplex(4),
> SCBdCrossPolytope(4),
> SC([[1,3,5],[2,3,5],[1,2,4],[1,3,4],[2,3,4]]), #with boundary
> SC([[1,2,3,5], [1,2,3,8], [1,2,4,5], [1,2,4,9], [1,2,7,8], [1,2,7,9], [1,3,4,5],
> [1,3,4,9], [1,3,8,9], [1,6,7,8], [1,6,7,9], [1,6,8,9], [2,3,4,6], [2,3,4,9],
> [2,3,5,6], [2,3,8,9], [2,4,5,6], [2,7,8,9], [3,4,5,7], [3,4,6,7], [3,5,6,7],
> [4,5,6,8], [4,5,7,8], [4,6,7,8], [5,6,7,9], [5,6,8,9], [5,7,8,9]]), #S2~S1
> SC([[1,2,3,8,12], [1,2,3,8,16], [1,2,3,12,16], [1,2,4,7,11], [1,2,4,7,15],
> [1,2,4,11,15], [1,2,5,7,13], [1,2,5,7,15], [1,2,5,8,10], [1,2,5,8,14],
> [1,2,5,10,16], [1,2,5,13,16], [1,2,5,14,15], [1,2,6,7,9], [1,2,6,7,13],
> [1,2,6,8,14], [1,2,6,8,16], [1,2,6,9,15], [1,2,6,13,16], [1,2,6,14,15],
> [1,2,7,9,11], [1,2,8,10,12], [1,2,9,11,15], [1,2,10,12,16], [1,3,4,6,10],
> [1,3,4,6,14], [1,3,4,10,14], [1,3,5,6,9], [1,3,5,6,11], [1,3,5,9,12],
> [1,3,5,11,12], [1,3,6,9,15], [1,3,6,10,11], [1,3,6,14,15], [1,3,7,8,9],
> [1,3,7,8,11], [1,3,7,9,10], [1,3,7,10,11], [1,3,8,9,12], [1,3,8,11,13],
> [1,3,8,13,16], [1,3,9,10,15], [1,3,10,14,15], [1,3,11,12,13], [1,3,12,13,16],
> [1,4,5,6,10], [1,4,5,6,14], [1,4,5,10,16], [1,4,5,14,16], [1,4,7,8,11],
> [1,4,7,8,15], [1,4,8,11,13], [1,4,8,13,15], [1,4,9,11,13], [1,4,9,11,16],
> [1,4,9,13,14], [1,4,9,14,16], [1,4,10,12,13], [1,4,10,12,16], [1,4,10,13,14],
> [1,4,11,15,16], [1,4,12,13,15], [1,4,12,15,16], [1,5,6,9,12], [1,5,6,10,11],
> [1,5,6,12,14], [1,5,7,13,16], [1,5,7,15,16], [1,5,8,10,12], [1,5,8,12,14],
> [1,5,10,11,12], [1,5,14,15,16], [1,6,7,8,9], [1,6,7,8,13], [1,6,8,9,12],
> [1,6,8,12,14], [1,6,8,13,16], [1,7,8,13,15], [1,7,9,10,14], [1,7,9,11,14],
> [1,7,10,11,14], [1,7,12,13,15], [1,7,12,13,16], [1,7,12,15,16], [1,9,10,14,15],
> [1,9,11,13,14], [1,9,11,15,16], [1,9,14,15,16], [1,10,11,12,13],
> [1,10,11,13,14], [2,3,4,5,9], [2,3,4,5,13], [2,3,4,9,13], [2,3,5,6,9],
> [2,3,5,6,13], [2,3,6,9,15], [2,3,6,13,15], [2,3,7,8,12], [2,3,7,8,16],
> [2,3,7,12,14], [2,3,7,14,16], [2,3,9,11,14], [2,3,9,11,15], [2,3,9,13,14],
> [2,3,10,12,14], [2,3,10,12,15], [2,3,10,13,14], [2,3,10,13,15], [2,3,11,14,16],
> [2,3,11,15,16], [2,3,12,15,16], [2,4,5,6,10], [2,4,5,6,12], [2,4,5,9,12],
> [2,4,5,10,16], [2,4,5,13,16], [2,4,6,10,11], [2,4,6,11,12], [2,4,7,8,10],
> [2,4,7,8,12], [2,4,7,10,11], [2,4,7,12,14], [2,4,7,14,15], [2,4,8,9,10],
> [2,4,8,9,12], [2,4,9,10,16], [2,4,9,13,16], [2,4,11,12,14], [2,4,11,14,15],
> [2,5,6,9,12], [2,5,6,10,11], [2,5,6,11,13], [2,5,7,8,10], [2,5,7,8,14],
> [2,5,7,10,11], [2,5,7,11,13], [2,5,7,14,15], [2,6,7,9,11], [2,6,7,11,13],
> [2,6,8,14,15], [2,6,8,15,16], [2,6,9,11,12], [2,6,13,15,16], [2,7,8,14,16],
> [2,8,9,10,13], [2,8,9,12,13], [2,8,10,12,13], [2,8,11,14,15], [2,8,11,14,16],
> [2,8,11,15,16], [2,9,10,13,16], [2,9,11,12,14], [2,9,12,13,14], [2,10,12,13,14],
> [2,10,12,15,16], [2,10,13,15,16], [3,4,5,7,13], [3,4,5,7,15], [3,4,5,8,11],
> [3,4,5,8,15], [3,4,5,9,11], [3,4,6,7,12], [3,4,6,7,16], [3,4,6,8,14],
> [3,4,6,8,16], [3,4,6,10,12], [3,4,7,12,14], [3,4,7,13,16], [3,4,7,14,15],
> [3,4,8,11,13], [3,4,8,13,16], [3,4,8,14,15], [3,4,9,11,13], [3,4,10,12,14],
> [3,5,6,8,11], [3,5,6,8,15], [3,5,6,13,15], [3,5,7,13,14], [3,5,7,14,15],
> [3,5,9,11,16], [3,5,9,12,16], [3,5,10,13,14], [3,5,10,13,15], [3,5,10,14,15],
> [3,5,11,12,16], [3,6,7,10,12], [3,6,7,10,16], [3,6,8,10,11], [3,6,8,10,16],
> [3,6,8,14,15], [3,7,8,9,12], [3,7,8,10,11], [3,7,8,10,16], [3,7,9,10,12],
> [3,7,13,14,16], [3,9,10,12,15], [3,9,11,13,14], [3,9,11,15,16], [3,9,12,15,16],
> [3,11,12,13,16], [3,11,13,14,16], [4,5,6,7,12], [4,5,6,7,16], [4,5,6,14,16],
> [4,5,7,9,12], [4,5,7,9,15], [4,5,7,13,16], [4,5,8,9,11], [4,5,8,9,15],
> [4,6,8,13,14], [4,6,8,13,16], [4,6,9,13,14], [4,6,9,13,16], [4,6,9,14,16],
> [4,6,10,11,15], [4,6,10,12,15], [4,6,11,12,15], [4,7,8,9,12], [4,7,8,9,15],
> [4,7,8,10,11], [4,8,9,10,11], [4,8,13,14,15], [4,9,10,11,16], [4,10,11,15,16],
> [4,10,12,13,14], [4,10,12,15,16], [4,11,12,14,15], [4,12,13,14,15],
> [5,6,7,12,16], [5,6,8,11,15], [5,6,11,13,15], [5,6,12,14,16], [5,7,8,10,14],
> [5,7,9,12,16], [5,7,9,15,16], [5,7,10,11,14], [5,7,11,13,14], [5,8,9,10,13],
> [5,8,9,10,14], [5,8,9,11,16], [5,8,9,13,15], [5,8,9,14,16], [5,8,10,12,13],
> [5,8,11,12,15], [5,8,11,12,16], [5,8,12,13,15], [5,8,12,14,16], [5,9,10,13,15],
> [5,9,10,14,15], [5,9,14,15,16], [5,10,11,12,13], [5,10,11,13,14],
> [5,11,12,13,15], [6,7,8,9,13], [6,7,9,10,13], [6,7,9,10,14], [6,7,9,11,14],
> [6,7,10,12,15], [6,7,10,13,15], [6,7,10,14,16], [6,7,11,12,15], [6,7,11,12,16],
> [6,7,11,13,15], [6,7,11,14,16], [6,8,9,12,13], [6,8,10,11,15], [6,8,10,15,16],
> [6,8,12,13,14], [6,9,10,13,16], [6,9,10,14,16], [6,9,11,12,14], [6,9,12,13,14],
> [6,10,13,15,16], [6,11,12,14,16], [7,8,9,13,15], [7,8,10,14,16], [7,9,10,12,15],
> [7,9,10,13,15], [7,9,12,15,16], [7,11,12,13,15], [7,11,12,13,16],
> [7,11,13,14,16], [8,9,10,11,16], [8,9,10,14,16], [8,10,11,15,16],
> [8,11,12,14,15], [8,11,12,14,16], [8,12,13,14,15]]), #K3
> SC([[1,2],[2,3],[4,5],[5,6]]), #unconnected
> SC([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],
> [2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]) #rp2
> ];;
gap> 
gap> 
gap> #general tests
gap> c:=complexes[1];;
gap> SCDim(c);
-1
gap> SCName(c);
"empty complex"
gap> c.Name;
"empty complex"
gap> c.IsEmpty;
true
gap> c.F;
[ 0 ]
gap> Size(c.Facets);
0
gap> c.Homology;
[  ]
gap> c.Cohomology;
[  ]
gap> c.HasBoundary;
false
gap> c.Orientation;
[  ]
gap> Size(c.ConnectedComponents);
1
gap> Size(c.StronglyConnectedComponents);
1
gap> c.MinimalNonFaces;
[  ]
gap> 
gap> c:=complexes[2];;
gap> SCDim(c);
3
gap> c.IsEmpty;
false
gap> c.F;
[ 5, 10, 10, 5 ]
gap> Size(c.Facets);
5
gap> c.Homology;
[ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> c.Cohomology;
[ [ 1, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> c.HasBoundary;
false
gap> c.Orientation;
[ 1, -1, 1, -1, 1 ]
gap> c.AutomorphismGroup;
Sym( [ 1 .. 5 ] )
gap> c.GeneratorsEx;
[ [ [ 1 .. 4 ], [ 5 ] ] ]
gap> Size(c.ConnectedComponents);
1
gap> Size(c.StronglyConnectedComponents);
1
gap> c.MinimalNonFaces;
[ [  ], [  ], [  ] ]
gap> 
gap> c:=complexes[3];;
gap> SCAlexanderDual(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Alexander dual of Bd(\beta^4)"
 Dim=5

/SimplicialComplex]
gap> SCAltshulerSteinberg(c);
0
gap> SCAntiStar(c,1);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="ast([ 1 ]) in Bd(\beta^4)"
 Dim=3

/SimplicialComplex]
gap> SCAutomorphismGroup(c);
TransitiveGroup(8,44) = [2^4]S(4)
gap> SCAutomorphismGroupInternal(c);
TransitiveGroup(8,44) = [2^4]S(4)
gap> SCAutomorphismGroupSize(c);
384
gap> SCAutomorphismGroupStructure(c);
"TransitiveGroup(8,44) = [2^4]S(4)"
gap> SCAutomorphismGroupTransitivity(c);
1
gap> SCBoundary(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Bd(Bd(\beta^4))"
 Dim=-1

/SimplicialComplex]
gap> SCCentrallySymmetricElement(c);
(1,2)(3,4)(5,6)(7,8)
gap> SCCohomology(c);
[ [ 1, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> SCCohomologyBasis(c,0);
[ [ 1, 
      [ [ 1, 8 ], [ 1, 7 ], [ 1, 6 ], [ 1, 5 ], [ 1, 4 ], [ 1, 3 ], [ 1, 2 ], 
          [ 1, 1 ] ] ] ]
gap> SCCohomologyBasisAsSimplices(c,0);
[ [ 1, 
      [ [ 1, [ 8 ] ], [ 1, [ 7 ] ], [ 1, [ 6 ] ], [ 1, [ 5 ] ], [ 1, [ 4 ] ], 
          [ 1, [ 3 ] ], [ 1, [ 2 ] ], [ 1, [ 1 ] ] ] ] ]
gap> SCCollapseGreedy(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="collapsed version of Bd(\beta^4)"
 Dim=3

/SimplicialComplex]
gap> SCCone(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="cone over Bd(\beta^4)"
 Dim=4

/SimplicialComplex]
gap> SCConnectedComponents(c);
[ [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="Connected component #1 of Bd(\beta^4)"
     Dim=3
    
    /SimplicialComplex] ]
gap> SCConnectedProduct(c,2);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Bd(\beta^4)#+-Bd(\beta^4)"
 Dim=3

/SimplicialComplex]
gap> SCConnectedSum(c,c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Bd(\beta^4)#+-Bd(\beta^4)"
 Dim=3

/SimplicialComplex]
gap> SCConnectedSumMinus(c,c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Bd(\beta^4)#+-Bd(\beta^4)"
 Dim=3

/SimplicialComplex]
gap> IsIdenticalObj(c,SCCopy(c));
false
gap> SCDifference(c,c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Bd(\beta^4) \ Bd(\beta^4)"
 Dim=-1

/SimplicialComplex]
gap> SCDim(c);
3
gap> SCFVector(SCDualGraph(c));
[ 16, 32 ]
gap> SCEquivalent(c,c);
true
gap> SCEulerCharacteristic(c);
0
gap> SCExamineComplexBistellar(c)<>fail;
true
gap> SCFVector(c);
[ 8, 24, 32, 16 ]
gap> SCFaceLattice(c);
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ] ], 
  [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 1, 7 ], [ 1, 8 ], [ 2, 3 ], 
      [ 2, 4 ], [ 2, 5 ], [ 2, 6 ], [ 2, 7 ], [ 2, 8 ], [ 3, 5 ], [ 3, 6 ], 
      [ 3, 7 ], [ 3, 8 ], [ 4, 5 ], [ 4, 6 ], [ 4, 7 ], [ 4, 8 ], [ 5, 7 ], 
      [ 5, 8 ], [ 6, 7 ], [ 6, 8 ] ], 
  [ [ 1, 3, 5 ], [ 1, 3, 6 ], [ 1, 3, 7 ], [ 1, 3, 8 ], [ 1, 4, 5 ], 
      [ 1, 4, 6 ], [ 1, 4, 7 ], [ 1, 4, 8 ], [ 1, 5, 7 ], [ 1, 5, 8 ], 
      [ 1, 6, 7 ], [ 1, 6, 8 ], [ 2, 3, 5 ], [ 2, 3, 6 ], [ 2, 3, 7 ], 
      [ 2, 3, 8 ], [ 2, 4, 5 ], [ 2, 4, 6 ], [ 2, 4, 7 ], [ 2, 4, 8 ], 
      [ 2, 5, 7 ], [ 2, 5, 8 ], [ 2, 6, 7 ], [ 2, 6, 8 ], [ 3, 5, 7 ], 
      [ 3, 5, 8 ], [ 3, 6, 7 ], [ 3, 6, 8 ], [ 4, 5, 7 ], [ 4, 5, 8 ], 
      [ 4, 6, 7 ], [ 4, 6, 8 ] ], 
  [ [ 1, 3, 5, 7 ], [ 1, 3, 5, 8 ], [ 1, 3, 6, 7 ], [ 1, 3, 6, 8 ], 
      [ 1, 4, 5, 7 ], [ 1, 4, 5, 8 ], [ 1, 4, 6, 7 ], [ 1, 4, 6, 8 ], 
      [ 2, 3, 5, 7 ], [ 2, 3, 5, 8 ], [ 2, 3, 6, 7 ], [ 2, 3, 6, 8 ], 
      [ 2, 4, 5, 7 ], [ 2, 4, 5, 8 ], [ 2, 4, 6, 7 ], [ 2, 4, 6, 8 ] ] ]
gap> SCFaces(c,1);
[ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 1, 7 ], [ 1, 8 ], [ 2, 3 ], 
  [ 2, 4 ], [ 2, 5 ], [ 2, 6 ], [ 2, 7 ], [ 2, 8 ], [ 3, 5 ], [ 3, 6 ], 
  [ 3, 7 ], [ 3, 8 ], [ 4, 5 ], [ 4, 6 ], [ 4, 7 ], [ 4, 8 ], [ 5, 7 ], 
  [ 5, 8 ], [ 6, 7 ], [ 6, 8 ] ]
gap> SCFacets(c);
[ [ 1, 3, 5, 7 ], [ 1, 3, 5, 8 ], [ 1, 3, 6, 7 ], [ 1, 3, 6, 8 ], 
  [ 1, 4, 5, 7 ], [ 1, 4, 5, 8 ], [ 1, 4, 6, 7 ], [ 1, 4, 6, 8 ], 
  [ 2, 3, 5, 7 ], [ 2, 3, 5, 8 ], [ 2, 3, 6, 7 ], [ 2, 3, 6, 8 ], 
  [ 2, 4, 5, 7 ], [ 2, 4, 5, 8 ], [ 2, 4, 6, 7 ], [ 2, 4, 6, 8 ] ]
gap> SCFillSphere(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="FilledSphere(Bd(\beta^4)) at vertex [ 1 ]"
 Dim=4

/SimplicialComplex]
gap> SCFpBettiNumbers(c,2);
[ 1, 0, 0, 1 ]
gap> Size(SCFundamentalGroup(c));
1
gap> SCGVector(c);
[ 3, 2 ]
gap> SCGenerators(c);
[ [ [ 1, 3, 5, 7 ], 16 ] ]
gap> SCHVector(c);
[ 4, 6, 4, 1 ]
gap> SCHasBoundary(c);
false
gap> SCHasInterior(c);
true
gap> SCHomology(c);
[ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> SCHomologyBasis(c,0);
[ [ 1, [ [ 1, 1 ] ] ] ]
gap> SCHomologyBasisAsSimplices(c,0);
[ [ 1, [ [ 1, [ 1 ] ] ] ] ]
gap> SCHomologyInternal(c);
[ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> SCInterior(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, IsEmpty, Name, Vertices.

 Name="Int(Bd(\beta^4))"
 Dim=2

/SimplicialComplex]
gap> SCIntersection(c,c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Bd(\beta^4) cap Bd(\beta^4)"
 Dim=3

/SimplicialComplex]
gap> SCIsCentrallySymmetric(c);
true
gap> SCIsConnected(c);
true
gap> SCIsEmpty(c);
false
gap> SCIsEulerianManifold(c);
true
gap> SCIsFlag(c);
true
gap> SCIsHomologySphere(c);
true
gap> SCIsInKd(c,1);
false
gap> SCIsIsomorphic(c,c);
true
gap> SCIsKNeighborly(c,2);
false
gap> SCIsKStackedSphere(c,1);
[ false, [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="empty complex"
     Dim=-1
    
    /SimplicialComplex] ]
gap> SCIsManifold(c);
true
gap> SCIsMovableComplex(c);
true
gap> SCIsOrientable(c);
true
gap> SCIsPolyhedralComplex(c);
true
gap> SCIsPropertyObject(c);
true
gap> SCIsPseudoManifold(c);
true
gap> SCIsPure(c);
true
gap> SCIsSimplicialComplex(c);
true
gap> SCIsStronglyConnected(c);
true
gap> SCIsTight(c);
false
gap> SCLabelMax(c);
8
gap> SCLabelMin(c);
1
gap> SCLabels(c);
[ 1, 2, 3, 4, 5, 6, 7, 8 ]
gap> SCLink(c,1);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="lk([ 1 ]) in Bd(\beta^4)"
 Dim=2

/SimplicialComplex]
gap> SCLinks(c,0);
[ [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 1 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 2 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 3 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 4 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 5 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 6 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 7 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="lk([ 8 ]) in Bd(\beta^4)"
     Dim=2
    
    /SimplicialComplex] ]
gap> SCMinimalNonFaces(c);
[ [  ], [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ], [ 7, 8 ] ], [  ] ]
gap> SCMorseIsPerfect(c,SCVertices(c));
false
gap> SCMorseMultiplicityVector(c,SCVertices(c));
[ [ 1, 0, 0, 0 ], [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 1, 0, 0 ], 
  [ 0, 0, 1, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ], [ 0, 0, 0, 1 ] ]
gap> SCMorseNumberOfCriticalPoints(c,SCVertices(c));
[ 8, [ 2, 2, 2, 2 ] ]
gap> SCNeighborliness(c);
1
gap> SCNumFaces(c,1);
24
gap> SCOrientation(c);
[ 1, -1, -1, 1, -1, 1, 1, -1, -1, 1, 1, -1, 1, -1, -1, 1 ]
gap> SCRMoves(c,1);
[ [ [ 1, 3, 5 ], [ 7, 8 ] ], [ [ 1, 3, 6 ], [ 7, 8 ] ], 
  [ [ 1, 3, 7 ], [ 5, 6 ] ], [ [ 1, 3, 8 ], [ 5, 6 ] ], 
  [ [ 1, 4, 5 ], [ 7, 8 ] ], [ [ 1, 4, 6 ], [ 7, 8 ] ], 
  [ [ 1, 4, 7 ], [ 5, 6 ] ], [ [ 1, 4, 8 ], [ 5, 6 ] ], 
  [ [ 1, 5, 7 ], [ 3, 4 ] ], [ [ 1, 5, 8 ], [ 3, 4 ] ], 
  [ [ 1, 6, 7 ], [ 3, 4 ] ], [ [ 1, 6, 8 ], [ 3, 4 ] ], 
  [ [ 2, 3, 5 ], [ 7, 8 ] ], [ [ 2, 3, 6 ], [ 7, 8 ] ], 
  [ [ 2, 3, 7 ], [ 5, 6 ] ], [ [ 2, 3, 8 ], [ 5, 6 ] ], 
  [ [ 2, 4, 5 ], [ 7, 8 ] ], [ [ 2, 4, 6 ], [ 7, 8 ] ], 
  [ [ 2, 4, 7 ], [ 5, 6 ] ], [ [ 2, 4, 8 ], [ 5, 6 ] ], 
  [ [ 2, 5, 7 ], [ 3, 4 ] ], [ [ 2, 5, 8 ], [ 3, 4 ] ], 
  [ [ 2, 6, 7 ], [ 3, 4 ] ], [ [ 2, 6, 8 ], [ 3, 4 ] ], 
  [ [ 3, 5, 7 ], [ 1, 2 ] ], [ [ 3, 5, 8 ], [ 1, 2 ] ], 
  [ [ 3, 6, 7 ], [ 1, 2 ] ], [ [ 3, 6, 8 ], [ 1, 2 ] ], 
  [ [ 4, 5, 7 ], [ 1, 2 ] ], [ [ 4, 5, 8 ], [ 1, 2 ] ], 
  [ [ 4, 6, 7 ], [ 1, 2 ] ], [ [ 4, 6, 8 ], [ 1, 2 ] ] ]
gap> SCRelabel(c,[11..18]);
true
gap> SCRelabelTransposition(c,[11,12]);
true
gap> SCRelabelStandard(c);
true
gap> SCRename(c,"test");
true
gap> SCName(c);
"test"
gap> SCSkel(c,0);
[ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ] ]
gap> SCSpan(c,[1..4]);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="span([ 1, 2, 3, 4 ]) in test"
 Dim=1

/SimplicialComplex]
gap> SCSpanningTree(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="spanning tree of Bd(\beta^4)"
 Dim=1

/SimplicialComplex]
gap> SCStar(c,1);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="star([ 1 ]) in test"
 Dim=3

/SimplicialComplex]
gap> SCStars(c,0);
[ [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 1 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 2 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 3 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 4 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 5 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 6 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 7 ]) in test"
     Dim=3
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="star([ 8 ]) in test"
     Dim=3
    
    /SimplicialComplex] ]
gap> SCStronglyConnectedComponents(c);
[ [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="Strongly connected component #1 of test"
     Dim=3
    
    /SimplicialComplex] ]
gap> SCSuspension(c);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="susp of test"
 Dim=4

/SimplicialComplex]
gap> SCTopologicalType(c);
"S^3"
gap> SCVertexIdentification(c,[1],[2]);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="test vertex identified ([ 1 ]=[ 2 ])"
 Dim=3

/SimplicialComplex]
gap> SCVertices(c);
[ 1, 2, 3, 4, 5, 6, 7, 8 ]
gap> SCVerticesEx(c);
[ 1 .. 8 ]
gap> SCIsSimplicialComplex(SCWedge(c,c));
true
gap> 
gap> c:=complexes[4];;
gap> SCDim(c);
2
gap> c.IsEmpty;
false
gap> c.F;
[ 5, 9, 5 ]
gap> Size(c.Facets);
5
gap> c.Homology;
[ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ] ]
gap> c.Cohomology;
[ [ 1, [  ] ], [ 0, [  ] ], [ 0, [  ] ] ]
gap> c.HasBoundary;
true
gap> Print("test\n");
test
gap> c.Orientation;
[ 1, -1, 1, 1, -1 ]
gap> Print("test\n");
test
gap> Size(c.ConnectedComponents);
1
gap> Size(c.StronglyConnectedComponents);
1
gap> c.MinimalNonFaces;
[ [  ], [ [ 4, 5 ] ] ]
gap> 
gap> c:=complexes[5];;
gap> SCDim(c);
3
gap> c.IsEmpty;
false
gap> c.F;
[ 9, 36, 54, 27 ]
gap> Size(c.Facets);
27
gap> c.Homology;
[ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
gap> c.Cohomology;
[ [ 1, [  ] ], [ 1, [  ] ], [ 0, [  ] ], [ 0, [ 2 ] ] ]
gap> c.HasBoundary;
false
gap> c.Orientation;
[  ]
gap> c.AutomorphismGroup;
TransitiveGroup(9,3) = D(9)=9:2
gap> c.GeneratorsEx;
[ [ [ 1, 2, 3, 5 ], 18 ], [ [ 1, 2, 4, 5 ], 9 ] ]
gap> Size(c.ConnectedComponents);
1
gap> Size(c.StronglyConnectedComponents);
1
gap> c.MinimalNonFaces;
[ [  ], [  ], 
  [ [ 1, 2, 6 ], [ 1, 3, 6 ], [ 1, 3, 7 ], [ 1, 4, 6 ], [ 1, 4, 7 ], 
      [ 1, 4, 8 ], [ 1, 5, 6 ], [ 1, 5, 7 ], [ 1, 5, 8 ], [ 1, 5, 9 ], 
      [ 2, 3, 7 ], [ 2, 4, 7 ], [ 2, 4, 8 ], [ 2, 5, 7 ], [ 2, 5, 8 ], 
      [ 2, 5, 9 ], [ 2, 6, 7 ], [ 2, 6, 8 ], [ 2, 6, 9 ], [ 3, 4, 8 ], 
      [ 3, 5, 8 ], [ 3, 5, 9 ], [ 3, 6, 8 ], [ 3, 6, 9 ], [ 3, 7, 8 ], 
      [ 3, 7, 9 ], [ 4, 5, 9 ], [ 4, 6, 9 ], [ 4, 7, 9 ], [ 4, 8, 9 ] ] ]
gap> 
gap> c:=complexes[6];;
gap> SCDim(c);
4
gap> SCRename(c,"K3 surface");
true
gap> SCName(c)=c.Name;
true
gap> c.IsEmpty;
false
gap> c.F;
[ 16, 120, 560, 720, 288 ]
gap> Size(c.Facets);
288
gap> c.Homology;
[ [ 0, [  ] ], [ 0, [  ] ], [ 22, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> c.Cohomology;
[ [ 1, [  ] ], [ 0, [  ] ], [ 22, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
gap> c.HasBoundary;
false
gap> c.Orientation;
[ 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 
  1, 1, -1, 1, -1, 1, 1, -1, 1, -1, -1, -1, 1, 1, -1, 1, 1, -1, 1, 1, -1, -1, 
  1, -1, 1, -1, 1, -1, 1, -1, -1, -1, 1, -1, 1, 1, -1, 1, -1, -1, 1, 1, 1, 1, 
  1, 1, -1, -1, -1, -1, 1, -1, 1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, 1, 1, 1, 
  -1, -1, -1, -1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, 
  1, -1, 1, -1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, -1, -1, -1, 
  -1, -1, -1, 1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1, -1, 1, 
  -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 
  1, -1, 1, -1, 1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, -1, -1, -1, -1, 
  1, -1, 1, -1, -1, -1, 1, -1, -1, 1, -1, 1, 1, -1, -1, -1, 1, -1, 1, 1, -1, 
  1, -1, 1, -1, 1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, 
  -1, -1, 1, -1, 1, 1, -1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -1, 1, 
  1, -1, 1, -1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, -1, -1, 1, 1, -1, 
  -1, -1, 1, 1, -1, 1, 1, -1, 1, -1 ]
gap> c.AutomorphismGroup;
PrimitiveGroup(16,3) = AGL(1, 16)
gap> c.GeneratorsEx;
[ [ [ 1, 2, 3, 8, 12 ], 240 ], [ [ 1, 2, 5, 8, 14 ], 48 ] ]
gap> Size(c.ConnectedComponents);
1
gap> Size(c.StronglyConnectedComponents);
1
gap> Size(c.MinimalNonFaces[4]);
1100
gap> c.IntersectionForm;
[ [ -2, 1, -1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1, -1, -1, -1, 1, -1, 2, 1, 
      0, 1 ], 
  [ 1, -2, 1, 0, 0, 1, 1, 1, 0, 0, -1, 0, 0, 1, 1, 0, -1, 0, -1, -1, 0, -1 ], 
  [ -1, 1, -2, -1, 0, -1, -1, 0, -1, 0, 0, 0, 1, -1, -1, -1, 1, -2, 2, 1, 0, 
      0 ], [ -1, 0, -1, -2, 1, -1, 0, 0, -1, 1, 1, 0, 1, -1, -1, -1, 1, -1, 
      1, 1, 0, 1 ], 
  [ 1, 0, 0, 1, -2, 1, 0, 1, 0, -1, -2, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, -1 ], 
  [ -1, 1, -1, -1, 1, -2, -1, -1, -1, 1, 1, 0, 1, -1, -1, 0, 1, -1, 1, 1, 0, 
      1 ], [ -1, 1, -1, 0, 0, -1, -2, -1, -1, 1, 0, -1, 1, -1, -1, 0, 1, -1, 
      1, 1, 0, 1 ], 
  [ -1, 1, 0, 0, 1, -1, -1, -2, 0, 1, 1, -1, 0, 0, -1, 0, 1, 1, 1, 1, 0, 1 ], 
  [ -1, 0, -1, -1, 0, -1, -1, 0, -2, 1, -1, -1, 1, 0, -1, -1, 1, -2, 2, 1, 0, 
      0 ], [ 1, 0, 0, 1, -1, 1, 1, 1, 1, -2, -1, 1, -1, 0, 1, 0, 0, 1, -1, 0, 
      0, -1 ], 
  [ 1, -1, 0, 1, -2, 1, 0, 1, -1, -1, -4, 0, 0, 1, 1, 0, 0, -1, 0, 0, 0, -2 ],
  [ -1, 0, 0, 0, 0, 0, -1, -1, -1, 1, 0, -2, 1, 0, 0, 0, 0, -1, 1, 0, 0, 1 ], 
  [ 1, 0, 1, 1, 0, 1, 1, 0, 1, -1, 0, 1, -2, 1, 1, 1, -1, 2, -1, -1, 0, -1 ], 
  [ -1, 1, -1, -1, 0, -1, -1, 0, 0, 0, 1, 0, 1, -2, -1, -1, 1, -1, 1, 1, 0, 1 
     ], [ -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 0, 1, -1, -2, 0, 1, -1, 2, 
      1, -1, 1 ], 
  [ -1, 0, -1, -1, 0, 0, 0, 0, -1, 0, 0, 0, 1, -1, 0, -2, 1, -2, 1, 0, 1, 0 ],
  [ 1, -1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, -1, 1, 1, 1, -2, 1, -2, -1, 0, 0 ], 
  [ -1, 0, -2, -1, 0, -1, -1, 1, -2, 1, -1, -1, 2, -1, -1, -2, 1, -4, 2, 1, 
      0, 0 ], 
  [ 2, -1, 2, 1, -1, 1, 1, 1, 2, -1, 0, 1, -1, 1, 2, 1, -2, 2, -4, -2, 1, -1 ]
    , [ 1, -1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, -1, 1, 1, 0, -1, 1, -2, -2, 1, 
      -1 ], 
  [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 1, 1, -2, 1 ], 
  [ 1, -1, 0, 1, -1, 1, 1, 1, 0, -1, -2, 1, -1, 1, 1, 0, 0, 0, -1, -1, 1, -2 
     ] ]
gap> d:=c.DualGraph;;
gap> Size(d.Facets);
720
gap> d:=c.SpanningTree;;
gap> Size(d.Facets);
15
gap> 
gap> #labels
gap> labels:="abcdefghijklmnopqrstuvwxyz";;
gap> SCRelabel(c,List([1..c.F[1]],x->labels[x]));
true
gap> c.Facets{[1..10]};
[ "abchl", "abchp", "abclp", "abdgk", "abdgo", "abdko", "abegm", "abego", 
  "abehj", "abehn" ]
gap> c.Generators;
[ [ "abchl", 240 ], [ "abehn", 48 ] ]
gap> 
gap> #connected/unconnected complexes
gap> c:=complexes[7];;
gap> SCDim(c);
1
gap> c.F;
[ 6, 4 ]
gap> c.FaceLattice;
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
  [ [ 1, 2 ], [ 2, 3 ], [ 4, 5 ], [ 5, 6 ] ] ]
gap> c.IsStronglyConnected;
false
gap> Size(c.StronglyConnectedComponents);
2
gap> c.IsConnected;
false
gap> Size(c.ConnectedComponents);
2
gap> 
gap> #homology and cohomology
gap> c:=complexes[8];;
gap> SCCohomology(c);
[ [ 1, [  ] ], [ 0, [  ] ], [ 0, [ 2 ] ] ]
gap> h:=SCHomology(c);
[ [ 0, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
gap> c:=complexes[8];;
gap> h=SCHomologyInternal(c);
true
gap> 
gap> #operators
gap> c:=SCCartesianPower(SCBdSimplex(2),2);;
gap> c.F;
[ 9, 27, 18 ]
gap> c.Homology;
[ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
gap> d:=SCConnectedSum(c,c);;
gap> d=c+c;
true
gap> d.F;
[ 15, 51, 34 ]
gap> d.Homology;
[ [ 0, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
gap> 
gap> c:=SCCartesianProduct(SCBdSimplex(3),SCBdCrossPolytope(3));;
gap> c=SCBdSimplex(3)*SCBdCrossPolytope(3);
true
gap> SCDim(c);
4
gap> c.F;
[ 24, 156, 424, 480, 192 ]
gap> c.IsCentrallySymmetric;
true
gap> c.CentrallySymmetricElement;
(1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16)(17,18)(19,20)(21,22)(23,24)
gap> 
gap> #generating complexes
gap> c:=SCFromDifferenceCycles([[1,1,6],[3,3,2]]);;
gap> SCDim(c);
2
gap> SCRelabel(c,List([1..c.F[1]],x->labels[x]));
true
gap> c.F;
[ 8, 24, 16 ]
gap> c.Homology;
[ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
gap> 
gap> G:=Group([ (2,6)(4,8), (1,4,3,6,5,8,7,2), (1,3)(2,6)(5,7) ]);;
gap> d:=SCFromGenerators(G,[[1,2,3]]);;
gap> SCIsomorphism(c,d);
[ [ 'a', 1 ], [ 'b', 2 ], [ 'c', 3 ], [ 'd', 4 ], [ 'e', 5 ], [ 'f', 6 ], 
  [ 'g', 7 ], [ 'h', 8 ] ]
gap> 
gap> #bistellar moves
gap> c:=SCBdSimplex(3);;
gap> c.F;
[ 4, 6, 4 ]
gap> 
gap> c:=SCMove(c,[[1,2,3],[]]);;
gap> c.F;
[ 5, 9, 6 ]
gap> 
gap> c:=SCMove(c,[[5],[1,2,3]]);;
gap> c.F;
[ 4, 6, 4 ]
gap> 
gap> c:=SCBdCrossPolytope(4);;
gap> SCIsNormalSurface(SCNS([[1,2,3],[2,3,4],[1,3,4],[1,2,4]]));
true
gap> SCNSEmpty();
[NormalSurface

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="empty normal surface"
 Dim=-1

/NormalSurface]
gap> sl:=SCNSSlicing(c,[[1,2,3,4],[5,6,7,8]]);;
gap> sl<>fail;
true
gap> SCIsSimplicialComplex(SCNSTriangulation(sl));
true
gap> 
gap> SCMappingCylinder(2);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Mapping cylinder Bd(CP^2) = L(2,1)"
 Dim=4

/SimplicialComplex]
gap> 
gap> SCSeriesAGL(17);
[ AGL(1,17), [ [ 1, 2, 4, 8, 16 ] ] ]
gap> SCSeriesBdHandleBody(3,9);
[SimplicialComplex

 Properties known: Dim, FacetsEx, IsOrientable, Name, TopologicalType, 
                   Vertices.

 Name="Sphere bundle S^2 ~ S^1"
 Dim=3
 IsOrientable=false
 TopologicalType="S^2 ~ S^1"

/SimplicialComplex]
gap> SCSeriesC2n(16);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, 
                   TopologicalType, Vertices.

 Name="C_32 = { (1:1:11:19),(1:1:19:11),(1:11:1:19),(2:11:2:17),(2:13:2:15) }"
 Dim=3
 TopologicalType="S^2 ~ S^1"

/SimplicialComplex]
gap> SCSeriesCSTSurface(1,2,8);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="cst surface S_{(1,2,8)} = { (1:2:5),(1:5:2) }"
 Dim=2

/SimplicialComplex]
gap> SCSeriesD2n(20);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, 
                   TopologicalType, Vertices.

 Name="D_40 = { (1:1:1:37),(1:2:35:2),(3:16:5:16),(2:3:16:19),(2:19:16:3) }"
 Dim=3
 TopologicalType="S^2 ~ S^1"

/SimplicialComplex]
gap> SCSeriesHandleBody(3,9);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, IsOrientable, 
                   Name, TopologicalType, Vertices.

 Name="Handle body B^2 x S^1"
 Dim=3
 IsOrientable=true
 TopologicalType="B^2 x S^1"

/SimplicialComplex]
gap> SCSeriesK(1,0);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="K^1_0"
 Dim=3

/SimplicialComplex]
gap> SCSeriesKu(3);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="Sl_12 = G{ [1,2,4,7],[1,2,7,8],[1,4,7,12] }"
 Dim=3

/SimplicialComplex]
gap> SCSeriesL(1,0);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="L^1_0"
 Dim=3

/SimplicialComplex]
gap> SCSeriesLe(7)<>fail;
true
gap> SCSeriesNSB1(11);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="Neighborly sphere bundle NSB_1"
 Dim=3

/SimplicialComplex]
gap> SCSeriesNSB2(11);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="Neighborly sphere bundle NSB_2"
 Dim=3

/SimplicialComplex]
gap> SCSeriesNSB3(11);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="Neighborly sphere bundle NSB_3"
 Dim=3

/SimplicialComplex]
gap> SCSeriesPrimeTorus(1,2,7);
[SimplicialComplex

 Properties known: DifferenceCycles, Dim, FacetsEx, Name, Vertices.

 Name="prime torus S_{(1,2,7)} = { (1:2:4),(1:4:2) }"
 Dim=2

/SimplicialComplex]
gap> 
gap> SCFVectorBdCrossPolytope(4);
[ 8, 24, 32, 16 ]
gap> SCFVectorBdCyclicPolytope(4,7);
[ 7, 21, 28, 14 ]
gap> SCFVectorBdSimplex(4);
[ 5, 10, 10, 5 ]
gap> 
gap> G:=Group((1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16),
> (1,3)(2,4)(5,7)(6,8)(9,11)(10,12)(13,15)(14,16),
> (1,5)(2,6)(3,7)(4,8)(9,13)(10,14)(11,15)(12,16),
> (1,9)(2,10)(3,11)(4,12)(5,13)(6,14)(7,15)(8,16),
> (2,13,15,11,14,3,5,8,16,7,4,9,10,6,12));;
gap> K3:=SCFromGenerators(G,[[2,3,4,5,9],[2,5,7,10,11]]);
[SimplicialComplex

 Properties known: Dim, FacetsEx, Name, Vertices.

 Name="complex from generators under unknown group"
 Dim=4

/SimplicialComplex]
gap> ll:=SCsFromGroupExt(G,16,4,0,0,false,false,0,[]);
[ [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="Complex 1 of ((C2 x C2 x C2 x C2) : C5) : C3 (multiple orbits)"
     Dim=4
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="Complex 2 of ((C2 x C2 x C2 x C2) : C5) : C3 (multiple orbits)"
     Dim=4
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="Complex 3 of ((C2 x C2 x C2 x C2) : C5) : C3 (multiple orbits)"
     Dim=4
    
    /SimplicialComplex], [SimplicialComplex
    
     Properties known: Dim, FacetsEx, Name, Vertices.
    
     Name="Complex 4 of ((C2 x C2 x C2 x C2) : C5) : C3 (multiple orbits)"
     Dim=4
    
    /SimplicialComplex] ]
gap> SCIsIsomorphic(ll[1],K3);
true
gap> 
gap> SCInfoLevel(1);
true
gap> 
gap> STOP_TEST("simpcomp.tst", 1000000000 );
