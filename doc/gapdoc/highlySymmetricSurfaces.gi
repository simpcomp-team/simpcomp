################################################################################
##<#GAPDoc Label="SCNrRegularTorus">
## <ManSection>
## <Func Name="SCNrRegularTorus" Arg="n"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the number of simplicial regular maps on the torus with <M>n</M> vertices, 
## cf. <Cite Key="Brehm08EquivMapsTorus"/> for details.
## <Example><![CDATA[
## gap> SCNrRegularTorus(9);
## 1
## gap> SCNrRegularTorus(10);
## 0
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCNrChiralTori">
## <ManSection>
## <Func Name="SCNrChiralTori" Arg="n"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the number of simplicial chiral maps on the torus with <M>n</M> vertices, 
## cf. <Cite Key="Brehm08EquivMapsTorus"/> for details.
## <Example><![CDATA[
## gap> SCNrChiralTori(7);
## 1
## gap> SCNrChiralTori(343);
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesSymmetricTorus">
## <ManSection>
## <Func Name="SCSeriesSymmetricTorus" Arg="p, q"/>
## <Returns>a <K>SCSimplicialComplex</K> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the equivarient triangulation of the torus <M>\{ 3,6 \}_{(p,q)}</M> with 
## fundamental domain <M>(p,q)</M> on the <M>2</M>-dimensional integer lattice. 
## See <Cite Key="Brehm08EquivMapsTorus"/> for details.
## <Example><![CDATA[
## gap> c:=SCSeriesSymmetricTorus(2,1);
## <SimplicialComplex: {3,6}_(2,1) | dim = 2 | n = 7>
## gap> SCFVector(c);
## [ 7, 21, 14 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRegularTorus">
## <ManSection>
## <Func Name="SCRegularTorus" Arg="n"/>
## <Returns>a <K>SCSimplicialComplex</K> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of regular triangulations of the torus with <M>n</M> vertices (the
## length of the list will be at most <M>1</M>).
## See <Cite Key="Brehm08EquivMapsTorus"/> for details.
## <Example><![CDATA[
## gap> cc:=SCRegularTorus(9);
## [ <SimplicialComplex: {3,6}_(3,0) | dim = 2 | n = 9> ]
## gap> g:=SCAutomorphismGroup(cc[1]);
## Group([ (2,7)(3,4)(5,9), (1,4,2)(3,7,9)(5,8,6), (2,8,7,3,6,4)(5,9) ])
## gap> SCNumFaces(cc[1],0)*12 = Size(g);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCChiralTori">
## <ManSection>
## <Func Name="SCChiralTori" Arg="n"/>
## <Returns>a <K>SCSimplicialComplex</K> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of chiral triangulations of the torus with <M>n</M> vertices.
## See <Cite Key="Brehm08EquivMapsTorus"/> for details.
## <Example><![CDATA[
## gap> cc:=SCChiralTori(91);
## [ <SimplicialComplex: {3,6}_(9,1) | dim = 2 | n = 91>, 
##   <SimplicialComplex: {3,6}_(6,5) | dim = 2 | n = 91> ]
## gap> SCIsIsomorphic(cc[1],cc[2]);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRegularMaps">
## <ManSection>
## <Func Name="SCRegularMaps" Arg=""/>
## <Returns>a list of lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all simplicial (hyperbolic) regular maps of orientable genus up to <M>100</M>
## or non-orientable genus up to <M>200</M>. The list was generated with the help of 
## the classification of regular maps by Marston Conder <Cite Key="Conder09RegMapsOfBdChi"/>.
##
## Every regular map is given by a <M>3</M>-tuple <M>(m,g,or)</M> where <M>m</M> is the 
## vertex valence, <M>g</M> is the genus and <M>or</M> is a boolean stating if the
## map is orientable or not.
##
## Use the <M>3</M>-tuples of the list together with <Ref Func="SCRegularMap"/> 
## to get the corresponding triangulations.
## <M>g</M>
## <Example><![CDATA[
## gap> ll:=SCRegularMaps(){[1..10]};
## [ [ 7, 3, true ], [ 7, 7, true ], [ 7, 8, false ], [ 7, 14, true ], 
##   [ 7, 15, false ], [ 7, 147, false ], [ 8, 3, true ], [ 8, 5, true ], 
##   [ 8, 8, true ], [ 8, 9, false ] ]
## gap> c:=SCRegularMap(ll[5][1],ll[5][2],ll[5][3]);
## <SimplicialComplex: Non-orientable regular map {7,15} | dim = 2 | n = 78>
## gap> SCHomology(c);
## [ [ 0, [  ] ], [ 14, [ 2 ] ], [ 0, [  ] ] ]
## gap> SCGenerators(c);
## [ [ [ 1, 4, 7 ], 182 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRegularMap">
## <ManSection>
## <Func Name="SCRegularMap" Arg="m, g, orient"/>
## <Returns>a <K>SCSimplicialComplex</K> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the (hyperbolic) regular map of vertex valence <Arg>m</Arg>, genus <Arg>g</Arg> and orientability
## <Arg>orient</Arg> if existent and <K>fail</K> otherwise. 
##
## The triangulations were generated with the help of 
## the classification of regular maps by Marston Conder <Cite Key="Conder09RegMapsOfBdChi"/>.
##
## Use <Ref Func="SCRegularMaps"/> to get a list of all regular maps available.
## <Example><![CDATA[
## gap> SCRegularMaps(){[1..10]};
## [ [ 7, 3, true ], [ 7, 7, true ], [ 7, 8, false ], [ 7, 14, true ], 
##   [ 7, 15, false ], [ 7, 147, false ], [ 8, 3, true ], [ 8, 5, true ], 
##   [ 8, 8, true ], [ 8, 9, false ] ]
## gap> c:=SCRegularMap(7,7,true);
## <SimplicialComplex: Orientable regular map {7,7} | dim = 2 | n = 72>
## gap> g:=SCAutomorphismGroup(c);
## #I  group not listed
## C2 x PSL(2,8)
## gap> Size(g);
## 1008
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCChiralMaps">
## <ManSection>
## <Func Name="SCChiralMaps" Arg=""/>
## <Returns>a list of lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all simplicial (hyperbolic) chiral maps of orientable genus up to <M>100</M>.
## The list was generated with the help of 
## the classification of regular maps by Marston Conder <Cite Key="Conder09RegMapsOfBdChi"/>.
##
## Every chiral map is given by a <M>2</M>-tuple <M>(m,g)</M> where <M>m</M> is the 
## vertex valence and <M>g</M> is the genus of the map.
##
## Use the <M>2</M>-tuples of the list together with <Ref Func="SCChiralMap"/> 
## to get the corresponding triangulations.
## <Example><![CDATA[
## gap> ll:=SCChiralMaps();
## [ [ 7, 17 ], [ 8, 10 ], [ 8, 28 ], [ 8, 37 ], [ 8, 46 ], [ 8, 82 ], 
##   [ 9, 43 ], [ 10, 73 ], [ 12, 22 ], [ 12, 33 ], [ 12, 40 ], [ 12, 51 ], 
##   [ 12, 58 ], [ 12, 64 ], [ 12, 85 ], [ 12, 94 ], [ 12, 97 ], [ 18, 28 ] ]
## gap> c:=SCChiralMap(ll[18][1],ll[18][2]);
## <SimplicialComplex: Chiral map {18,28} | dim = 2 | n = 27>
## gap> SCHomology(c);
## [ [ 0, [  ] ], [ 56, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCChiralMap">
## <ManSection>
## <Func Name="SCChiralMap" Arg="m,g"/>
## <Returns>a <K>SCSimplicialComplex</K> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the (hyperbolic) chiral map of vertex valence <Arg>m</Arg> and genus <Arg>g</Arg> if existent and
## <K>fail</K> otherwise. 
##
## The list was generated with the help of 
## the classification of regular maps by Marston Conder <Cite Key="Conder09RegMapsOfBdChi"/>.
##
## Use <Ref Func="SCChiralMaps"/> to get a list of all
## chiral maps available.
## <Example><![CDATA[
## gap> SCChiralMaps();
## [ [ 7, 17 ], [ 8, 10 ], [ 8, 28 ], [ 8, 37 ], [ 8, 46 ], [ 8, 82 ], 
##   [ 9, 43 ], [ 10, 73 ], [ 12, 22 ], [ 12, 33 ], [ 12, 40 ], [ 12, 51 ], 
##   [ 12, 58 ], [ 12, 64 ], [ 12, 85 ], [ 12, 94 ], [ 12, 97 ], [ 18, 28 ] ]
## gap> c:=SCChiralMap(8,10);
## <SimplicialComplex: Chiral map {8,10} | dim = 2 | n = 54>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 20, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
