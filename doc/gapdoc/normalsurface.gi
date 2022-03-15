################################################################################
##
##  simpcomp / normalsurface.gi
##
##  Normal surfaces
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="NSOpPlusSCInt">
## <ManSection>
## <Meth Name="Operation + (SCNormalSurface, Integer)" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Positively shifts the vertex labels of <Arg>complex</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>) by the amount specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;
## gap> sl.Facets;                                    
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl + 2;;                                  
## gap> sl.Facets;  
## [ [ [ 3, 4 ], [ 3, 5 ], [ 3, 6 ] ], [ [ 3, 4 ], [ 3, 5 ], [ 3, 7 ] ], 
##   [ [ 3, 4 ], [ 3, 6 ], [ 3, 7 ] ], [ [ 3, 5 ], [ 3, 6 ], [ 3, 7 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="NSOpMinusSCInt">
## <ManSection>
## <Meth Name="Operation - (SCNormalSurface, Integer)" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Negatively shifts the vertex labels of <Arg>complex</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>) by the amount specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;
## gap> sl.Facets;                                    
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl - 2;;                                  
## gap> sl.Facets;  
## [ [ [ -1, 0 ], [ -1, 1 ], [ -1, 2 ] ], [ [ -1, 0 ], [ -1, 1 ], [ -1, 3 ] ], 
##   [ [ -1, 0 ], [ -1, 2 ], [ -1, 3 ] ], [ [ -1, 1 ], [ -1, 2 ], [ -1, 3 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="Operation * (SCNormalSurface, Integer)">
## <ManSection>
## <Meth Name="Operation * (SCNormalSurface, Integer" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Multiplies the vertex labels of <Arg>complex</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>) with the integer specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;
## gap> sl.Facets;                                    
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl * 2;;                                  
## gap> sl.Facets;  
## [ [ [ 2, 4 ], [ 2, 6 ], [ 2, 8 ] ], [ [ 2, 4 ], [ 2, 6 ], [ 2, 10 ] ], 
##   [ [ 2, 4 ], [ 2, 8 ], [ 2, 10 ] ], [ [ 2, 6 ], [ 2, 8 ], [ 2, 10 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="NSOpModSCInt">
## <ManSection>
## <Meth Name="Operation mod (SCNormalSurface, Integer)" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Takes all vertex labels of <Arg>complex</Arg> modulo the value specified in <Arg>value</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>). Warning: this might result in different vertices being assigned the same label or even invalid facet lists, so be careful.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;    
## gap> sl.Facets;
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl mod 2;;
## gap> sl.Facets;    
## [ [ [ 1, 0 ], [ 1, 0 ], [ 1, 1 ] ], [ [ 1, 0 ], [ 1, 0 ], [ 1, 1 ] ], 
##   [ [ 1, 0 ], [ 1, 1 ], [ 1, 1 ] ], [ [ 1, 0 ], [ 1, 1 ], [ 1, 1 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="NSOpUnionSCSC">
## <ManSection>
## <Meth Name="Operation Union (SCNormalSurface, SCNormalSurface)" Arg="complex1, complex2"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the union of two discrete normal surfaces by calling <Ref Meth="SCUnion"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F = [ 10, 35, 50, 25 ]");
## [ [ 19, "S^3 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> sl1:=SCNSSlicing(c,[[1,3,5,7,9],[2,4,6,8,10]]);;
## gap> sl2:=sl1+10;;
## gap> SCTopologicalType(sl1);
## "T^2"
## gap> sl3:=Union(sl1,sl2);;
## gap> SCTopologicalType(sl3);
## "T^2 U T^2"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSFromFacets">
## <ManSection>
## <Meth Name="SCNSFromFacets" Arg="facets"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructor for a discrete normal surface from a facet list, see <Ref Meth="SCFromFacets"/> for details.
## <Example><![CDATA[
## gap> sl:=SCNSFromFacets([[1,2,3],[1,2,4,5],[1,3,4,6],[2,3,5,6],[4,5,6]]);
## <NormalSurface: unnamed complex 114 | dim = 2>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNS">
## <ManSection>
## <Meth Name="SCNS" Arg="facets"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Internally calls <Ref Meth="SCNSFromFacets"/>.
## <Example><![CDATA[
## gap> sl:=SCNS([[1,2,3],[1,2,4,5],[1,3,4,6],[2,3,5,6],[4,5,6]]);
## <NormalSurface: unnamed complex 115 | dim = 2>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
##print simplicial complex info
################################################################################
##<#GAPDoc Label="SCNSCopy">
## <ManSection>
## <Meth Name="SCCopy" Arg="complex"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Copies a &GAP; object of type <C>SCNormalSurface</C> (cf. <Ref Meth="SCCopy"/>).
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);
## <NormalSurface: slicing [ [ 1 ], [ 2, 3, 4, 5 ] ] of S^3_5 | dim = 2>
## gap> sl_2:=SCCopy(sl);                          
## <NormalSurface: slicing [ [ 1 ], [ 2, 3, 4, 5 ] ] of S^3_5 | dim = 2>
## gap> IsIdenticalObj(sl,sl_2);                     
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSEmpty">
## <ManSection>
## <Func Name="SCNSEmpty" Arg=""/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates an empty complex (of dimension <M>-1</M>), i. e. an object of type <C>SCNormalSurface</C> with empty facet list.
## <Example><![CDATA[
## gap> SCNSEmpty();
## <NormalSurface: empty normal surface | dim = -1>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSDim">
## <ManSection>
## <Meth Name="SCDim" Arg="sl"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dimension of a discrete normal surface (which is always <M>2</M> if the slicing <Arg>sl</Arg> is not empty).
## <Example><![CDATA[
## gap> sl:=SCNSEmpty();;                                                    
## gap> SCDim(sl);                                                         
## -1
## gap> sl:=SCNSFromFacets([[1,2,3],[1,2,4,5],[1,3,4,6],[2,3,5,6],[4,5,6]]);;
## gap> SCDim(sl);                                                         
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSFVector">
## <ManSection>
## <Meth Name="SCFVector" Arg="sl"/>
## <Returns>a <M>1</M>, <M>3</M> or <M>4</M> tuple of (non-negative) integer values upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of a discrete normal surface, i. e. the number of vertices, edges, triangles and quadrilaterals of <Arg>sl</Arg>, cf. <Ref Meth="SCFVector"/>.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2xS^1");;
## gap> c:=SCLib.Load(list[1][1]);;             
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);;
## gap> SCFVector(sl);                 
## [ 20, 40, 16, 8 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSEulerCharacteristic">
## <ManSection>
## <Meth Name="SCEulerCharacteristic" Arg="sl"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Euler characteristic of a discrete normal surface <Arg>sl</Arg>, cf. <Ref Meth="SCEulerCharacteristic"/>.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2xS^1");;  
## gap> c:=SCLib.Load(list[1][1]);;             
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);;
## gap> SCEulerCharacteristic(sl);                 
## 4
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSGenus">
## <ManSection>
## <Meth Name="SCGenus" Arg="sl"/>
## <Returns>a non-negative integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the genus of a discrete normal surface <Arg>sl</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;               
## gap> c.F;                               
## [ 27, 298, 542, 271 ]
## gap> sl:=SCNSSlicing(c,[[1..12],[13..27]]);;
## gap> SCIsConnected(sl);
## true
## gap> SCGenus(sl);                     
## 7
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSIsEmpty">
## <ManSection>
## <Meth Name="SCIsEmpty" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a normal surface <Arg>complex</Arg> is the empty complex, i. e. a <C>SCNormalSurface</C> object with empty facet list.
## <Example><![CDATA[
## gap> sl:=SCNS([]);;
## gap> SCIsEmpty(sl);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSUnion">
## <ManSection>
## <Meth Name="SCUnion" Arg="complex1, complex2"/>
## <Returns>normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the union of two normal surfaces <Arg>complex1</Arg> and <Arg>complex2</Arg> as the normal surface formed by the union of their facet sets. The two arguments are not altered. Note: for the union process the vertex labelings of the complexes are taken into account, see also <Ref Meth="Operation Union (SCNormalSurface, SCNormalSurface)" />. Facets occurring in both arguments are treated as one facet in the new complex.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByAttribute("Dim=3 and F[1]=10");;
## gap> c:=SCLib.Load(list[1][1]);
## <SimplicialComplex: S^3 (VT) | dim = 3 | n = 10>
## gap> sl1:=SCNSSlicing(c,[[1..5],[6..10]]);;
## gap> sl2:=sl1+10;;
## gap> sl3:=SCUnion(sl1,sl2);;
## gap> SCTopologicalType(sl3);
## "S^2 U S^2"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSIsConnected">
## <ManSection>
## <Meth Name="SCIsConnected" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a normal surface <Arg>complex</Arg> is connected.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByAttribute("Dim=3 and F[1]=10");;
## gap> c:=SCLib.Load(list[1][1]);
## <SimplicialComplex: S^3 (VT) | dim = 3 | n = 10>
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);
## <NormalSurface: slicing [ [ 1, 2, 3, 4, 5 ], [ 6, 7, 8, 9, 10 ] ] of S^3 (VT) \
## | dim = 2>
## gap> SCIsConnected(sl);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSConnectedComponents">
## <ManSection>
## <Meth Name="SCConnectedComponents" Arg="complex"/>
## <Returns> a list of simplicial complexes of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all connected components of an arbitrary normal surface.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdCrossPolytope(4),[[1,2],[3..8]]);
## <NormalSurface: slicing [ [ 1, 2 ], [ 3, 4, 5, 6, 7, 8 ] ] of Bd(\beta^4) | di\
## m = 2>
## gap> cc:=SCConnectedComponents(sl);
## [ <NormalSurface: Connected component #1 of slicing [ [ 1, 2 ], [ 3, 4, 5, 6, \
## 7, 8 ] ] of Bd(\beta^4) | dim = 2>, 
##   <NormalSurface: Connected component #2 of slicing [ [ 1, 2 ], [ 3, 4, 5, 6, \
## 7, 8 ] ] of Bd(\beta^4) | dim = 2> ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>                                         
################################################################################
################################################################################
##<#GAPDoc Label="SCNSSkelEx">
## <ManSection>
## <Meth Name="SCSkelEx" Arg="sl,k"/>
## <Returns>a face list (of <Arg>k+1</Arg>tuples) or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all faces of cardinality <Arg>k+1</Arg> in the standard labeling: <Arg>k</Arg> <M>= 0</M> computes the vertices,  <Arg>k</Arg> <M>= 1</M> computes the edges,  <Arg>k</Arg> <M>= 2</M> computes the triangles,  <Arg>k</Arg> <M>= 3</M> computes the quadrilaterals.<P/>
## 
## If <Arg>k</Arg> is a list (necessarily a sublist of <C>[ 0,1,2,3 ]</C>) all faces of all cardinalities contained in <Arg>k</Arg> are computed.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkelEx(sl,1);                            
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkelEx(sl,3);                            
## [  ]
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCSkelEx(sl,3);                            
## [ [ 1, 2, 4, 5 ], [ 1, 3, 4, 6 ], [ 2, 3, 5, 6 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSSkel">
## <ManSection>
## <Meth Name="SCSkel" Arg="sl,k"/>
## <Returns>a face list (of <Arg>k+1</Arg>tuples) or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all faces of cardinality <Arg>k+1</Arg> in the original labeling: <Arg>k</Arg> <M>= 0</M> computes the vertices,  <Arg>k</Arg> <M>= 1</M> computes the edges,  <Arg>k</Arg> <M>= 2</M> computes the triangles,  <Arg>k</Arg> <M>= 3</M> computes the quadrilaterals.<P/>
## 
## If <Arg>k</Arg> is a list (necessarily a sublist of <C>[ 0,1,2,3 ]</C>) all faces of all cardinalities contained in <Arg>k</Arg> are computed.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkel(sl,1);                            
## [ [ [ 1, 2 ], [ 1, 3 ] ], [ [ 1, 2 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 5 ] ], 
##   [ [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 3 ], [ 1, 5 ] ], [ [ 1, 4 ], [ 1, 5 ] ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkel(sl,3);                            
## [  ]
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCSkelEx(sl,3);                            
## [ [ 1, 2, 4, 5 ], [ 1, 3, 4, 6 ], [ 2, 3, 5, 6 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSFaceLatticeEx">
## <ManSection>
## <Meth Name="SCFaceLatticeEx" Arg="complex"/>
## <Returns>a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the face lattice of a discrete normal surface <Arg>sl</Arg> in the standard labeling. Triangles and quadrilaterals are stored separately (cf. <Ref Meth="SCSkelEx" />).
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCFaceLatticeEx(sl);                            
## [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 5 ], [ 3, 6 ], [ 4, 5 ], 
##       [ 4, 6 ], [ 5, 6 ] ], [ [ 1, 2, 3 ], [ 4, 5, 6 ] ], 
##   [ [ 1, 2, 4, 5 ], [ 1, 3, 4, 6 ], [ 2, 3, 5, 6 ] ] ]
## gap> sl.F;
## [ 6, 9, 2, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSFaceLattice">
## <ManSection>
## <Meth Name="SCFaceLattice" Arg="complex"/>
## <Returns>a list of facet lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the face lattice of a discrete normal surface <Arg>sl</Arg> in the original labeling. Triangles and quadrilaterals are stored separately (cf. <Ref Meth="SCSkel" />).
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCFaceLattice(sl);                            
## [ [ [ [ 1, 3 ] ], [ [ 1, 4 ] ], [ [ 1, 5 ] ], [ [ 2, 3 ] ], [ [ 2, 4 ] ], 
##       [ [ 2, 5 ] ] ], 
##   [ [ [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 3 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 2, 3 ] ], 
##       [ [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 4 ], [ 2, 4 ] ], [ [ 1, 5 ], [ 2, 5 ] ], 
##       [ [ 2, 3 ], [ 2, 4 ] ], [ [ 2, 3 ], [ 2, 5 ] ], [ [ 2, 4 ], [ 2, 5 ] ] ]
##     , [ [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 2, 3 ], [ 2, 4 ], [ 2, 5 ] ] ], 
##   [ [ [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ] ], 
##       [ [ 1, 3 ], [ 1, 5 ], [ 2, 3 ], [ 2, 5 ] ], 
##       [ [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 5 ] ] ] ]
## gap> sl.F;
## [ 6, 9, 2, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSTriangulation">
## <ManSection>
## <Meth Name="SCNSTriangulation" Arg="sl"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a simplicial subdivision of a slicing <Arg>sl</Arg> without introducing new vertices. The subdivision is stored as a property of <Arg>sl</Arg> and thus is returned as an immutable object. Note that symmetry may be lost during the computation. 
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F=[ 10, 35, 50, 25 ]");
## [ [ 19, "S^3 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> sl:=SCNSSlicing(c,[[1,3,5,7,9],[2,4,6,8,10]]);;
## gap> sl.F; 
## [ 25, 50, 0, 25 ]
## gap> sc:=SCNSTriangulation(sl);;
## gap> sc.F;
## [ 25, 75, 50 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSHomology">
## <ManSection>
## <Meth Name="SCHomology" Arg="sl"/>
## <Returns>a list of homology groups upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the homology of a slicing <Arg>sl</Arg>. Internally, <Arg>sl</Arg> is triangulated (cf. <Ref Meth="SCNSTriangulation"/>) and simplicial homology is computed via <Ref Meth="SCHomology"/> using the triangulation.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");       
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c.F;
## [ 27, 298, 542, 271 ]
## gap> sl:=SCNSSlicing(c,[[1..12],[13..27]]);;   
## gap> sl.Homology;
## [ [ 0, [  ] ], [ 14, [  ] ], [ 1, [  ] ] ]
## gap> sl:=SCNSSlicing(c,[[1..13],[14..27]]);;
## gap> sl.Homology;                       
## [ [ 1, [  ] ], [ 14, [  ] ], [ 2, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSFpBettiNumbers">
## <ManSection>
## <Meth Name="SCFpBettiNumbers" Arg="sl,p"/>
## <Returns>a list of non-negative integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Betti numbers modulo <Arg>p</Arg> of a slicing <Arg>sl</Arg>. Internally, <Arg>sl</Arg> is triangulated (using <Ref Meth="SCNSTriangulation"/>) and the Betti numbers are computed via <Ref Meth="SCFpBettiNumbers"/> using the triangulation.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");       
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c.F;
## [ 27, 298, 542, 271 ]
## gap> sl:=SCNSSlicing(c,[[1..13],[14..27]]);;
## gap> SCFpBettiNumbers(sl,2);
## [ 2, 14, 2 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSTopologicalType">
## <ManSection>
## <Meth Name="SCTopologicalType" Arg="sl"/>
## <Returns>a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Determines the topological type of <Arg>sl</Arg> via the classification theorem for closed compact surfaces. If <Arg>sl</Arg> is not connected, the topological type of each connected component is computed.<P/>
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");      
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c.F;
## [ 27, 298, 542, 271 ]
## gap> for i in [1..26] do sl:=SCNSSlicing(c,[[1..i],[i+1..27]]); Print(sl.TopologicalType,"\n"); od;                                           
## S^2
## S^2
## S^2
## S^2
## S^2 U S^2
## S^2 U S^2
## S^2
## (T^2)#3
## (T^2)#5
## (T^2)#4
## (T^2)#3
## (T^2)#7
## (T^2)#7 U S^2
## (T^2)#7 U S^2
## (T^2)#7 U S^2
## (T^2)#8 U S^2
## (T^2)#7 U S^2
## (T^2)#8
## (T^2)#6
## (T^2)#6
## (T^2)#5
## (T^2)#3
## (T^2)#2
## T^2
## S^2
## S^2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSIsOrientable">
## <ManSection>
## <Meth Name="SCIsOrientable" Arg="sl"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a discrete normal surface <Arg>sl</Arg> is orientable.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> sl:=SCNSSlicing(c,[[1,2],[3,4,5]]);
## <NormalSurface: slicing [ [ 1, 2 ], [ 3, 4, 5 ] ] of S^3_5 | dim = 2>
## gap> SCIsOrientable(sl);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNSSlicing">
## <ManSection>
## <Func Name="SCNSSlicing" Arg="complex,slicing"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a slicing defined by a partition <Arg>slicing</Arg> of the set of vertices of the <M>3</M>-dimensional combinatorial pseudomanifold  <Arg>complex</Arg>. In particular, <Arg>slicing</Arg> has to be a pair of lists of vertex labels and has to contain all vertex labels of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F=[ 10, 35, 50, 25 ]");
## [ [ 19, "S^3 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;                       
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);    
## <NormalSurface: slicing [ [ 1, 2, 3, 4, 5 ], [ 6, 7, 8, 9, 10 ] ] of S^3 (VT) \
## | dim = 2>
## gap> sl.Facets;
## [ [ [ 1, 6 ], [ 1, 8 ], [ 1, 9 ] ], [ [ 1, 6 ], [ 1, 8 ], [ 3, 6 ], [ 3, 8 ] ]
##     , [ [ 1, 6 ], [ 1, 9 ], [ 4, 6 ], [ 4, 9 ] ], 
##   [ [ 1, 6 ], [ 3, 6 ], [ 4, 6 ] ], [ [ 1, 8 ], [ 1, 9 ], [ 1, 10 ] ], 
##   [ [ 1, 8 ], [ 1, 10 ], [ 3, 8 ], [ 3, 10 ] ], 
##   [ [ 1, 9 ], [ 1, 10 ], [ 2, 9 ], [ 2, 10 ] ], 
##   [ [ 1, 9 ], [ 2, 9 ], [ 4, 9 ] ], [ [ 1, 10 ], [ 2, 10 ], [ 3, 10 ] ], 
##   [ [ 2, 7 ], [ 2, 9 ], [ 2, 10 ] ], 
##   [ [ 2, 7 ], [ 2, 9 ], [ 4, 7 ], [ 4, 9 ] ], 
##   [ [ 2, 7 ], [ 2, 10 ], [ 5, 7 ], [ 5, 10 ] ], 
##   [ [ 2, 7 ], [ 4, 7 ], [ 5, 7 ] ], [ [ 2, 10 ], [ 3, 10 ], [ 5, 10 ] ], 
##   [ [ 3, 6 ], [ 3, 8 ], [ 5, 6 ], [ 5, 8 ] ], [ [ 3, 6 ], [ 4, 6 ], [ 5, 6 ] ]
##     , [ [ 3, 8 ], [ 3, 10 ], [ 5, 8 ], [ 5, 10 ] ], 
##   [ [ 4, 6 ], [ 4, 7 ], [ 4, 9 ] ], [ [ 4, 6 ], [ 4, 7 ], [ 5, 6 ], [ 5, 7 ] ]
##     , [ [ 5, 6 ], [ 5, 7 ], [ 5, 8 ] ], [ [ 5, 7 ], [ 5, 8 ], [ 5, 10 ] ] ]
## gap> sl:=SCNSSlicing(c,[[1,3,5,7,9],[2,4,6,8,10]]);    
## <NormalSurface: slicing [ [ 1, 3, 5, 7, 9 ], [ 2, 4, 6, 8, 10 ] ] of S^3 (VT) \
## | dim = 2>
## gap> sl.Facets;                           
## [ [ [ 1, 2 ], [ 1, 4 ], [ 3, 2 ], [ 3, 4 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 9, 2 ], [ 9, 4 ] ], 
##   [ [ 1, 2 ], [ 1, 10 ], [ 3, 2 ], [ 3, 10 ] ], 
##   [ [ 1, 2 ], [ 1, 10 ], [ 9, 2 ], [ 9, 10 ] ], 
##   [ [ 1, 4 ], [ 1, 6 ], [ 3, 4 ], [ 3, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 6 ], [ 9, 4 ], [ 9, 6 ] ], 
##   [ [ 1, 6 ], [ 1, 8 ], [ 3, 6 ], [ 3, 8 ] ], 
##   [ [ 1, 6 ], [ 1, 8 ], [ 9, 6 ], [ 9, 8 ] ], 
##   [ [ 1, 8 ], [ 1, 10 ], [ 3, 8 ], [ 3, 10 ] ], 
##   [ [ 1, 8 ], [ 1, 10 ], [ 9, 8 ], [ 9, 10 ] ], 
##   [ [ 3, 2 ], [ 3, 4 ], [ 5, 2 ], [ 5, 4 ] ], 
##   [ [ 3, 2 ], [ 3, 10 ], [ 5, 2 ], [ 5, 10 ] ], 
##   [ [ 3, 4 ], [ 3, 6 ], [ 5, 4 ], [ 5, 6 ] ], 
##   [ [ 3, 6 ], [ 3, 8 ], [ 5, 6 ], [ 5, 8 ] ], 
##   [ [ 3, 8 ], [ 3, 10 ], [ 5, 8 ], [ 5, 10 ] ], 
##   [ [ 5, 2 ], [ 5, 4 ], [ 7, 2 ], [ 7, 4 ] ], 
##   [ [ 5, 2 ], [ 5, 10 ], [ 7, 2 ], [ 7, 10 ] ], 
##   [ [ 5, 4 ], [ 5, 6 ], [ 7, 4 ], [ 7, 6 ] ], 
##   [ [ 5, 6 ], [ 5, 8 ], [ 7, 6 ], [ 7, 8 ] ], 
##   [ [ 5, 8 ], [ 5, 10 ], [ 7, 8 ], [ 7, 10 ] ], 
##   [ [ 7, 2 ], [ 7, 4 ], [ 9, 2 ], [ 9, 4 ] ], 
##   [ [ 7, 2 ], [ 7, 10 ], [ 9, 2 ], [ 9, 10 ] ], 
##   [ [ 7, 4 ], [ 7, 6 ], [ 9, 4 ], [ 9, 6 ] ], 
##   [ [ 7, 6 ], [ 7, 8 ], [ 9, 6 ], [ 9, 8 ] ], 
##   [ [ 7, 8 ], [ 7, 10 ], [ 9, 8 ], [ 9, 10 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
