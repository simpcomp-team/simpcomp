################################################################################
##
##  simpcomp / gentest.gap
##
##  Generate simpcomp.tst file by calling: $ gap < gentest.gap 
##
##  $Id$
##
################################################################################

LoadPackage("simpcomp");

LogTo("simpcomp.tst");

START_TEST("simpcomp package test");

SCInfoLevel(0);

complexes:=[
SCEmpty(),
SCBdSimplex(4),
SCBdCrossPolytope(4),
SC([[1,3,5],[2,3,5],[1,2,4],[1,3,4],[2,3,4]]), #with boundary
SC([[1,2,3,5], [1,2,3,8], [1,2,4,5], [1,2,4,9], [1,2,7,8], [1,2,7,9], [1,3,4,5],
[1,3,4,9], [1,3,8,9], [1,6,7,8], [1,6,7,9], [1,6,8,9], [2,3,4,6], [2,3,4,9],
[2,3,5,6], [2,3,8,9], [2,4,5,6], [2,7,8,9], [3,4,5,7], [3,4,6,7], [3,5,6,7],
[4,5,6,8], [4,5,7,8], [4,6,7,8], [5,6,7,9], [5,6,8,9], [5,7,8,9]]), #S2~S1
SC([[1,2,3,8,12], [1,2,3,8,16], [1,2,3,12,16], [1,2,4,7,11], [1,2,4,7,15],
[1,2,4,11,15], [1,2,5,7,13], [1,2,5,7,15], [1,2,5,8,10], [1,2,5,8,14],
[1,2,5,10,16], [1,2,5,13,16], [1,2,5,14,15], [1,2,6,7,9], [1,2,6,7,13],
[1,2,6,8,14], [1,2,6,8,16], [1,2,6,9,15], [1,2,6,13,16], [1,2,6,14,15],
[1,2,7,9,11], [1,2,8,10,12], [1,2,9,11,15], [1,2,10,12,16], [1,3,4,6,10],
[1,3,4,6,14], [1,3,4,10,14], [1,3,5,6,9], [1,3,5,6,11], [1,3,5,9,12],
[1,3,5,11,12], [1,3,6,9,15], [1,3,6,10,11], [1,3,6,14,15], [1,3,7,8,9],
[1,3,7,8,11], [1,3,7,9,10], [1,3,7,10,11], [1,3,8,9,12], [1,3,8,11,13],
[1,3,8,13,16], [1,3,9,10,15], [1,3,10,14,15], [1,3,11,12,13], [1,3,12,13,16],
[1,4,5,6,10], [1,4,5,6,14], [1,4,5,10,16], [1,4,5,14,16], [1,4,7,8,11],
[1,4,7,8,15], [1,4,8,11,13], [1,4,8,13,15], [1,4,9,11,13], [1,4,9,11,16],
[1,4,9,13,14], [1,4,9,14,16], [1,4,10,12,13], [1,4,10,12,16], [1,4,10,13,14],
[1,4,11,15,16], [1,4,12,13,15], [1,4,12,15,16], [1,5,6,9,12], [1,5,6,10,11],
[1,5,6,12,14], [1,5,7,13,16], [1,5,7,15,16], [1,5,8,10,12], [1,5,8,12,14],
[1,5,10,11,12], [1,5,14,15,16], [1,6,7,8,9], [1,6,7,8,13], [1,6,8,9,12],
[1,6,8,12,14], [1,6,8,13,16], [1,7,8,13,15], [1,7,9,10,14], [1,7,9,11,14],
[1,7,10,11,14], [1,7,12,13,15], [1,7,12,13,16], [1,7,12,15,16], [1,9,10,14,15],
[1,9,11,13,14], [1,9,11,15,16], [1,9,14,15,16], [1,10,11,12,13],
[1,10,11,13,14], [2,3,4,5,9], [2,3,4,5,13], [2,3,4,9,13], [2,3,5,6,9],
[2,3,5,6,13], [2,3,6,9,15], [2,3,6,13,15], [2,3,7,8,12], [2,3,7,8,16],
[2,3,7,12,14], [2,3,7,14,16], [2,3,9,11,14], [2,3,9,11,15], [2,3,9,13,14],
[2,3,10,12,14], [2,3,10,12,15], [2,3,10,13,14], [2,3,10,13,15], [2,3,11,14,16],
[2,3,11,15,16], [2,3,12,15,16], [2,4,5,6,10], [2,4,5,6,12], [2,4,5,9,12],
[2,4,5,10,16], [2,4,5,13,16], [2,4,6,10,11], [2,4,6,11,12], [2,4,7,8,10],
[2,4,7,8,12], [2,4,7,10,11], [2,4,7,12,14], [2,4,7,14,15], [2,4,8,9,10],
[2,4,8,9,12], [2,4,9,10,16], [2,4,9,13,16], [2,4,11,12,14], [2,4,11,14,15],
[2,5,6,9,12], [2,5,6,10,11], [2,5,6,11,13], [2,5,7,8,10], [2,5,7,8,14],
[2,5,7,10,11], [2,5,7,11,13], [2,5,7,14,15], [2,6,7,9,11], [2,6,7,11,13],
[2,6,8,14,15], [2,6,8,15,16], [2,6,9,11,12], [2,6,13,15,16], [2,7,8,14,16],
[2,8,9,10,13], [2,8,9,12,13], [2,8,10,12,13], [2,8,11,14,15], [2,8,11,14,16],
[2,8,11,15,16], [2,9,10,13,16], [2,9,11,12,14], [2,9,12,13,14], [2,10,12,13,14],
[2,10,12,15,16], [2,10,13,15,16], [3,4,5,7,13], [3,4,5,7,15], [3,4,5,8,11],
[3,4,5,8,15], [3,4,5,9,11], [3,4,6,7,12], [3,4,6,7,16], [3,4,6,8,14],
[3,4,6,8,16], [3,4,6,10,12], [3,4,7,12,14], [3,4,7,13,16], [3,4,7,14,15],
[3,4,8,11,13], [3,4,8,13,16], [3,4,8,14,15], [3,4,9,11,13], [3,4,10,12,14],
[3,5,6,8,11], [3,5,6,8,15], [3,5,6,13,15], [3,5,7,13,14], [3,5,7,14,15],
[3,5,9,11,16], [3,5,9,12,16], [3,5,10,13,14], [3,5,10,13,15], [3,5,10,14,15],
[3,5,11,12,16], [3,6,7,10,12], [3,6,7,10,16], [3,6,8,10,11], [3,6,8,10,16],
[3,6,8,14,15], [3,7,8,9,12], [3,7,8,10,11], [3,7,8,10,16], [3,7,9,10,12],
[3,7,13,14,16], [3,9,10,12,15], [3,9,11,13,14], [3,9,11,15,16], [3,9,12,15,16],
[3,11,12,13,16], [3,11,13,14,16], [4,5,6,7,12], [4,5,6,7,16], [4,5,6,14,16],
[4,5,7,9,12], [4,5,7,9,15], [4,5,7,13,16], [4,5,8,9,11], [4,5,8,9,15],
[4,6,8,13,14], [4,6,8,13,16], [4,6,9,13,14], [4,6,9,13,16], [4,6,9,14,16],
[4,6,10,11,15], [4,6,10,12,15], [4,6,11,12,15], [4,7,8,9,12], [4,7,8,9,15],
[4,7,8,10,11], [4,8,9,10,11], [4,8,13,14,15], [4,9,10,11,16], [4,10,11,15,16],
[4,10,12,13,14], [4,10,12,15,16], [4,11,12,14,15], [4,12,13,14,15],
[5,6,7,12,16], [5,6,8,11,15], [5,6,11,13,15], [5,6,12,14,16], [5,7,8,10,14],
[5,7,9,12,16], [5,7,9,15,16], [5,7,10,11,14], [5,7,11,13,14], [5,8,9,10,13],
[5,8,9,10,14], [5,8,9,11,16], [5,8,9,13,15], [5,8,9,14,16], [5,8,10,12,13],
[5,8,11,12,15], [5,8,11,12,16], [5,8,12,13,15], [5,8,12,14,16], [5,9,10,13,15],
[5,9,10,14,15], [5,9,14,15,16], [5,10,11,12,13], [5,10,11,13,14],
[5,11,12,13,15], [6,7,8,9,13], [6,7,9,10,13], [6,7,9,10,14], [6,7,9,11,14],
[6,7,10,12,15], [6,7,10,13,15], [6,7,10,14,16], [6,7,11,12,15], [6,7,11,12,16],
[6,7,11,13,15], [6,7,11,14,16], [6,8,9,12,13], [6,8,10,11,15], [6,8,10,15,16],
[6,8,12,13,14], [6,9,10,13,16], [6,9,10,14,16], [6,9,11,12,14], [6,9,12,13,14],
[6,10,13,15,16], [6,11,12,14,16], [7,8,9,13,15], [7,8,10,14,16], [7,9,10,12,15],
[7,9,10,13,15], [7,9,12,15,16], [7,11,12,13,15], [7,11,12,13,16],
[7,11,13,14,16], [8,9,10,11,16], [8,9,10,14,16], [8,10,11,15,16],
[8,11,12,14,15], [8,11,12,14,16], [8,12,13,14,15]]), #K3
SC([[1,2],[2,3],[4,5],[5,6]]), #unconnected
SC([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],
[2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]) #rp2
];;


#general tests
c:=complexes[1];;
SCDim(c);
SCName(c);
c.Name;
c.IsEmpty;
c.F;
Size(c.Facets);
c.Homology;
c.Cohomology;
c.HasBoundary;
c.Orientation;
Size(c.ConnectedComponents);
Size(c.StronglyConnectedComponents);
c.MinimalNonFaces;

c:=complexes[2];;
SCDim(c);
c.IsEmpty;
c.F;
Size(c.Facets);
c.Homology;
c.Cohomology;
c.HasBoundary;
c.Orientation;
c.AutomorphismGroup;
c.GeneratorsEx;
Size(c.ConnectedComponents);
Size(c.StronglyConnectedComponents);
c.MinimalNonFaces;
hd:=SCHasseDiagram(c);
is:=SCIsSphere(c);
isc:=SCIsSimplyConnected(c);
hc:=SCHomologyClassic(c);
ism:=SCBistellarIsManifold(c);

c:=complexes[3];;
SCAlexanderDual(c);
SCAltshulerSteinberg(c);
SCAntiStar(c,1);
SCAutomorphismGroup(c);
SCAutomorphismGroupInternal(c);
SCAutomorphismGroupSize(c);
SCAutomorphismGroupStructure(c);
SCAutomorphismGroupTransitivity(c);
SCBoundary(c);
SCCentrallySymmetricElement(c);
SCCohomology(c);
SCCohomologyBasis(c,0);
SCCohomologyBasisAsSimplices(c,0);
SCCollapseGreedy(c);
SCCone(c);
SCConnectedComponents(c);
SCConnectedProduct(c,2);
SCConnectedSum(c,c);
SCConnectedSumMinus(c,c);
IsIdenticalObj(c,SCCopy(c));
SCDifference(c,c);
SCDim(c);
SCFVector(SCDualGraph(c));
SCEquivalent(c,c);
SCEulerCharacteristic(c);
SCExamineComplexBistellar(c)<>fail;
SCFVector(c);
SCFaceLattice(c);
SCFaces(c,1);
SCFacets(c);
SCFillSphere(c);
SCFpBettiNumbers(c,2);
Size(SCFundamentalGroup(c));
SCGVector(c);
SCGenerators(c);
SCHVector(c);
SCHasBoundary(c);
SCHasInterior(c);
SCHomology(c);
SCHomologyBasis(c,0);
SCHomologyBasisAsSimplices(c,0);
SCHomologyInternal(c);
SCInterior(c);
SCIntersection(c,c);
SCIsCentrallySymmetric(c);
SCIsConnected(c);
SCIsEmpty(c);
SCIsEulerianManifold(c);
SCIsFlag(c);
SCIsHomologySphere(c);
SCIsInKd(c,1);
SCIsIsomorphic(c,c);
SCIsKNeighborly(c,2);
SCIsKStackedSphere(c,1);
SCIsManifold(c);
SCIsMovableComplex(c);
SCIsOrientable(c);
SCIsPolyhedralComplex(c);
SCIsPropertyObject(c);
SCIsPseudoManifold(c);
SCIsPure(c);
SCIsSimplicialComplex(c);
SCIsStronglyConnected(c);
SCIsTight(c);
SCLabelMax(c);
SCLabelMin(c);
SCLabels(c);
SCLink(c,1);
SCLinks(c,0);
SCMinimalNonFaces(c);
SCMorseIsPerfect(c,SCVertices(c));
SCMorseMultiplicityVector(c,SCVertices(c));
SCMorseNumberOfCriticalPoints(c,SCVertices(c));
SCNeighborliness(c);
SCNumFaces(c,1);
SCOrientation(c);
SCRMoves(c,1);
SCRelabel(c,[11..18]);
SCRelabelTransposition(c,[11,12]);
SCRelabelStandard(c);
SCRename(c,"test");
SCName(c);
SCSkel(c,0);
SCSpan(c,[1..4]);
SCSpanningTree(c);
SCStar(c,1);
SCStars(c,0);
SCStronglyConnectedComponents(c);
SCSuspension(c);
SCTopologicalType(c);
SCVertexIdentification(c,[1],[2]);
SCVertices(c);
SCVerticesEx(c);
SCIsSimplicialComplex(SCWedge(c,c));
hd:=SCHasseDiagram(c);
is:=SCIsSphere(c);
isc:=SCIsSimplyConnected(c);
hc:=SCHomologyClassic(c);
ism:=SCBistellarIsManifold(c);

c:=complexes[4];;
SCDim(c);
c.IsEmpty;
c.F;
Size(c.Facets);
c.Homology;
c.Cohomology;
c.HasBoundary;
c.Orientation;
Size(c.ConnectedComponents);
Size(c.StronglyConnectedComponents);
c.MinimalNonFaces;
hd:=SCHasseDiagram(c);
is:=SCIsSphere(c);
isc:=SCIsSimplyConnected(c);
hc:=SCHomologyClassic(c);

c:=complexes[5];;
SCDim(c);
c.IsEmpty;
c.F;
Size(c.Facets);
c.Homology;
c.Cohomology;
c.HasBoundary;
c.Orientation;
c.AutomorphismGroup;
c.GeneratorsEx;
Size(c.ConnectedComponents);
Size(c.StronglyConnectedComponents);
c.MinimalNonFaces;
hd:=SCHasseDiagram(c);
is:=SCIsSphere(c);
isc:=SCIsSimplyConnected(c);
hc:=SCHomologyClassic(c);
ism:=SCBistellarIsManifold(c);

c:=complexes[6];;
SCDim(c);
SCRename(c,"K3 surface");
SCName(c)=c.Name;
c.IsEmpty;
c.F;
Size(c.Facets);
c.Homology;
c.Cohomology;
c.HasBoundary;
c.Orientation;
c.AutomorphismGroup;
c.GeneratorsEx;
Size(c.ConnectedComponents);
Size(c.StronglyConnectedComponents);
Size(c.MinimalNonFaces[4]);
c.IntersectionForm;
d:=c.DualGraph;;
Size(d.Facets);
d:=c.SpanningTree;;
Size(d.Facets);

#labels
labels:="abcdefghijklmnopqrstuvwxyz";;
SCRelabel(c,List([1..c.F[1]],x->labels[x]));
c.Facets{[1..10]};
c.Generators;

#connected/unconnected complexes
c:=complexes[7];;
SCDim(c);
c.F;
c.FaceLattice;
c.IsStronglyConnected;
Size(c.StronglyConnectedComponents);
c.IsConnected;
Size(c.ConnectedComponents);

#homology and cohomology
c:=complexes[8];;
SCCohomology(c);
h:=SCHomology(c);
c:=complexes[8];;
h=SCHomologyInternal(c);


#operators
c:=SCCartesianPower(SCBdSimplex(2),2);;
c.F;
c.Homology;
d:=SCConnectedSum(c,c);;
d=c+c;
d.F;
d.Homology;

c:=SCCartesianProduct(SCBdSimplex(3),SCBdCrossPolytope(3));;
c=SCBdSimplex(3)*SCBdCrossPolytope(3);
SCDim(c);
c.F;
c.IsCentrallySymmetric;
c.CentrallySymmetricElement;

#generating complexes
c:=SCFromDifferenceCycles([[1,1,6],[3,3,2]]);;
SCDim(c);
SCRelabel(c,List([1..c.F[1]],x->labels[x]));
c.F;
c.Homology;

G:=Group([ (2,6)(4,8), (1,4,3,6,5,8,7,2), (1,3)(2,6)(5,7) ]);;
d:=SCFromGenerators(G,[[1,2,3]]);;
SCIsomorphism(c,d);

#bistellar moves
c:=SCBdSimplex(3);;
c.F;

c:=SCMove(c,[[1,2,3],[]]);;
c.F;

c:=SCMove(c,[[5],[1,2,3]]);;
c.F;

c:=SCBdCrossPolytope(4);;
SCIsNormalSurface(SCNS([[1,2,3],[2,3,4],[1,3,4],[1,2,4]]));
SCNSEmpty();
sl:=SCNSSlicing(c,[[1,2,3,4],[5,6,7,8]]);;
sl<>fail;
SCIsSimplicialComplex(SCNSTriangulation(sl));

SCMappingCylinder(2);

SCSeriesAGL(17);
SCSeriesBdHandleBody(3,9);
SCSeriesC2n(16);
SCSeriesCSTSurface(1,2,8);
SCSeriesD2n(20);
SCSeriesHandleBody(3,9);
SCSeriesK(1,0);
SCSeriesKu(3);
SCSeriesL(1,0);
SCSeriesLe(7)<>fail;
SCSeriesNSB1(11);
SCSeriesNSB2(11);
SCSeriesNSB3(11);
SCSeriesPrimeTorus(1,2,7);

SCFVectorBdCrossPolytope(4);
SCFVectorBdCyclicPolytope(4,7);
SCFVectorBdSimplex(4);

G:=Group((1,2)(3,4)(5,6)(7,8)(9,10)(11,12)(13,14)(15,16),
(1,3)(2,4)(5,7)(6,8)(9,11)(10,12)(13,15)(14,16),
(1,5)(2,6)(3,7)(4,8)(9,13)(10,14)(11,15)(12,16),
(1,9)(2,10)(3,11)(4,12)(5,13)(6,14)(7,15)(8,16),
(2,13,15,11,14,3,5,8,16,7,4,9,10,6,12));;
K3:=SCFromGenerators(G,[[2,3,4,5,9],[2,5,7,10,11]]);
ll:=SCsFromGroupExt(G,16,4,0,0,false,false,0,[]);
SCIsIsomorphic(ll[1],K3);

SCInfoLevel(1);

STOP_TEST("simpcomp.tst", 1000000000 );
