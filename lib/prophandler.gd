################################################################################
##
##  simpcomp / prophandler.gd
##
##  contains property handlers
##
##  $Id$
##
################################################################################


################################################################################
## <#GAPDoc Label="prophandlerspc">
##	This section contains a table of all property handlers of a <C>SCPolyhedralComplex</C> object.
##
## <Table Align="ll">
## <Row><Item><B>Property handler</B></Item><Item><B>Function called</B></Item></Row>
## <HorLine/>
## <Row><Item></Item><Item></Item></Row>
## <Row><Item>AntiStar</Item><Item><Ref Meth="SCAntiStar"/></Item></Row>
## <Row><Item>Ast</Item><Item><Ref Meth="SCAntiStar"/></Item></Row>
## <Row><Item>Facets</Item><Item><Ref Meth="SCFacets"/></Item></Row>
## <Row><Item>FacetsEx</Item><Item><Ref Meth="SCFacetsEx"/></Item></Row>
## <Row><Item>LabelMax</Item><Item><Ref Meth="SCLabelMax"/></Item></Row>
## <Row><Item>LabelMin</Item><Item><Ref Meth="SCLabelMin"/></Item></Row>
## <Row><Item>Labels</Item><Item><Ref Meth="SCLabels"/></Item></Row>
## <Row><Item>Lk</Item><Item><Ref Meth="SCLink"/></Item></Row>
## <Row><Item>Link</Item><Item><Ref Meth="SCLink"/></Item></Row>
## <Row><Item>Links</Item><Item><Ref Meth="SCLinks"/></Item></Row>
## <Row><Item>Lks</Item><Item><Ref Meth="SCLinks"/></Item></Row>
## <Row><Item>Name</Item><Item><Ref Meth="SCName"/></Item></Row>
## <Row><Item>Reference</Item><Item><Ref Meth="SCReference"/></Item></Row>
## <Row><Item>Relabel</Item><Item><Ref Meth="SCRelabel"/></Item></Row>
## <Row><Item>RelabelStandard</Item><Item><Ref Meth="SCRelabelStandard"/></Item></Row>
## <Row><Item>RelabelTransposition</Item><Item><Ref Meth="SCRelabelTransposition"/></Item></Row>
## <Row><Item>Rename</Item><Item><Ref Meth="SCRename"/></Item></Row>
## <Row><Item>SetReference</Item><Item><Ref Meth="SCSetReference"/></Item></Row>
## </Table>

## <Table Align="ll">
## <Row><Item>Star</Item><Item><Ref Meth="SCStar"/></Item></Row>
## <Row><Item>Str</Item><Item><Ref Meth="SCStar"/></Item></Row>
## <Row><Item>Stars</Item><Item><Ref Meth="SCStars"/></Item></Row>
## <Row><Item>Strs</Item><Item><Ref Meth="SCStars"/></Item></Row>
## <Row><Item>UnlabelFace</Item><Item><Ref Meth="SCUnlabelFace"/></Item></Row>
## <Row><Item>Vertices</Item><Item><Ref Meth="SCVertices"/></Item></Row>
## <Row><Item>VerticesEx</Item><Item><Ref Meth="SCVerticesEx"/></Item></Row>
## </Table>
##		
##<#/GAPDoc>
################################################################################


################################################################################
## <#GAPDoc Label="prophandlers">
##	This section contains a table of all property handlers of a <C>SCSimplicialComplex</C> object.
##
## <Table Align="ll">
## <Row><Item><B>Property handler</B></Item><Item><B>Function called</B></Item></Row>
## <HorLine/>
## <Row><Item></Item><Item></Item></Row>
## <Row><Item>ASDet</Item><Item><Ref Meth="SCAltshulerSteinberg"/></Item></Row>
## <Row><Item>AlexanderDual</Item><Item><Ref Meth="SCAlexanderDual"/></Item></Row>
## <Row><Item>AutomorphismGroup</Item><Item><Ref Meth="SCAutomorphismGroup"/></Item></Row>
## <Row><Item>AutomorphismGroupInternal</Item><Item><Ref Meth="SCAutomorphismGroupInternal"/></Item></Row>
## <Row><Item>AutomorphismGroupSize</Item><Item><Ref Meth="SCAutomorphismGroupSize"/></Item></Row>
## <Row><Item>AutomorphismGroupStructure</Item><Item><Ref Meth="SCAutomorphismGroupStructure"/></Item></Row>
## <Row><Item>AutomorphismGroupTransitivity</Item><Item><Ref Meth="SCAutomorphismGroupTransitivity"/></Item></Row>
## <Row><Item>Bd</Item><Item><Ref Meth="SCBoundary"/></Item></Row>
## <Row><Item>Boundary</Item><Item><Ref Meth="SCBoundary"/></Item></Row>
## <Row><Item>BoundaryOperatorMatrix</Item><Item><Ref Meth="SCBoundaryOperatorMatrix"/></Item></Row>
## <Row><Item>Chi</Item><Item><Ref Meth="SCEulerCharacteristic"/></Item></Row>
## <Row><Item>CoboundaryOperatorMatrix</Item><Item><Ref Meth="SCCoboundaryOperatorMatrix"/></Item></Row>
## <Row><Item>Cohomology</Item><Item><Ref Meth="SCCohomology"/></Item></Row>
## <Row><Item>CohomologyBasis</Item><Item><Ref Meth="SCCohomologyBasis"/></Item></Row>
## <Row><Item>CohomologyBasisAsSimplices</Item><Item><Ref Meth="SCCohomologyBasisAsSimplices"/></Item></Row>
## <Row><Item>CollapseGreedy</Item><Item><Ref Meth="SCCollapseGreedy"/></Item></Row>
## <Row><Item>Cone</Item><Item><Ref Meth="SCCone"/></Item></Row>
## <Row><Item>ConnectedComponents</Item><Item><Ref Meth="SCConnectedComponents"/></Item></Row>
## <Row><Item>Copy</Item><Item><Ref Meth="SCCopy"/></Item></Row>
## <Row><Item>CupProduct</Item><Item><Ref Meth="SCCupProduct"/></Item></Row>
## <Row><Item>DehnSommervilleCheck</Item><Item><Ref Meth="SCDehnSommervilleCheck"/></Item></Row>
## <Row><Item>DeletedJoin</Item><Item><Ref Meth="SCDeletedJoin"/></Item></Row>
## <Row><Item>DetermineTopologicalType</Item><Item><Ref Meth="SCLibDetermineTopologicalType"/></Item></Row>
## <Row><Item>Difference</Item><Item><Ref Meth="SCDifference"/></Item></Row>
## <Row><Item>DifferenceCycles</Item><Item><Ref Meth="SCDifferenceCycles"/></Item></Row>
## <Row><Item>Dim</Item><Item><Ref Meth="SCDim"/></Item></Row>
## <Row><Item>DualGraph</Item><Item><Ref Meth="SCDualGraph"/></Item></Row>
## <Row><Item>Equivalent</Item><Item><Ref Meth="SCEquivalent"/></Item></Row>
## <Row><Item>EulerCharacteristic</Item><Item><Ref Meth="SCEulerCharacteristic"/></Item></Row>
## <Row><Item>ExportJavaView</Item><Item><Ref Meth="SCExportJavaView"/></Item></Row>
## <Row><Item>ExportLatexTable</Item><Item><Ref Meth="SCExportLatexTable"/></Item></Row>
## <Row><Item>ExportPolymake</Item><Item><Ref Meth="SCExportPolymake"/></Item></Row>
## </Table>

## <Table Align="ll">
## <Row><Item>F</Item><Item><Ref Meth="SCFVector"/></Item></Row>
## <Row><Item>FaceLattice</Item><Item><Ref Meth="SCFaceLattice"/></Item></Row>
## <Row><Item>FaceLatticeEx</Item><Item><Ref Meth="SCFaceLatticeEx"/></Item></Row>
## <Row><Item>Faces</Item><Item><Ref Meth="SCFaces"/></Item></Row>
## <Row><Item>FacesEx</Item><Item><Ref Meth="SCFacesEx"/></Item></Row>
## <Row><Item>FillSphere</Item><Item><Ref Meth="SCFillSphere"/></Item></Row>
## <Row><Item>FpBetti</Item><Item><Ref Meth="SCFpBettiNumbers"/></Item></Row>
## <Row><Item>FundamentalGroup</Item><Item><Ref Meth="SCFundamentalGroup"/></Item></Row>
## <Row><Item>G</Item><Item><Ref Meth="SCGVector"/></Item></Row>
## <Row><Item>Generators</Item><Item><Ref Meth="SCGenerators"/></Item></Row>
## <Row><Item>GeneratorsEx</Item><Item><Ref Meth="SCGeneratorsEx"/></Item></Row>
## <Row><Item>H</Item><Item><Ref Meth="SCHVector"/></Item></Row>
## <Row><Item>HandleAddition</Item><Item><Ref Meth="SCHandleAddition"/></Item></Row>
## <Row><Item>HasBd</Item><Item><Ref Meth="SCHasBoundary"/></Item></Row>
## <Row><Item>HasBoundary</Item><Item><Ref Meth="SCHasBoundary"/></Item></Row>
## <Row><Item>HasInt</Item><Item><Ref Meth="SCHasInterior"/></Item></Row>
## <Row><Item>HasInterior</Item><Item><Ref Meth="SCHasInterior"/></Item></Row>
## <Row><Item>HasseDiagram</Item><Item><Ref Meth="SCHasseDiagram"/></Item></Row>
## <Row><Item>Homology</Item><Item><Ref Meth="SCHomology"/></Item></Row>
## <Row><Item>HomologyBasis</Item><Item><Ref Meth="SCHomologyBasis"/></Item></Row>
## <Row><Item>HomologyBasisAsSimplices</Item><Item><Ref Meth="SCHomologyBasisAsSimplices"/></Item></Row>
## <Row><Item>HomologyInternal</Item><Item><Ref Meth="SCHomologyInternal"/></Item></Row>
## <Row><Item>Incidences</Item><Item><Ref Meth="SCIncidences"/></Item></Row>
## <Row><Item>IncidencesEx</Item><Item><Ref Meth="SCIncidencesEx"/></Item></Row>
## <Row><Item>Interior</Item><Item><Ref Meth="SCInterior"/></Item></Row>
## <Row><Item>Intersection</Item><Item><Ref Meth="SCIntersection"/></Item></Row>
## <Row><Item>IntersectionForm</Item><Item><Ref Meth="SCIntersectionForm"/></Item></Row>
## <Row><Item>IntersectionFormDimensionality</Item><Item><Ref Meth="SCIntersectionFormDimensionality"/></Item></Row>
## <Row><Item>IntersectionFormParity</Item><Item><Ref Meth="SCIntersectionFormParity"/></Item></Row>
## <Row><Item>IntersectionFormSignature</Item><Item><Ref Meth="SCIntersectionFormSignature"/></Item></Row>
## <Row><Item>IsCentrallySymmetric</Item><Item><Ref Meth="SCIsCentrallySymmetric"/></Item></Row>
## <Row><Item>IsConnected</Item><Item><Ref Meth="SCIsConnected"/></Item></Row>
## <Row><Item>IsEmpty</Item><Item><Ref Meth="SCIsEmpty"/></Item></Row>
## <Row><Item>IsEulerianManifold</Item><Item><Ref Meth="SCIsEulerianManifold"/></Item></Row>
## <Row><Item>IsFlag</Item><Item><Ref Meth="SCIsFlag"/></Item></Row>
## <Row><Item>IsHomologySphere</Item><Item><Ref Meth="SCIsHomologySphere"/></Item></Row>
## <Row><Item>IsInKd</Item><Item><Ref Meth="SCIsInKd"/></Item></Row>
## <Row><Item>IsIsomorphic</Item><Item><Ref Meth="SCIsIsomorphic"/></Item></Row>
## <Row><Item>IsKNeighborly</Item><Item><Ref Meth="SCIsKNeighborly"/></Item></Row>
## <Row><Item>IsKStackedSphere</Item><Item><Ref Meth="SCIsKStackedSphere"/></Item></Row>
## </Table>

## <Table Align="ll">
## <Row><Item>IsManifold</Item><Item><Ref Meth="SCIsManifold"/></Item></Row>
## <Row><Item>IsMovable</Item><Item><Ref Meth="SCIsMovableComplex"/></Item></Row>
## <Row><Item>Isomorphism</Item><Item><Ref Meth="SCIsomorphism"/></Item></Row>
## <Row><Item>IsomorphismEx</Item><Item><Ref Meth="SCIsomorphismEx"/></Item></Row>
## <Row><Item>IsOrientable</Item><Item><Ref Meth="SCIsOrientable"/></Item></Row>
## <Row><Item>IsPM</Item><Item><Ref Meth="SCIsPseudoManifold"/></Item></Row>
## <Row><Item>IsPure</Item><Item><Ref Meth="SCIsPure"/></Item></Row>
## <Row><Item>IsSC</Item><Item><Ref Meth="SCIsSimplyConnected"/></Item></Row>
## <Row><Item>IsSimplyConnected</Item><Item><Ref Meth="SCIsSimplyConnected"/></Item></Row>
## <Row><Item>IsShellable</Item><Item><Ref Meth="SCIsShellable"/></Item></Row>
## <Row><Item>IsSphere</Item><Item><Ref Meth="SCIsSphere"/></Item></Row>
## <Row><Item>IsStronglyConnected</Item><Item><Ref Meth="SCIsStronglyConnected"/></Item></Row>
## <Row><Item>IsSubcomplex</Item><Item><Ref Meth="SCIsSubcomplex"/></Item></Row>
## <Row><Item>IsTight</Item><Item><Ref Meth="SCIsTight"/></Item></Row>
## <Row><Item>Join</Item><Item><Ref Meth="SCJoin"/></Item></Row>
## <Row><Item>Load</Item><Item><Ref Meth="SCLoad"/></Item></Row>
## <Row><Item>MinimalNonFaces</Item><Item><Ref Meth="SCMinimalNonFaces"/></Item></Row>
## <Row><Item>MinimalNonFacesEx</Item><Item><Ref Meth="SCMinimalNonFacesEx"/></Item></Row>
## <Row><Item>MorseIsPerfect</Item><Item><Ref Meth="SCMorseIsPerfect"/></Item></Row>
## <Row><Item>MorseMultiplicityVector</Item><Item><Ref Meth="SCMorseMultiplicityVector"/></Item></Row>
## <Row><Item>MorseNumberOfCriticalPoints</Item><Item><Ref Meth="SCMorseNumberOfCriticalPoints"/></Item></Row>
## <Row><Item>Move</Item><Item><Ref Meth="SCMove"/></Item></Row>
## <Row><Item>Moves</Item><Item><Ref Meth="SCMoves"/></Item></Row>
## <Row><Item>Neighborliness</Item><Item><Ref Meth="SCNeighborliness"/></Item></Row>
## <Row><Item>Neighbors</Item><Item><Ref Meth="SCNeighbors"/></Item></Row>
## <Row><Item>NeighborsEx</Item><Item><Ref Meth="SCNeighborsEx"/></Item></Row>
## <Row><Item>NumFaces</Item><Item><Ref Meth="SCNumFaces"/></Item></Row>
## <Row><Item>Orientation</Item><Item><Ref Meth="SCOrientation"/></Item></Row>
## <Row><Item>PropertiesDropped</Item><Item><Ref Meth="SCPropertiesDropped"/></Item></Row>
## <Row><Item>Randomize</Item><Item><Ref Meth="SCRandomize"/></Item></Row>
## <Row><Item>RMoves</Item><Item><Ref Meth="SCRMoves"/></Item></Row>
## <Row><Item>Reduce</Item><Item><Ref Meth="SCReduceComplex"/></Item></Row>
## <Row><Item>ReduceAsSubcomplex</Item><Item><Ref Meth="SCReduceAsSubcomplex"/></Item></Row>
## <Row><Item>ReduceEx</Item><Item><Ref Meth="SCReduceComplexEx"/></Item></Row>
## <Row><Item>Save</Item><Item><Ref Meth="SCSave"/></Item></Row>
## <Row><Item>Details</Item><Item><Ref Meth="SCDetails"/></Item></Row>
## <Row><Item>Shelling</Item><Item><Ref Meth="SCShelling"/></Item></Row>
## <Row><Item>ShellingExt</Item><Item><Ref Meth="SCShellingExt"/></Item></Row>
## <Row><Item>Shellings</Item><Item><Ref Meth="SCShellings"/></Item></Row>
## <Row><Item>Skel</Item><Item><Ref Meth="SCSkel"/></Item></Row>
## <Row><Item>SkelEx</Item><Item><Ref Meth="SCSkelEx"/></Item></Row>
## <Row><Item>Slicing</Item><Item><Ref Meth="SCSlicing"/>, <Ref Meth="SCNSSlicing"/></Item></Row>
## <Row><Item>Span</Item><Item><Ref Meth="SCSpan"/></Item></Row>
## <Row><Item>SpanningTree</Item><Item><Ref Meth="SCSpanningTree"/></Item></Row>
## <Row><Item>StronglyConnectedComponents</Item><Item><Ref Meth="SCStronglyConnectedComponents"/></Item></Row>
## <Row><Item>Suspension</Item><Item><Ref Meth="SCSuspension"/></Item></Row>
## <Row><Item>Transitivity</Item><Item><Ref Meth="SCAutomorphismGroupTransitivity"/></Item></Row>
## <Row><Item>Union</Item><Item><Ref Meth="SCUnion"/></Item></Row>
## <Row><Item>VertexIdentification</Item><Item><Ref Meth="SCVertexIdentification"/></Item></Row>
## <Row><Item>Wedge</Item><Item><Ref Meth="SCWedge"/></Item></Row>
## </Table>
##		
##<#/GAPDoc>
################################################################################

#property handlers for SCSimplicialComplex
SCIntFunc.SCPropertyHandlers:=rec(

########################
## property handlers for SCPolyhedralComplexes

Facets:=SCFacets,
SCFacets:=SCFacets,
FacetsEx:=SCFacetsEx,
SCFacetsEx:=SCFacetsEx,
Vertices:=SCVertices,
SCVertices:=SCVertices,
VerticesEx:=SCVerticesEx,
SCVerticesEx:=SCVerticesEx,
Name:=SCName,
SCName:=SCName,

#labelops.gp
LabelMax:=SCLabelMax,
SCLabelMax:=SCLabelMax,
LabelMin:=SCLabelMin,
SCLabelMin:=SCLabelMin,
Labels:=SCLabels,
SCLabels:=SCLabels,
SCRelabel:=SCRelabel,
Relabel:=SCRelabel,
RelabelStandard:=SCRelabelStandard,
SCRelabelStandard:=SCRelabelStandard,
RelabelTransposition:=SCRelabelTransposition,
SCRelabelTransposition:=SCRelabelTransposition,
Rename:=SCRename,
SCRename:=SCRename,
UnlabelFace:=SCUnlabelFace,
SCUnlabelFace:=SCUnlabelFace,

SCReference:=SCReference,
Reference:=SCReference,
Ref:=SCReference,
SCSetReference:=SCSetReference,
SetReference:=SCSetReference,

#operations.gd
AntiStar:=SCAntiStar,
SCAntiStar:=SCAntiStar,
Ast:=SCAntiStar,
SCLink:=SCLink,
Link:=SCLink,
Lk:=SCLink,
SCLinks:=SCLinks,
Links:=SCLinks,
Lks:=SCLinks,
SCStar:=SCStar,
Star:=SCStar,
Str:=SCStar,
SCStars:=SCStars,
Stars:=SCStars,
Strs:=SCStars,
############################


#bistellar.gd
Equivalent:=SCEquivalent,
SCEquivalent:=SCEquivalent,
IsKStackedSphere:=SCIsKStackedSphere,
SCIsKStackedSphere:=SCIsKStackedSphere,
IsManifold:=SCIsManifold,
SCIsManifold:=SCIsManifold,
IsMovable:=SCIsMovableComplex,
IsMovableComplex:=SCIsMovableComplex,
SCIsMovableComplex:=SCIsMovableComplex,
Move:=SCMove,
SCMove:=SCMove,
Moves:=SCMoves,
SCMoves:=SCMoves,
Randomize:=SCRandomize,
SCRandomize:=SCRandomize,
RMoves:=SCRMoves,
SCRMoves:=SCRMoves,
ReduceAsSubcomplex:=SCReduceAsSubcomplex,
SCReduceAsSubcomplex:=SCReduceAsSubcomplex,
Reduce:=SCReduceComplex,
ReduceComplex:=SCReduceComplex,
SCReduceComplex:=SCReduceComplex,
ReduceEx:=SCReduceComplexEx,
SCReduceComplexEx:=SCReduceComplexEx,

#morse.gd
IsTight:=SCIsTight,
SCIsTight:=SCIsTight,
MorseIsPerfect:=SCMorseIsPerfect,
SCMorseIsPerfect:=SCMorseIsPerfect,
Slicing:=SCSlicing,
SCSlicing:=SCSlicing,
MorseMultiplicityVector:=SCMorseMultiplicityVector,
SCMorseMultiplicityVector:=SCMorseMultiplicityVector,
MorseNumberOfCriticalPoints:=SCMorseNumberOfCriticalPoints,
SCMorseNumberOfCriticalPoints:=SCMorseNumberOfCriticalPoints,

#complex.gd
Copy:=SCCopy,
Details:=SCDetails,
SCCopy:=SCCopy,
PropertiesDropped:=SCPropertiesDropped,
SCPropertiesDropped:=SCPropertiesDropped,

#glprops.gd
ASDet:=SCAltshulerSteinberg,
AltshulerSteinberg:=SCAltshulerSteinberg,
SCAltshulerSteinberg:=SCAltshulerSteinberg,
AutomorphismGroup:=SCAutomorphismGroup,
AutomorphismGroupSize:=SCAutomorphismGroupSize,
AutomorphismGroupTransitivity:=SCAutomorphismGroupTransitivity,
AutomorphismGroupStructure:=SCAutomorphismGroupStructure,
SCAutomorphismGroup:=SCAutomorphismGroup,
AutomorphismGroupInternal:=SCAutomorphismGroupInternal,
Bd:=SCBoundary,
Boundary:=SCBoundary,
SCBoundary:=SCBoundary,
BdEx:=SCBoundaryEx,
BoundaryEx:=SCBoundaryEx,
SCBoundaryEx:=SCBoundaryEx,
ConnectedComponents:=SCConnectedComponents,
SCConnectedComponents:=SCConnectedComponents,
DehnSommervilleCheck:=SCDehnSommervilleCheck,
SCDehnSommervilleCheck:=SCDehnSommervilleCheck,
DifferenceCycles:=SCDifferenceCycles,
D:=SCDim,
SCDim:=SCDim,
Dim:=SCDim,
DualGraph:=SCDualGraph,
SCDualGraph:=SCDualGraph,
#DualGraphEx:=SCDualGraphEx, #TODO
#SCDualGraphEx:=SCDualGraphEx, #TODO
Chi:=SCEulerCharacteristic,
EulerCharacteristic:=SCEulerCharacteristic,
SCEulerCharacteristic:=SCEulerCharacteristic,
F:=SCFVector,
FVector:=SCFVector,
SCFVector:=SCFVector,
NumFaces:=SCNumFaces,
FaceLattice:=SCFaceLattice,
FaceLatticeEx:=SCFaceLatticeEx,
SCFaceLattice:=SCFaceLattice,
SCFaceLatticeEx:=SCFaceLatticeEx,
Faces:=SCFaces,
FacesEx:=SCFacesEx,
FpBetti:=SCFpBettiNumbers,
FundamentalGroup:=SCFundamentalGroup,
SCFundamentalGroup:=SCFundamentalGroup,
G:=SCGVector,
GVector:=SCGVector,
SCGVector:=SCGVector,
Generators:=SCGenerators,
SCGenerators:=SCGenerators,
GeneratorsEx:=SCGeneratorsEx,
SCGeneratorsEx:=SCGeneratorsEx,
H:=SCHVector,
HVector:=SCHVector,
SCHVector:=SCHVector,
HasBd:=SCHasBoundary,
HasBoundary:=SCHasBoundary,
SCHasBoundary:=SCHasBoundary,
HasInt:=SCHasInterior,
HasInterior:=SCHasInterior,
SCHasInterior:=SCHasInterior,
Homology:=SCHomology,
SCHomology:=SCHomology,
Incidences:=SCIncidences,
IncidencesEx:=SCIncidencesEx,
Interior:=SCInterior,
SCInterior:=SCInterior,
#InteriorEx:=SCInteriorEx, #TODO
#SCInteriorEx:=SCInteriorEx, #TODO
IsCentrallySymmetric:=SCIsCentrallySymmetric,
SCIsCentrallySymmetric:=SCIsCentrallySymmetric,
CentrallySymmetricElement:=SCCentrallySymmetricElement,
SCCentrallySymmetricElement:=SCCentrallySymmetricElement,
IsConnected:=SCIsConnected,
SCIsConnected:=SCIsConnected,
IsEmpty:=SCIsEmpty,
SCIsEmpty:=SCIsEmpty,
IsEulerianManifold:=SCIsEulerianManifold,
SCIsEulerianManifold:=SCIsEulerianManifold,
IsFlag:=SCIsFlag,
SCIsFlag:=SCIsFlag,
IsHomologySphere:=SCIsHomologySphere,
SCIsHomologySphere:=SCIsHomologySphere,
IsInKd:=SCIsInKd,
IsKNeighborly:=SCIsKNeighborly,
IsOrientable:=SCIsOrientable,
SCIsOrientable:=SCIsOrientable,
IsPM:=SCIsPseudoManifold,
IsPseudoManifold:=SCIsPseudoManifold,
SCIsPseudoManifold:=SCIsPseudoManifold,
IsPure:=SCIsPure,
SCIsPure:=SCIsPure,
IsShellable:=SCIsShellable,
SCIsShellable:=SCIsShellable,
IsStronglyConnected:=SCIsStronglyConnected,
SCIsStronglyConnected:=SCIsStronglyConnected,
MinimalNonFaces:=SCMinimalNonFaces,
SCMinimalNonFaces:=SCMinimalNonFaces,
MinimalNonFacesEx:=SCMinimalNonFacesEx,
SCMinimalNonFacesEx:=SCMinimalNonFacesEx,
Neighborliness:=SCNeighborliness,
SCNeighborliness:=SCNeighborliness,
Orientation:=SCOrientation,
SCOrientation:=SCOrientation,
Skel:=SCSkel,
SkelEx:=SCSkelEx,
SpanningTree:=SCSpanningTree,
SCSpanningTree:=SCSpanningTree,
StronglyConnectedComponents:=SCStronglyConnectedComponents,
SCStronglyConnectedComponents:=SCStronglyConnectedComponents,
TopologicalType:=SCTopologicalType,
Transitivity:=SCAutomorphismGroupTransitivity,

#homology.gd
BoundaryOperatorMatrix:=SCBoundaryOperatorMatrix,
HomologyBasis:=SCHomologyBasis,
HomologyBasisAsSimplices:=SCHomologyBasisAsSimplices,
HomologyInternal:=SCHomologyInternal,
SCHomologyInternal:=SCHomologyInternal,
CoboundaryOperatorMatrix:=SCCoboundaryOperatorMatrix,
Cohomology:=SCCohomology,
SCCohomology:=SCCohomology,
CohomologyBasis:=SCCohomologyBasis,
CohomologyBasisAsSimplices:=SCCohomologyBasisAsSimplices,
CupProduct:=SCCupProduct,
IntersectionForm:=SCIntersectionForm,
SCIntersectionForm:=SCIntersectionForm,
IntersectionFormParity:=SCIntersectionFormParity,
SCIntersectionFormParity:=SCIntersectionFormParity,
IntersectionFormDimensionality:=SCIntersectionFormDimensionality,
SCIntersectionFormDimensionality:=SCIntersectionFormDimensionality,
IntersectionFormSignature:=SCIntersectionFormSignature,
SCIntersectionFormSignature:=SCIntersectionFormSignature,

#io.gd
Load:=SCLoad,
Save:=SCSave,
ExportPolymake:=SCExportPolymake,
ExportLatexTable:=SCExportLatexTable,
ExportJavaView:=SCExportJavaView,

#operations.gd
AlexanderDual:=SCAlexanderDual,
SCAlexanderDual:=SCAlexanderDual,
CollapseGreedy:=SCCollapseGreedy,
SCCollapseGreedy:=SCCollapseGreedy,
Cone:=SCCone,
DeletedJoin:=SCDeletedJoin,
Difference:=SCDifference,
FillSphere:=SCFillSphere,
HandleAddition:=SCHandleAddition,
Intersection:=SCIntersection,
IsIsomorphic:=SCIsIsomorphic,
IsSubcomplex:=SCIsSubcomplex,
Isomorphism:=SCIsomorphism,
IsomorphismEx:=SCIsomorphismEx,
Join:=SCJoin,
Neighbors:=SCNeighbors,
NeighborsEx:=SCNeighborsEx,
Shelling:=SCShelling,
ShellingExt:=SCShellingExt,
Shellings:=SCShellings,
Span:=SCSpan,
Suspension:=SCSuspension,
Union:=SCUnion,
VertexIdentification:=SCVertexIdentification,
Wedge:=SCWedge,

#DMT.gi
HasseDiagram:=SCHasseDiagram,
IsSC:=SCIsSimplyConnected,
IsSimplyConnected:=SCIsSimplyConnected,
IsSphere:=SCIsSphere,

#lib.gd
DetermineTopologicalType:=SCLibDetermineTopologicalType,
SCDetermineTopologicalType:=SCLibDetermineTopologicalType,

#normalsurface.gd
Slicing:=SCNSSlicing,


Reference:=SCReference,
SetReference:=SCSetReference,

Date:=SCDate,
SetDate:=SCSetDate,




);




################################################################################
##<#GAPDoc Label="prophandlersns">
##
##	This section contains a table of all property handlers of a <C>SCNormalSurface</C> object.
##
## <Table Align="ll">
## <Row><Item><B>Property handler</B></Item><Item><B>Function called</B></Item></Row>
## <HorLine/>
## <Row><Item></Item><Item></Item></Row>
## <Row><Item>Betti</Item><Item><Ref Meth="SCFpBettiNumbers"/></Item></Row>
## <Row><Item>ConnectedComponents</Item><Item><Ref Meth="SCConnectedComponents"/></Item></Row>
## <Row><Item>FpBettiNumbers</Item><Item><Ref Meth="SCFpBettiNumbers"/></Item></Row>
## <Row><Item>Chi</Item><Item><Ref Meth="SCEulerCharacteristic"/></Item></Row>
## <Row><Item>EulerCharacteristic</Item><Item><Ref Meth="SCEulerCharacteristic"/></Item></Row>
## <Row><Item>Connected</Item><Item><Ref Meth="SCIsConnected"/></Item></Row>
## <Row><Item>IsConnected</Item><Item><Ref Meth="SCIsConnected"/></Item></Row>
## <Row><Item>Copy</Item><Item><Ref Meth="SCCopy"/></Item></Row>
## <Row><Item>D</Item><Item><Ref Meth="SCDim"/></Item></Row>
## <Row><Item>Dim</Item><Item><Ref Meth="SCDim"/></Item></Row>
## <Row><Item>F</Item><Item><Ref Meth="SCFVector"/></Item></Row>
## <Row><Item>FVector</Item><Item><Ref Meth="SCFVector"/></Item></Row>
## <Row><Item>FaceLattice</Item><Item><Ref Meth="SCFaceLattice"/></Item></Row>
## <Row><Item>Faces</Item><Item><Ref Meth="SCSkel"/></Item></Row>
## <Row><Item>Genus</Item><Item><Ref Meth="SCGenus"/></Item></Row>
## <Row><Item>Homology</Item><Item><Ref Meth="SCHomology"/></Item></Row>
## <Row><Item>IsEmpty</Item><Item><Ref Meth="SCIsEmpty"/></Item></Row>
## <Row><Item>Name</Item><Item><Ref Meth="SCName"/></Item></Row>
## <Row><Item>Triangulation</Item><Item><Ref Meth="SCNSTriangulation"/></Item></Row>
## <Row><Item>TopologicalType</Item><Item><Ref Meth="SCTopologicalType"/></Item></Row>
## </Table>
##		
##<#/GAPDoc>
################################################################################


#property handlers for SCNormalSurface
SCIntFunc.SCNSPropertyHandlers:=rec(

########################
## property handlers for SCPolyhedralComplexes

Facets:=SCFacets,
SCFacets:=SCFacets,
FacetsEx:=SCFacetsEx,
SCFacetsEx:=SCFacetsEx,
Vertices:=SCVertices,
SCVertices:=SCVertices,
VerticesEx:=SCVerticesEx,
SCVerticesEx:=SCVerticesEx,
Name:=SCName,
SCName:=SCName,

#labelops.gp
LabelMax:=SCLabelMax,
SCLabelMax:=SCLabelMax,
LabelMin:=SCLabelMin,
SCLabelMin:=SCLabelMin,
Labels:=SCLabels,
SCLabels:=SCLabels,
SCRelabel:=SCRelabel,
Relabel:=SCRelabel,
RelabelStandard:=SCRelabelStandard,
SCRelabelStandard:=SCRelabelStandard,
RelabelTransposition:=SCRelabelTransposition,
SCRelabelTransposition:=SCRelabelTransposition,
Rename:=SCRename,
SCRename:=SCRename,
UnlabelFace:=SCUnlabelFace,
SCUnlabelFace:=SCUnlabelFace,

SCReference:=SCReference,
Reference:=SCReference,
Ref:=SCReference,
SCSetReference:=SCSetReference,
SetReference:=SCSetReference,

#operations.gd
AntiStar:=SCAntiStar,
SCAntiStar:=SCAntiStar,
Ast:=SCAntiStar,
SCLink:=SCLink,
Link:=SCLink,
Lk:=SCLink,
SCLinks:=SCLinks,
Links:=SCLinks,
Lks:=SCLinks,
SCStar:=SCStar,
Star:=SCStar,
Str:=SCStar,
SCStars:=SCStars,
Stars:=SCStars,
Strs:=SCStars,
############################

#normalsurface.gd
 Betti:=SCFpBettiNumbers,
 FpBettiNumbers:=SCFpBettiNumbers,
 SCFpBettiNumbers:=SCFpBettiNumbers,
 Chi:=SCEulerCharacteristic,
 EulerCharacteristic:=SCEulerCharacteristic,
 SCEulerCharacteristic:=SCEulerCharacteristic,
 ConnectedComponents:=SCConnectedComponents,
 SCConnectedComponents:=SCConnectedComponents,
 Connected:=SCIsConnected,
 IsConnected:=SCIsConnected,
 SCIsConnected:=SCIsConnected,
 Copy:=SCCopy,
 SCCopy:=SCCopy,
 Dim:=SCDim,
 D:=SCDim,
 SCDim:=SCDim,
 F:=SCFVector,
 FVector:=SCFVector,
 SCFVector:=SCFVector,
 FaceLattice:=SCFaceLattice,
 SCFaceLattice:=SCFaceLattice,
 Faces:=SCSkel,
 SCFaces:=SCSkel,
 Skel:=SCSkel,
 SCSkel:=SCSkel,
 Genus:=SCGenus, 
 SCGenus:=SCGenus, 
 Homology:=SCHomology,
 SCHomology:=SCHomology,
 IsOrientable:=SCIsOrientable,
 SCIsOrientable:=SCIsOrientable,
 IsEmpty:=SCIsEmpty,
 SCIsEmpty:=SCIsEmpty,
 Triangulation:=SCNSTriangulation,
 SCNSTriangulation:=SCNSTriangulation,
 SCTopologicalType:=SCTopologicalType,
 TopologicalType:=SCTopologicalType,
);


################################################################################
##<#GAPDoc Label="prophandlerslib">
##
##	This section contains a table of all property handlers of a <C>SCLibRepository</C> object.
##
## <Table Align="ll">
## <Row><Item><B>Property handler</B></Item><Item><B>Function called</B></Item></Row>
## <HorLine/>
## <Row><Item></Item><Item></Item></Row>
## <Row><Item>Update</Item><Item><Ref Meth="SCLibUpdate"/></Item></Row>
## <Row><Item>IsLoaded</Item><Item><Ref Meth="SCLibIsLoaded"/></Item></Row>
## <Row><Item>Size</Item><Item><Ref Meth="SCLibSize"/></Item></Row>
## <Row><Item>Status</Item><Item><Ref Meth="SCLibStatus"/></Item></Row>
## <Row><Item>Flush</Item><Item><Ref Meth="SCLibFlush"/></Item></Row>
## <Row><Item>Add</Item><Item><Ref Meth="SCLibAdd"/></Item></Row>
## <Row><Item>Delete</Item><Item><Ref Meth="SCLibDelete"/></Item></Row>
## <Row><Item>All</Item><Item><Ref Meth="SCLibAllComplexes"/></Item></Row>
## <Row><Item>SearchByName</Item><Item><Ref Meth="SCLibSearchByName"/></Item></Row>
## <Row><Item>SearchByAttribute</Item><Item><Ref Meth="SCLibSearchByAttribute"/></Item></Row>
## <Row><Item>DetermineTopologicalType</Item><Item><Ref Meth="SCLibDetermineTopologicalType"/></Item></Row>
## </Table>
##		
##<#/GAPDoc>
################################################################################


#Property handlers for SCLibRepository
SCIntFunc.SCLibRepositoryPropertyHandlers:=
rec(
Update:=SCLibUpdate,
IsLoaded:=SCLibIsLoaded,
Size:=SCLibSize,
Status:=SCLibStatus,
Flush:=SCLibFlush,
Add:=SCLibAdd,
Delete:=SCLibDelete,
Load:=SCLibLoad,
All:=SCLibAllComplexes,
SearchByName:=SCLibSearchByName,
SearchByAttribute:=SCLibSearchByAttribute,
DetermineTopologicalType:=SCLibDetermineTopologicalType
);

# contains list of property handlers that only
# have one argument, i.e. can be called with complex.Property;
# instead of complex.Property(arg1,...,argn);
SCIntFunc.PropertyHandlersNoargs:=
rec(
#bistellar.gd
IsManifold:=1,
IsMovable:=1,

#morse.gd
IsTight:=1,

#complex.gd
Copy:=1,
Details:=1,
PropertiesDropped:=1,

#glprops.gd
ASDet:=1,
AltshulerSteinberg:=1,
AutomorphismGroup:=1,
AutomorphismGroupSize:=1,
AutomorphismGroupTransitivity:=1,
AutomorphismGroupStructure:=1,
AutomorphismGroupInternal:=1,
Bd:=1,
Boundary:=1,
BdEx:=1,
BoundaryEx:=1,
ConnectedComponents:=1,
SCConnectedComponents:=1,
DifferenceCycles:=1,
D:=1,
Dim:=1,
DualGraph:=1,
Chi:=1,
EulerCharacteristic:=1,
F:=1,
FVector:=1,
FaceLattice:=1,
FaceLatticeEx:=1,
Facets:=1,
SCFacets:=1,
FacetsEx:=1,
FundamentalGroup:=1,
G:=1,
GVector:=1,
Generators:=1,
GeneratorsEx:=1,
H:=1,
HVector:=1,
HasBd:=1,
HasBoundary:=1,
HasInt:=1,
HasInterior:=1,
Homology:=1,
Interior:=1,
IsCentrallySymmetric:=1,
CentrallySymmetricElement:=1,
IsConnected:=1,
IsEmpty:=1,
IsEulerianManifold:=1,
IsFlag:=1,
IsHomologySphere:=1,
IsInKd:=1,
IsKNeighborly:=1,
IsOrientable:=1,
IsPM:=1,
IsPseudoManifold:=1,
IsPure:=1,
SCIsPure:=1,
IsShellable:=1,
IsStronglyConnected:=1,
MinimalNonFaces:=1,
MinimalNonFacesEx:=1,
Name:=1,
Neighborliness:=1,
Orientation:=1,
SpanningTree:=1,
StronglyConnectedComponents:=1,
TopologicalType:=1,
Transitivity:=1,
Vertices:=1,
VerticesEx:=1,

#homology.gd
HomologyInternal:=1,
SCHomologyInternal:=1,
Cohomology:=1,
IntersectionForm:=1,
IntersectionFormParity:=1,
IntersectionFormDimensionality:=1,
IntersectionFormSignature:=1,

#labelops.gp
LabelMax:=1,
LabelMin:=1,
Labels:=1,
RelabelStandard:=1,

#operations.gd
AlexanderDual:=1,
CollapseGreedy:=1,
Cone:=1,
FillSphere:=1,
Suspension:=1,

Reference:=1,
Date:=1,

#normal surface
Chi:=1,
EulerCharacteristic:=1,
ConnComp:=1,
Connected:=1,
Copy:=1,
Dim:=1,
F:=1,
FaceLattice:=1,
Faces:=1,
Facets:=1,
Genus:=1, 
SCGenus:=1, 
Homology:=1,
IsOrientable:=1,
IsEmpty:=1,
Labels:=1,
Name:=1,
Triangulation:=1,
SCNSTriangulation:=1,
SCTopologicalType:=1,
TopologicalType:=1,
Vertices:=1,


#DMT.gi
HasseDiagram:=1,
IsSC:=1,
IsSimplyConnected:=1,
IsSphere:=1,


#library repository
IsLoaded:=1,
Size:=1,
Status:=1,
);
