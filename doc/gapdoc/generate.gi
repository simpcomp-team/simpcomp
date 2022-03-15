################################################################################
##
##  simpcomp / generate.gi
##
##  Generate simplicial complexes or construct them using existing
##  complexes.
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCFromGenerators">
## <ManSection>
## <Meth Name="SCFromGenerators" Arg="group, generators"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructs a simplicial complex object from the set of <Arg>generators</Arg> on which the group <Arg>group</Arg> acts, i.e. a complex which has <Arg>group</Arg> as a subgroup of the automorphism group and a facet list that consists of the <Arg>group</Arg>-orbits specified by the list of representatives passed in <Arg>generators</Arg>. Note that <Arg>group</Arg> is not stored as an attribute of the resulting complex as it might just be a subgroup of the actual automorphism group. Internally calls <C>Orbits</C> and <Ref Func="SCFromFacets" />. 
## <Example><![CDATA[
## gap> #group: AGL(1,7) of order 42
## gap> G:=Group([(2,6,5,7,3,4),(1,3,5,7,2,4,6)]);;
## gap> c:=SCFromGenerators(G,[[ 1, 2, 4 ]]);
## <SimplicialComplex: complex from generators under unknown group | dim = 2 | n \
## = 7>
## gap> SCLib.DetermineTopologicalType(c);
## <SimplicialComplex: complex from generators under unknown group | dim = 2 | n \
## = 7>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFromFacets">
## <ManSection>
## <Meth Name="SCFromFacets" Arg="facets"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructs a simplicial complex object from the given facet list. The facet list <Arg>facets</Arg> has to be a duplicate free list (or set) which consists of duplicate free entries, which are in turn lists or sets. For the vertex labels (i. e. the entries of the list items of <Arg>facets</Arg>) an ordering via the less-operator has to be defined. Following Section 4.11 of the &GAP; manual this is the case for objects of the following families: rationals <C>IsRat</C>, cyclotomics <C>IsCyclotomic</C>, finite field elements <C>IsFFE</C>, permutations <C>IsPerm</C>, booleans <C>IsBool</C>, characters <C>IsChar</C> and lists (strings) <C>IsList</C>.<P/>
## Internally the vertices are mapped to the standard labeling <M>1..n</M>, where <M>n</M> is the number of vertices of the complex and the vertex labels of the original complex are stored in the property ''VertexLabels'', see <Ref Func="SCLabels" /> and the <C>SCRelabel..</C> functions like <Ref Func="SCRelabel" /> or <Ref Func="SCRelabelStandard" />. 
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,5], [1,4,5], [1,4,6], [2,3,5], [3,4,6], [3,5,6]]);
## <SimplicialComplex: unnamed complex 12 | dim = 2 | n = 6>
## gap> c:=SCFromFacets([["a","b","c"], ["a","b",1], ["a","c",1], ["b","c",1]]);
## <SimplicialComplex: unnamed complex 13 | dim = 2 | n = 4>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SC">
## <ManSection>
## <Meth Name="SC" Arg="facets"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## A shorter function to create a simplicial complex from a facet list, just calls <Ref Func="SCFromFacets" Style="Text"/>(<Arg>facets</Arg>).
## <Example><![CDATA[
## gap> c:=SC(Combinations([1..6],5));
## <SimplicialComplex: unnamed complex 14 | dim = 4 | n = 6>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCEmpty">
## <ManSection>
## <Func Name="SCEmpty" Arg=""/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates an empty complex (of dimension <M>-1</M>), i. e. a <C>SCSimplicialComplex</C> object with empty facet list.
## <Example><![CDATA[
## gap> SCEmpty();
## <SimplicialComplex: empty complex | dim = -1 | n = 0>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
##########################
## <#GAPDoc Label="SCFVectorBdCrossPolytope">
## <ManSection>
## <Func Name="SCFVectorBdCrossPolytope" Arg="d"/>
## <Returns> a list of integers of size <C>d + 1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the <M>d</M>-dimensional cross polytope without generating the underlying complex.  
## <Example><![CDATA[
## gap> SCFVectorBdCrossPolytope(50);
## [ 100, 4900, 156800, 3684800, 67800320, 1017004800, 12785203200, 
##   137440934400, 1282782054400, 10518812846080, 76500457062400, 
##   497252970905600, 2907017368371200, 15365663232819200, 73755183517532160, 
##   322678927889203200, 1290715711556812800, 4732624275708313600, 
##   15941471244491161600, 49418560857922600960, 141195888165493145600, 
##   372243705163572838400, 906332499528699084800, 2039248123939572940800, 
##   4241636097794311716864, 8156992495758291763200, 14501319992459185356800, 
##   23823597130468661657600, 36146147370366245273600, 50604606318512743383040, 
##   65296266217435797913600, 77539316133205010022400, 84588344872587283660800, 
##   84588344872587283660800, 77337915312079802204160, 64448262760066501836800, 
##   48771658304915190579200, 33370081998099867238400, 20535435075753764454400, 
##   11294489291664570449920, 5509506971543692902400, 2361217273518725529600, 
##   878592473867432755200, 279552150776001331200, 74547240206933688320, 
##   16205921784116019200, 2758454771764428800, 344806846470553600, 
##   28147497671065600, 1125899906842624 ]
## ]]></Example>
## </Description>
## </ManSection>
## <#/GAPDoc>
##########################
##########################
## <#GAPDoc Label="SCFVectorBdCyclicPolytope">
## <ManSection>
## <Func Name="SCFVectorBdCyclicPolytope" Arg="d, n"/>
## <Returns> a list of integers of size <C>d+1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the <Arg>d</Arg>-dimensional cyclic polytope on <Arg>n</Arg> vertices, <M>n\geq d+2</M>, without generating the underlying complex.  
## <Example><![CDATA[
## gap> SCFVectorBdCyclicPolytope(25,198); 
## [ 198, 19503, 1274196, 62117055, 2410141734, 77526225777, 2126433621312, 
##   50768602708824, 1071781612741840, 20256672480820776, 346204947854027808, 
##   5395027104058600008, 48354596155522298656, 262068846498922699590, 
##   940938105142239825104, 2379003007642628680027, 4396097923113038784642, 
##   6062663500381642763609, 6294919173643129209180, 4911378208855785427761, 
##   2840750019404460890298, 1183225500922302444568, 335951678686835900832, 
##   58265626173398052500, 4661250093871844200 ]
## ]]></Example>
## </Description>
## </ManSection>
## <#/GAPDoc>
##########################
################################################################################
##<#GAPDoc Label="SCFVectorBdSimplex">
## <ManSection>
## <Func Name="SCFVectorBdSimplex" Arg="d"/>
## <Returns> a list of integers of size <C>d + 1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the <M>d</M>-simplex without generating the underlying complex.  
## <Example><![CDATA[
## gap> SCFVectorBdSimplex(100);
## [ 101, 5050, 166650, 4082925, 79208745, 1267339920, 17199613200, 
##   202095455100, 2088319702700, 19212541264840, 158940114100040, 
##   1192050855750300, 8160963550905900, 51297485177122800, 297525414027312240, 
##   1599199100396803290, 7995995501984016450, 37314645675925410100, 
##   163006083742200475700, 668324943343021950370, 2577824781465941808570, 
##   9373908296239788394800, 32197337191432316660400, 104641345872155029146300, 
##   322295345286237489770604, 942094086221309585483304, 
##   2616928017281415515231400, 6916166902815169575968700, 
##   17409661513983013070541900, 41783187633559231369300560, 
##   95696978128474368620010960, 209337139656037681356273975, 
##   437704928371715151926754675, 875409856743430303853509350, 
##   1675784582908852295948146470, 3072271735332895875904935195, 
##   5397234129638871133346507775, 9090078534128625066688855200, 
##   14683973016669317415420458400, 22760158175837441993901710520, 
##   33862674359172779551902544920, 48375249084532542217003635600, 
##   66375341767149302111702662800, 87494768693060443692698964600, 
##   110826707011209895344085355160, 134919469404951176940625649760, 
##   157884485473879036845412994400, 177620046158113916451089618700, 
##   192119641762857909630770403900, 199804427433372226016001220056, 
##   199804427433372226016001220056, 192119641762857909630770403900, 
##   177620046158113916451089618700, 157884485473879036845412994400, 
##   134919469404951176940625649760, 110826707011209895344085355160, 
##   87494768693060443692698964600, 66375341767149302111702662800, 
##   48375249084532542217003635600, 33862674359172779551902544920, 
##   22760158175837441993901710520, 14683973016669317415420458400, 
##   9090078534128625066688855200, 5397234129638871133346507775, 
##   3072271735332895875904935195, 1675784582908852295948146470, 
##   875409856743430303853509350, 437704928371715151926754675, 
##   209337139656037681356273975, 95696978128474368620010960, 
##   41783187633559231369300560, 17409661513983013070541900, 
##   6916166902815169575968700, 2616928017281415515231400, 
##   942094086221309585483304, 322295345286237489770604, 
##   104641345872155029146300, 32197337191432316660400, 9373908296239788394800, 
##   2577824781465941808570, 668324943343021950370, 163006083742200475700, 
##   37314645675925410100, 7995995501984016450, 1599199100396803290, 
##   297525414027312240, 51297485177122800, 8160963550905900, 1192050855750300, 
##   158940114100040, 19212541264840, 2088319702700, 202095455100, 17199613200, 
##   1267339920, 79208745, 4082925, 166650, 5050, 101 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCBdCrossPolytope">
## <ManSection>
## <Func Name="SCBdCrossPolytope" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the boundary of the <M>d</M>-dimensional cross polytope <M>\beta^{d}</M>, a centrally symmetric combinatorial <M>d-1</M>-sphere.
## <Example><![CDATA[
## gap> SCBdCrossPolytope(3); # the octahedron
## <SimplicialComplex: Bd(\beta^3) | dim = 2 | n = 6>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCBdCyclicPolytope">
## <ManSection>
## <Func Name="SCBdCyclicPolytope" Arg="d, n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the boundary complex of the <Arg>d</Arg>-dimensional cyclic polytope (a combinatorial <M>d-1</M>-sphere) on <Arg>n</Arg> vertices, where <M>n\geq d+2</M>.
## <Example><![CDATA[
## gap> SCBdCyclicPolytope(3,8); 
## <SimplicialComplex: Bd(C_3(8)) | dim = 2 | n = 8>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCBdSimplex">
## <ManSection>
## <Func Name="SCBdSimplex" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the boundary of the <M>d</M>-simplex <M>\Delta^d</M>, a combinatorial <M>d-1</M>-sphere.
## <Example><![CDATA[
## gap> SCBdSimplex(5);
## <SimplicialComplex: S^4_6 | dim = 4 | n = 6>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSimplex">
## <ManSection>
## <Func Name="SCSimplex" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>d</Arg>-simplex.
## <Example><![CDATA[
## gap> SCSimplex(3);
## <SimplicialComplex: B^3_4 | dim = 3 | n = 4>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCartesianProduct">
## <ManSection>
## <Meth Name="SCCartesianProduct" Arg="complex1,complex2"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the simplicial cartesian product of <Arg>complex1</Arg> and <Arg>complex2</Arg> where  <Arg>complex1</Arg> and <Arg>complex2</Arg> are pure, simplicial complexes. The original vertex labeling of <Arg>complex1</Arg> and <Arg>complex2</Arg> is changed into the standard one. The new complex has vertex labels of type <M>[v_i, v_j]</M> where <M>v_i</M> is a vertex of <Arg>complex1</Arg> and <M>v_j</M> is a vertex of <Arg>complex2</Arg>.<P/>
## If <M>n_i</M>, <M>i=1,2</M>, are the number facets and <M>d_i</M>, <M>i=1,2</M>, are the dimensions of <Arg>complexi</Arg>, then the new complex has <M>n_1 \cdot n_2 \cdot { d_1+d_2 \choose d_1}</M> facets. The number of vertices of the new complex equals the product of the numbers of vertices of the arguments.
## <Example><![CDATA[
## gap> c1:=SCBdSimplex(2);;
## gap> c2:=SCBdSimplex(3);;
## gap> c3:=SCCartesianProduct(c1,c2);
## <SimplicialComplex: S^1_3xS^2_4 | dim = 3 | n = 12>
## gap> c3.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ]
## gap> c3.F;
## [ 12, 48, 72, 36 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCartesianPower">
## <ManSection>
## <Meth Name="SCCartesianPower" Arg="complex,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The new complex is <M>PL</M>-homeomorphic to <M>n</M> times the cartesian product of <Arg>complex</Arg>, of dimensions <M>n \cdot d</M> and has <M>f_{d}^n \cdot n \cdot \frac{2n-1}{2^{n-1}}!</M> facets where <M>d</M> denotes the dimension and <M>f_d</M> denotes the number of facets of <Arg>complex</Arg>. Note that the complex returned by the function is not the <M>n</M>-fold cartesian product <Arg>complex</Arg><M>^n</M> of <Arg>complex</Arg> (which, in general, is not simplicial) but a simplicial subdivision of <Arg>complex</Arg><M>^n</M>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(2);;
## gap> 4torus:=SCCartesianPower(c,4);
## <SimplicialComplex: (S^1_3)^4 | dim = 4 | n = 81>
## gap> 4torus.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 6, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## gap> 4torus.Chi;
## 0
## gap> 4torus.F;
## [ 81, 1215, 4050, 4860, 1944 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCConnectedSumMinus">
## <ManSection>
## <Meth Name="SCConnectedSumMinus" Arg="complex1,complex2"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a lexicographic ordering the smallest facet of both <Arg>complex1</Arg> and  <Arg>complex2</Arg> is removed and the complexes are glued together along the resulting boundaries. The bijection used to identify the vertices of the boundaries differs from the one chosen in <Ref Func="SCConnectedSum"/> by a transposition. Thus, the topological type of <C>SCConnectedSumMinus</C> is different from the one of <Ref Func="SCConnectedSum"/> whenever <Arg>complex1</Arg> and <Arg>complex2</Arg> do not allow an orientation reversing homeomorphism. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> genus2:=SCConnectedSumMinus(torus,torus);
## <SimplicialComplex: T^2 (VT)#+-T^2 (VT) | dim = 2 | n = 11>
## gap> genus2.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## gap> genus2.Chi;
## -2
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");
## [ [ 16, "CP^2 (VT)" ], [ 96, "CP^2#-CP^2" ], [ 97, "CP^2#CP^2" ], 
##   [ 185, "CP^2#(S^2xS^2)" ], [ 397, "Gaifullin CP^2" ], 
##   [ 457, "(S^3~S^1)#(CP^2)^{#5} (VT)" ] ]
## gap> cp2:=SCLib.Load(last[1][1]);;
## gap> c1:=SCConnectedSum(cp2,cp2);;
## gap> c2:=SCConnectedSumMinus(cp2,cp2);;
## gap> c1.F=c2.F;
## true
## gap> c1.ASDet=c2.ASDet;
## true
## gap> SCIsIsomorphic(c1,c2);
## false
## gap> PrintArray(SCIntersectionForm(c1));
## [ [  1,  0 ],
##   [  0,  1 ] ]
## gap> PrintArray(SCIntersectionForm(c2));
## [ [   1,   0 ],
##   [   0,  -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCConnectedSum">
## <ManSection>
## <Meth Name="SCConnectedSum" Arg="complex1,complex2"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a lexicographic ordering the smallest facet of both <Arg>complex1</Arg> and <Arg>complex2</Arg> is removed and the complexes are glued together along the resulting boundaries. The bijection used to identify the vertices of the boundaries differs from the one chosen in <Ref Func="SCConnectedSumMinus"/> by a transposition. Thus, the topological type of <C>SCConnectedSum</C> is different from the one of <Ref Func="SCConnectedSumMinus"/> whenever <Arg>complex1</Arg> and <Arg>complex2</Arg> do not allow an orientation reversing homeomorphism. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> genus2:=SCConnectedSum(torus,torus);
## <SimplicialComplex: T^2 (VT)#+-T^2 (VT) | dim = 2 | n = 11>
## gap> genus2.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## gap> genus2.Chi;
## -2
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");
## [ [ 16, "CP^2 (VT)" ], [ 96, "CP^2#-CP^2" ], [ 97, "CP^2#CP^2" ], 
##   [ 185, "CP^2#(S^2xS^2)" ], [ 397, "Gaifullin CP^2" ], 
##   [ 457, "(S^3~S^1)#(CP^2)^{#5} (VT)" ] ]
## gap> cp2:=SCLib.Load(last[1][1]);;
## gap> c1:=SCConnectedSum(cp2,cp2);;
## gap> c2:=SCConnectedSumMinus(cp2,cp2);;
## gap> c1.F=c2.F;
## true
## gap> c1.ASDet=c2.ASDet;
## true
## gap> SCIsIsomorphic(c1,c2);
## false
## gap> PrintArray(SCIntersectionForm(c1));
## [ [  1,  0 ],
##   [  0,  1 ] ]
## gap> PrintArray(SCIntersectionForm(c2));
## [ [   1,   0 ],
##   [   0,  -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCConnectedProduct">
## <ManSection>
## <Meth Name="SCConnectedProduct" Arg="complex,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <M>n \geq 2</M>, the function internally calls <M>1 \times</M> <Ref Func="SCConnectedSum"/> and <M>(n-2) \times</M> <Ref Func="SCConnectedSumMinus"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> genus10:=SCConnectedProduct(torus,10);
## <SimplicialComplex: T^2 (VT)#+-T^2 (VT)#+-T^2 (VT)#+-T^2 (VT)#+-T^2 (VT)#+-T^2\
##  (VT)#+-T^2 (VT)#+-T^2 (VT)#+-T^2 (VT)#+-T^2 (VT) | dim = 2 | n = 43>
## gap> genus10.Chi;
## -18
## gap> genus10.F;
## [ 43, 183, 122 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDifferenceCycleExpand">
## <ManSection>
## <Func Name="SCDifferenceCycleExpand" Arg="diffcycle"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <Arg>diffcycle</Arg> induces a simplex <M>\Delta = ( v_1 , \ldots , v_{n+1} )</M> by <M>v_1 = </M><Arg>diffcycle[1]</Arg>, <M>v_i = v_{i-1} + </M> <Arg>diffcycle[i]</Arg> and a cyclic group action by <M>\mathbb{Z}_{\sigma}</M> where <M>\sigma = \sum </M> <Arg>diffcycle[i]</Arg> is the modulus of <C>diffcycle</C>. The function returns the <M>\mathbb{Z}_{\sigma}</M>-orbit of <M>\Delta</M>.<P/>
## Note that modulo operations in &GAP; are often a little bit cumbersome, since all integer ranges usually start from <M>1</M>.
## <Example><![CDATA[
## gap> c:=SCDifferenceCycleExpand([1,1,2]);;
## gap> c.Facets;
## [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFromDifferenceCycles">
## <ManSection>
## <Meth Name="SCFromDifferenceCycles" Arg="diffcycles"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Creates a simplicial complex object from the list of difference cycles provided. If <Arg>diffcycles</Arg> is of length <M>1</M> the computation is equivalent to the one in <Ref Func="SCDifferenceCycleExpand"/>. Otherwise the induced modulus (the sum of all entries of a difference cycle) of all cycles has to be equal and the union of all expanded difference cycles is returned.<P/>
## A <M>n</M>-dimensional difference cycle <M>D = (d_1 : \ldots : d_{n+1})</M> induces a simplex <M>\Delta = ( v_1 , \ldots , v_{n+1} )</M> by <M>v_1 = d_1</M>, <M>v_i = v_{i-1} + d_i</M> and a cyclic group action by <M>\mathbb{Z}_{\sigma}</M> where <M>\sigma = \sum d_i</M> is the modulus of <M>D</M>. The function returns the <M>\mathbb{Z}_{\sigma}</M>-orbit of <M>\Delta</M>.<P/>
## Note that modulo operations in &GAP; are often a little bit cumbersome, since all integer ranges usually start from <M>1</M>.
## <Example><![CDATA[
## gap> c:=SCFromDifferenceCycles([[1,1,6],[2,3,3]]);;
## gap> c.F;
## [ 8, 24, 16 ]
## gap> c.Homology;
## [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
## gap> c.Chi;
## 0
## gap> c.HasBoundary;
## false
## gap> SCIsPseudoManifold(c);
## true
## gap> SCIsManifold(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDifferenceCycleCompress">
## <ManSection>
## <Func Name="SCDifferenceCycleCompress" Arg="simplex,modulus"/>
## <Returns> list with possibly duplicate entries upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## A difference cycle is returned, i. e. a list of integer values of length <M>(d+1)</M>, if <M>d</M> is the dimension of <Arg>simplex</Arg>, and a sum equal to <Arg>modulus</Arg>. In some sense this is the inverse operation of <Ref Func="SCDifferenceCycleExpand"/>.
## <Example><![CDATA[
## gap> sphere:=SCBdSimplex(4);;
## gap> gens:=SCGenerators(sphere);
## [ [ [ 1, 2, 3, 4 ], [ 5 ] ] ]
## gap> diffcycle:=SCDifferenceCycleCompress(gens[1][1],5);
## [ 1, 1, 1, 2 ]
## gap> c:=SCDifferenceCycleExpand([1,1,1,2]);;
## gap> c.Facets;
## [ [ 1, 2, 3, 4 ], [ 1, 2, 3, 5 ], [ 1, 2, 4, 5 ], [ 1, 3, 4, 5 ], 
##   [ 2, 3, 4, 5 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCStronglyConnectedComponents">
## <ManSection>
## <Meth Name="SCStronglyConnectedComponents" Arg="complex"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all strongly connected components of a pure simplicial complex.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[2,3,4],[4,5,6],[5,6,7]]);;
## gap> comps:=SCStronglyConnectedComponents(c);
## [ <SimplicialComplex: Strongly connected component #1 of unnamed complex 85 | \
## dim = 2 | n = 4>, 
##   <SimplicialComplex: Strongly connected component #2 of unnamed complex 85 | \
## dim = 2 | n = 4> ]
## gap> comps[1].Facets;
## [ [ 1, 2, 3 ], [ 2, 3, 4 ] ]
## gap> comps[2].Facets;
## [ [ 4, 5, 6 ], [ 5, 6, 7 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCConnectedComponents">
## <ManSection>
## <Meth Name="SCConnectedComponents" Arg="complex"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all connected components of an arbitrary simplicial complex.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[3,4,5],[4,5,6,7,8]]);;
## gap> SCRename(c,"connected complex");;
## gap> SCConnectedComponents(c);
## [ <SimplicialComplex: Connected component #1 of connected complex | dim = 4 | \
## n = 8> ]
## gap> c:=SC([[1,2,3],[4,5],[6,7,8]]);;
## gap> SCRename(c,"non-connected complex");;
## gap> SCConnectedComponents(c);
## [ <SimplicialComplex: Connected component #1 of non-connected complex | dim = \
## 2 | n = 3>, 
##   <SimplicialComplex: Connected component #2 of non-connected complex | dim = \
## 1 | n = 2>, 
##   <SimplicialComplex: Connected component #3 of non-connected complex | dim = \
## 2 | n = 3> ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>                                         
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesAGL">
## <ManSection>
## <Func Name="SCSeriesAGL" Arg="p"/>
## <Returns> a permutation group and a list of <M>5</M>-tuples of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## For a given prime <Arg>p</Arg> the automorphism group (AGL<M>(1,p)</M>) and the generators of all members of the series of <M>2</M>-transitive combinatorial <M>4</M>-pseudomanifolds with <Arg>p</Arg> vertices from <Cite Key="Spreer10Diss"/>, Section 5.2, is computed. The affine linear group AGL<M>(1,p)</M> is returned as the first argument. If no member of the series with <Arg>p</Arg> vertices exists only the group is returned. 
## <Example><![CDATA[
## gap> gens:=SCSeriesAGL(17);
## [ AGL(1,17), [ [ 1, 2, 4, 8, 16 ] ] ]
## gap> c:=SCFromGenerators(gens[1],gens[2]);;
## gap> SCIsManifold(SCLink(c,1));
## true
## ]]></Example>
## <Example><![CDATA[
## gap> List([19..23],x->SCSeriesAGL(x));     
## #I  SCSeriesAGL: argument must be a prime > 13.
## #I  SCSeriesAGL: argument must be a prime > 13.
## #I  SCSeriesAGL: argument must be a prime > 13.
## [ [ AGL(1,19), [ [ 1, 2, 10, 12, 17 ] ] ], fail, fail, fail, 
##   [ AGL(1,23), [ [ 1, 2, 7, 9, 19 ], [ 1, 2, 4, 8, 22 ] ] ] ]
## gap> for i in [80000..80100] do if IsPrime(i) then Print(i,"\n"); fi; od;
## 80021
## 80039
## 80051
## 80071
## 80077
## gap> SCSeriesAGL(80021);                                                 
## AGL(1,80021)
## gap> SCSeriesAGL(80039);                                                 
## [ AGL(1,80039), [ [ 1, 2, 6496, 73546, 78018 ] ] ]
## gap> SCSeriesAGL(80051);                                                 
## [ AGL(1,80051), [ [ 1, 2, 31498, 37522, 48556 ] ] ]
## gap> SCSeriesAGL(80071);                                                 
## AGL(1,80071)
## gap> SCSeriesAGL(80077);                                                 
## [ AGL(1,80077), [ [ 1, 2, 4126, 39302, 40778 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesBid">
## <ManSection>
## <Func Name="SCSeriesBid" Arg="i,d"/>
## <Returns> a simplicial complex upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructs the complex <M>B(i,d)</M> as described in <Cite Key="Klee11CentSymmMnfFewVert" />, cf. <Cite Key="Effenberger10Diss" />, <Cite Key="Sparla99LBTComb2kMnf" />. The complex <M>B(i,d)</M> is a <M>i</M>-Hamiltonian subcomplex of the <M>d</M>-cross polytope and its boundary topologically is a sphere product <M>S^i\times S^{d-i-2}</M> with vertex transitive automorphism group.   
## <Example><![CDATA[
## gap> b26:=SCSeriesBid(2,6);
## <SimplicialComplex: B(2,6) | dim = 5 | n = 12>
## gap> s2s2:=SCBoundary(b26);
## <SimplicialComplex: Bd(B(2,6)) | dim = 4 | n = 12>
## gap> SCFVector(s2s2);
## [ 12, 60, 160, 180, 72 ]
## gap> SCAutomorphismGroup(s2s2); 
## Group([ (1,3)(4,6)(7,9)(10,12), (1,5)(2,10)(4,8)(6,12)(7,11), (1,10,7,4)
##   (2,3,8,9)(5,12,11,6) ])
## gap> SCIsManifold(s2s2); 
## true
## gap> SCHomology(s2s2);
## [ [ 0, [  ] ], [ 0, [  ] ], [ 2, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesC2n">
## <ManSection>
## <Func Name="SCSeriesC2n" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the combinatorial <M>3</M>-manifold <M>C_{2n}</M>, <M>n \geq 8</M>, with <M>2n</M> vertices from <Cite Key="Spreer10Diss"/>, Section 4.5.3 and Section 5.2. The complex is homeomorphic to <M>S^2 \times S^1</M> for <M>n</M> odd and homeomorphic to <M>S^2 \dtimes S^1</M> in case <M>n</M> is an even number. In the latter case <M>C_{2n}</M> is isomorphic to <M>D_{2n}</M> from <Ref Func="SCSeriesD2n"/>. The complexes are believed to appear as the vertex links of some of the members of the series of <M>2</M>-transitive <M>4</M>-pseudomanifolds from <Ref Func="SCSeriesAGL"/>. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesC2n(8);
## <SimplicialComplex: C_16 = { (1:1:3:11),(1:1:11:3),(1:3:1:11),(2:3:2:9),(2:5:2\
## :7) } | dim = 3 | n = 16>
## gap> SCGenerators(c);  
## [ [ [ 1, 2, 3, 6 ], 32 ], [ [ 1, 2, 5, 6 ], 16 ], [ [ 1, 3, 6, 8 ], 16 ], 
##   [ [ 1, 3, 8, 10 ], 16 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCSeriesC2n(8);;
## gap> d:=SCSeriesD2n(8); 
## <SimplicialComplex: D_16 = { (1:1:1:13),(1:2:11:2),(3:4:5:4),(2:3:4:7),(2:7:4:\
## 3) } | dim = 3 | n = 16>
## gap> SCIsIsomorphic(c,d);
## true
## gap> c:=SCSeriesC2n(11);;
## gap> d:=SCSeriesD2n(11);;
## gap> c.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ]
## gap> d.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesD2n">
## <ManSection>
## <Func Name="SCSeriesD2n" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the combinatorial <M>3</M>-manifold <M>D_{2n}</M>, <M>n \geq 8</M>, <M>n \neq 9</M>, with <M>2n</M> vertices from <Cite Key="Spreer10Diss"/>, Section 4.5.3 and Section 5.2. The complex is homeomorphic to <M>S^2 \dtimes S^1</M>. In the case that <M>n</M> is even <M>D_{2n}</M> is isomorphic to <M>C_{2n}</M> from <Ref Func="SCSeriesC2n"/>. The complexes are believed to appear as the vertex links of some of the members of the series of <M>2</M>-transitive <M>4</M>-pseudomanifolds from <Ref Func="SCSeriesAGL"/>. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> d:=SCSeriesD2n(15);
## <SimplicialComplex: D_30 = { (1:1:1:27),(1:2:25:2),(3:11:5:11),(2:3:11:14),(2:\
## 14:11:3) } | dim = 3 | n = 30>
## gap> SCAutomorphismGroup(d);  
## Group([ (1,3)(4,30)(5,29)(6,28)(7,27)(8,26)(9,25)(10,24)(11,23)(12,22)(13,21)
##   (14,20)(15,19)(16,18), (1,4)(2,3)(5,30)(6,29)(7,28)(8,27)(9,26)(10,25)
##   (11,24)(12,23)(13,22)(14,21)(15,20)(16,19)(17,18) ])
## gap> StructureDescription(last);
## "D60"
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCSeriesC2n(8);;
## gap> d:=SCSeriesD2n(8); 
## <SimplicialComplex: D_16 = { (1:1:1:13),(1:2:11:2),(3:4:5:4),(2:3:4:7),(2:7:4:\
## 3) } | dim = 3 | n = 16>
## gap> SCIsIsomorphic(c,d);
## true
## gap> c:=SCSeriesC2n(11);;
## gap> d:=SCSeriesD2n(11);;
## gap> c.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ]
## gap> d.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesKu">
## <ManSection>
## <Func Name="SCSeriesKu" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the symmetric orientable sphere bundle Ku<M>(n)</M> with <M>4n</M> vertices from <Cite Key="Spreer10Diss"/>, Section 4.5.2. The series is defined as a generalization of the slicings from <Cite Key="Spreer10Diss"/>, Section 3.3.
## <Example><![CDATA[
## gap> c:=SCSeriesKu(4);                                    
## <SimplicialComplex: Sl_16 = G{ [1,2,5,9],[1,2,9,10],[1,5,9,16] } | dim = 3 | n\
##  = 16>
## gap> SCSlicing(c,[[1,2,3,4,9,10,11,12],[5,6,7,8,13,14,15,16]]);
## <NormalSurface: slicing [ [ 1, 2, 3, 4, 9, 10, 11, 12 ], [ 5, 6, 7, 8, 13, 14,\
##  15, 16 ] ] of Sl_16 = G{ [1,2,5,9],[1,2,9,10],[1,5,9,16] } | dim = 2>
## gap> Mminus:=SCSpan(c,[1,2,3,4,9,10,11,12]);;                  
## gap> Mplus:=SCSpan(c,[5,6,7,8,13,14,15,16]);;                  
## gap> SCCollapseGreedy(Mminus).Facets;
## [ [ 3, 4 ], [ 3, 10 ], [ 4, 12 ], [ 9, 10 ], [ 9, 12 ] ]
## gap> SCCollapseGreedy(Mplus).Facets; 
## [ [ 5, 6 ], [ 5, 8 ], [ 6, 14 ], [ 7, 8 ], [ 7, 15 ], [ 14, 15 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesCSTSurface">
## <ManSection>
## <Func Name="SCSeriesCSTSurface" Arg="l,[j,]2k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <C>SCSeriesCSTSurface(l,j,2k)</C> generates the centrally symmetric transitive (cst) surface <M>S_{(l,j,2k)}</M>, <C>SCSeriesCSTSurface(l,2k)</C> generates the cst surface <M>S_{(l,2k)}</M> from <Cite Key="Spreer10PartBetaK"/>, Section 4.4.
## <Example><![CDATA[
## gap> SCSeriesCSTSurface(2,4,14);
## <SimplicialComplex: cst surface S_{(2,4,14)} = { (2:4:8),(2:8:4) } | dim = 2 |\
##  n = 14>
## gap> last.Homology;
## [ [ 1, [  ] ], [ 4, [  ] ], [ 2, [  ] ] ]
## gap> SCSeriesCSTSurface(2,10);  
## <SimplicialComplex: cst surface S_{(2,10)} = { (2:2:6),(3:3:4) } | dim = 2 | n\
##  = 10>
## gap> last.Homology;                    
## [ [ 0, [  ] ], [ 1, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesHandleBody">
## <ManSection>
## <Func Name="SCSeriesHandleBody" Arg="d,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <C>SCSeriesHandleBody(d,n)</C> generates a transitive <M>d</M>-dimensional handle body (<M>d \geq 3</M>) with <M>n</M> vertices (<M>n \geq 2d + 1</M>). The handle body is orientable if <M>d</M> is odd or if <M>d</M> and <M>n</M> are even, otherwise it is not orientable. The complex equals the difference cycle <M>(1 : \ldots : 1 : n-d)</M> To obtain the boundary complexes of <C>SCSeriesHandleBody(d,n)</C> use the function <Ref Func="SCSeriesBdHandleBody"/>. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesHandleBody(3,7);
## <SimplicialComplex: Handle body B^2 x S^1 | dim = 3 | n = 7>
## gap> SCAutomorphismGroup(c);    
## Group([ (1,3)(4,7)(5,6), (1,4)(2,3)(5,7) ])
## gap> bd:=SCBoundary(c);;
## gap> SCAutomorphismGroup(bd);
## Group([ (1,2)(3,7)(4,6), (1,4,2)(3,5,6) ])
## gap> SCIsIsomorphic(bd,SCSeriesBdHandleBody(2,7));
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesBdHandleBody">
## <ManSection>
## <Func Name="SCSeriesBdHandleBody" Arg="d,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <C>SCSeriesBdHandleBody(d,n)</C> generates a transitive <M>d</M>-dimensional sphere bundle (<M>d \geq 2</M>) with <M>n</M> vertices (<M>n \geq 2d + 3</M>) which coincides with the boundary of <Ref Func="SCSeriesHandleBody"/><C>(d,n)</C>. The sphere bundle is orientable if <M>d</M> is even or if <M>d</M> is odd and <M>n</M> is even, otherwise it is not orientable. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(2,7);
## <SimplicialComplex: Sphere bundle S^1 x S^1 | dim = 2 | n = 7>
## gap> SCLib.DetermineTopologicalType(c);
## <SimplicialComplex: Sphere bundle S^1 x S^1 | dim = 2 | n = 7>
## gap> SCIsIsomorphic(c,SCSeriesHandleBody(3,7).Boundary);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesLe">
## <ManSection>
## <Func Name="SCSeriesLe" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>k</Arg>-th member (<M>k \geq 7</M>) of the series <C>Le</C> from <Cite Key="Spreer10Diss"/>, Section 4.5.1. The series can be constructed as the generalization of the boundary of a genus <M>1</M> handlebody decomposition of the manifold <C>manifold_3_14_1_5</C> from the classification in <Cite Key="Lutz03TrigMnfFewVertVertTrans"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesLe(7);                     
## <SimplicialComplex: Le_14 = { (1:1:1:11),(1:2:4:7),(1:4:2:7),(2:1:4:7),(2:5:2:\
## 5),(2:4:2:6) } | dim = 3 | n = 14>
## gap> d:=SCLib.DetermineTopologicalType(c);;
## gap> SCReference(d);
## "manifold_3_14_1_5 in F.H.Lutz: 'The Manifold Page', http://www.math.tu-berlin\
## .de/diskregeom/stellar/,\r\nF.H.Lutz: 'Triangulated manifolds with few vertice\
## s and vertex-transitive group actions', Doctoral Thesis TU Berlin 1999, Shaker\
## -Verlag, Aachen 1999"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesL">
## <ManSection>
## <Func Name="SCSeriesL" Arg="i,k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>k</Arg>-th member (<M>k \geq 0</M>) of the series <Arg>L^i</Arg>, <M>1 \leq i \leq 18</M>  from <Cite Key="Spreer10Diss"/>. The <M>18</M> series describe a complete classification of all series of cyclic <M>3</M>-manifolds with a fixed number of difference cycles of order <M>2</M> (i. e. there is a member of the series for every second integer, <M>f_0 (L^i (k+1) ) = f_0 (L^i (k)) +2</M>) and at least one member with less than <M>15</M> vertices where each series does not appear as a sub series of one of the series <M>K^i</M> from <Ref Func="SCSeriesK"/>.
## <Example><![CDATA[
## gap> cc:=List([1..18],x->SCSeriesL(x,0));;
## gap> Set(List(cc,x->x.F));
## [ [ 10, 45, 70, 35 ], [ 12, 60, 96, 48 ], [ 12, 66, 108, 54 ], 
##   [ 14, 77, 126, 63 ], [ 14, 84, 140, 70 ], [ 14, 91, 154, 77 ] ]
## gap> cc:=List([1..18],x->SCSeriesL(x,10));; 
## gap> Set(List(cc,x->x.IsManifold));
## [ true ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesK">
## <ManSection>
## <Func Name="SCSeriesK" Arg="i,k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>k</Arg>-th member (<M>k \geq 0</M>) of the series <Arg>K^i</Arg>  (<M>1 \leq i \leq 396</M>) from <Cite Key="Spreer10Diss"/>.  The <M>396</M> series describe a complete classification of all dense series (i. e. there is a member of the series for every integer, <M>f_0 (K^i (k+1) ) = f_0 (K^i (k)) +1</M>) of cyclic <M>3</M>-manifolds with a fixed number of difference cycles and at least one member with less than <M>23</M> vertices. See <Ref Func="SCSeriesL"/> for a list of series of order <M>2</M>.
## <Example><![CDATA[
## gap> cc:=List([1..10],x->SCSeriesK(x,0));;                                                                                                                                                                                                  
## gap> Set(List(cc,x->x.F));                                                                                                                                                                                                                        
## [ [ 9, 36, 54, 27 ], [ 11, 55, 88, 44 ], [ 13, 65, 104, 52 ], 
##   [ 13, 78, 130, 65 ], [ 15, 90, 150, 75 ], [ 15, 105, 180, 90 ] ]
## gap> cc:=List([1..10],x->SCSeriesK(x,10));;
## gap> gap> cc:=List([1..10],x->SCSeriesK(x,10));;
## gap> Set(List(cc,x->x.Homology));
## [ [ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ] ]
## gap> Set(List(cc,x->x.IsManifold));
## [ true ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesPrimeTorus">
## <ManSection>
## <Func Name="SCSeriesPrimeTorus" Arg="l,j,p"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the well known triangulated torus <M>\{ (l:j:p-l-j),(l:p-l-j:j) \}</M> with <M>p</M> vertices, <M>3p</M> edges and <M>2p</M> triangles where <M>j</M> has to be greater than <M>l</M> and <M>p</M> must be any prime number greater than <M>6</M>.
## <Example><![CDATA[
## gap> l:=List([2..19],x->SCSeriesPrimeTorus(1,x,41));; 
## gap> Set(List(l,x->SCHomology(x)));
## [ [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesNSB1">
## <ManSection>
## <Func Name="SCSeriesNSB1" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the first neighborly sphere bundle NSB<M>_1</M> from <Cite Key="Spreer10Diss"/>, Section 4.5.4. The complex has <M>2k+1</M> vertices, <M>k \geq 4</M>
## <Example><![CDATA[
## gap> List([4..10],x->SCNeighborliness(SCSeriesNSB1(x)));
## [ 2, 2, 2, 2, 2, 2, 2 ]
## gap> List([4..10],x->SCFVector(SCSeriesNSB1(x)));        
## [ [ 9, 36, 54, 27 ], [ 11, 55, 88, 44 ], [ 13, 78, 130, 65 ], 
##   [ 15, 105, 180, 90 ], [ 17, 136, 238, 119 ], [ 19, 171, 304, 152 ], 
##   [ 21, 210, 378, 189 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesNSB2">
## <ManSection>
## <Func Name="SCSeriesNSB2" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the second neighborly sphere bundle NSB<M>_2</M> from <Cite Key="Spreer10Diss"/>, Section 4.5.4. The complex has <M>2k</M> vertices, <M>k \geq 5</M>
## <Example><![CDATA[
## gap> List([5..10],x->SCNeighborliness(SCSeriesNSB2(x)));
## [ 2, 2, 2, 2, 2, 2 ]
## gap> List([5..10],x->SCFVector(SCSeriesNSB2(x)));       
## [ [ 10, 45, 70, 35 ], [ 12, 66, 108, 54 ], [ 14, 91, 154, 77 ], 
##   [ 16, 120, 208, 104 ], [ 18, 153, 270, 135 ], [ 20, 190, 340, 170 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesNSB3">
## <ManSection>
## <Func Name="SCSeriesNSB3" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the third neighborly sphere bundle NSB<M>_3</M> from <Cite Key="Spreer10Diss"/>, Section 4.5.4. The complex has <M>k</M> vertices, <M>k \geq 11</M>
## <Example><![CDATA[
## gap> List([11..15],x->SCNeighborliness(SCSeriesNSB3(x)));
## [ 2, 2, 2, 2, 2 ]
## gap> List([11..15],x->SCFVector(SCSeriesNSB3(x)));       
## [ [ 11, 55, 88, 44 ], [ 12, 66, 108, 54 ], [ 13, 78, 130, 65 ], 
##   [ 14, 91, 154, 77 ], [ 15, 105, 180, 90 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesTorus">
## <ManSection>
## <Func Name="SCSeriesTorus" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates the <M>d</M>-torus described in <Cite Key="Kuehnel86HigherDimCsaszar"/>.
## <Example><![CDATA[
## gap> t4:=SCSeriesTorus(4);
## <SimplicialComplex: 4-torus T^4 | dim = 4 | n = 31>
## gap> t4.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 6, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesLensSpace">
## <ManSection>
## <Func Name="SCSeriesLensSpace" Arg="p,q"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates the lens space <M>L(p,q)</M> whenever <M>p = (k+2)^2-1</M> and <M>q = k+2</M> or <M>p = 2k+3</M> and <M>q = 1</M>
## for a <M>k \geq 0</M> and <K>fail</K> otherwise. All complexes have a transitive cyclic automorphism group.
## <Example><![CDATA[
## gap> l154:=SCSeriesLensSpace(15,4);
## <SimplicialComplex: Lens space L(15,4) | dim = 3 | n = 22>
## gap> l154.Homology;
## [ [ 0, [  ] ], [ 0, [ 15 ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> g:=SimplifiedFpGroup(SCFundamentalGroup(l154));
## <fp group on the generators [ [2,5] ]>
## gap> StructureDescription(g);
## "C15"
## ]]></Example>
## <Example><![CDATA[
## gap> l151:=SCSeriesLensSpace(15,1);
## <SimplicialComplex: Lens space L(15,1) | dim = 3 | n = 62>
## gap> l151.Homology;
## [ [ 0, [  ] ], [ 0, [ 15 ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> g:=SimplifiedFpGroup(SCFundamentalGroup(l151));
## <fp group on the generators [ [2,3] ]>
## gap> StructureDescription(g);
## "C15"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesBrehmKuehnelTorus">
## <ManSection>
## <Func Name="SCSeriesBrehmKuehnelTorus" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a neighborly 3-torus with <Arg>n</Arg> vertices if <Arg>n</Arg> is odd and a centrally symmetric 3-torus if <Arg>n</Arg> is even (<Arg>n</Arg><M>\geq 15</M> . The triangulations are taken from <Cite Key="Brehm09LatticeTrigE33Torus"/>
## <Example><![CDATA[
## gap> T3:=SCSeriesBrehmKuehnelTorus(15);
## <SimplicialComplex: Neighborly 3-Torus NT3(15) | dim = 3 | n = 15>
## gap> T3.Homology;
## [ [ 0, [  ] ], [ 3, [  ] ], [ 3, [  ] ], [ 1, [  ] ] ]
## gap> T3.Neighborliness;
## 2
## gap> T3:=SCSeriesBrehmKuehnelTorus(16);
## <SimplicialComplex: Centrally symmetric 3-Torus SCT3(16) | dim = 3 | n = 16>
## gap> T3.Homology;
## [ [ 0, [  ] ], [ 3, [  ] ], [ 3, [  ] ], [ 1, [  ] ] ]
## gap> T3.IsCentrallySymmetric;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesHomologySphere">
## <ManSection>
## <Func Name="SCSeriesHomologySphere" Arg="p,q,r"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial Brieskorn homology sphere of type <M>\Sigma (p,q,r)</M>, <M>p</M>, <M>q</M> and <M>r</M>
## pairwise co-prime. The complex is a combinatorial <M>3</M>-manifold with transitive cyclic symmetry
## as described in <Cite Key="Spreer12VarCyclPolytope"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesHomologySphere(2,3,5);
## <SimplicialComplex: Homology sphere Sigma(2,3,5) | dim = 3 | n = 17>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> c:=SCSeriesHomologySphere(3,4,13);
## <SimplicialComplex: Homology sphere Sigma(3,4,13) | dim = 3 | n = 37>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesConnectedSum">
## <ManSection>
## <Func Name="SCSeriesConnectedSum" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial manifold of type <M>(S^2 x S^1)^{\#k}</M> for <M>k</M> even. 
## The complex is a combinatorial <M>3</M>-manifold with transitive cyclic symmetry
## as described in <Cite Key="Spreer12VarCyclPolytope"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesConnectedSum(12);
## <SimplicialComplex: (S^2xS^1)^#12) | dim = 3 | n = 52>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 12, [  ] ], [ 12, [  ] ], [ 1, [  ] ] ]
## gap> g:=SimplifiedFpGroup(SCFundamentalGroup(c));
## <fp group of size infinity on the generators 
## [ [2,3], [2,14], [3,4], [6,7], [9,10], [10,11], [11,12], [12,13], [26,32], 
##   [26,34], [29,31], [33,35] ]>
## gap> RelatorsOfFpGroup(g);
## [  ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesSeifertFibredSpace">
## <ManSection>
## <Func Name="SCSeriesSeifertFibredSpace" Arg="p,q,r"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial Seifert fibred space of type 
##
## <Display>SFS [ (\mathbb{T}^2)^{(a-1)(b-1)} : (p/a,b_1)^b , (q/b,b_2)^a, (r/ab,b_3) ]</Display>
## 
## where <M>p</M> and <M>q</M> are co-prime, <M>a = \operatorname{gcd} (p,r)</M>, <M>b = \operatorname{gcd} (p,r)</M>,
## and the <M>b_i</M> are given by the identity
##
## <Display>\frac{b_1}{p} + \frac{b_2}{q} + \frac{b_3}{r} = \frac{\pm ab}{pqr}.</Display>
##
## This <M>3</M>-parameter family of combinatorial <M>3</M>-manifolds contains the
## families generated by <Ref Func="SCSeriesHomologySphere"/>, <Ref Func="SCSeriesConnectedSum"/>
## and parts of <Ref Func="SCSeriesLensSpace"/>, internally calls <K>SCIntFunc.SeifertFibredSpace(p,q,r)</K>.
##
## The complexes are combinatorial <M>3</M>-manifolds with transitive cyclic symmetry
## as described in <Cite Key="Spreer12VarCyclPolytope"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesSeifertFibredSpace(2,3,15);
## <SimplicialComplex: SFS [ S^2 : (2,b1)^3, (5,b3) ] | dim = 3 | n = 27>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 0, [ 2, 2 ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSurface">
## <ManSection>
## <Func Name="SCSurface" Arg="g,orient"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates the surface of genus <Arg>g</Arg> where the boolean argument <Arg>orient</Arg> specifies 
## whether the surface is orientable or not. The surfaces have transitive cyclic group actions and
## can be described using the minimum amount of <M>O(\operatorname{log} (g))</M> memory.
##
## If <Arg>orient</Arg> is <C>true</C> and <Arg>g</Arg><M> \geq 50</M> or if 
## <Arg>orient</Arg> is <C>false</C> and <Arg>g</Arg><M> \geq 100</M> only the difference cycles of the
## surface are returned
## <Example><![CDATA[
## gap> c:=SCSurface(23,true); 
## <SimplicialComplex: S_23^or | dim = 2 | n = 88>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 46, [  ] ], [ 1, [  ] ] ]
## gap> c.TopologicalType;
## "(T^2)^#23"
## gap> c:=SCSurface(23,false); 
## <SimplicialComplex: S_23^non | dim = 2 | n = 21>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 22, [ 2 ] ], [ 0, [  ] ] ]
## gap> c.TopologicalType;
## "(RP^2)^#23"
## ]]></Example>
## <Example><![CDATA[
## gap> dc:=SCSurface(345,true);
## [ [ 1, 1, 1374 ], [ 2, 343, 1031 ], [ 343, 345, 688 ] ]
## gap> c:=SCFromDifferenceCycles(dc);
## <SimplicialComplex: complex from diffcycles [ [ 1, 1, 1374 ], [ 2, 343, 1031 ]\
## , [ 343, 345, 688 ] ] | dim = 2 | n = 1376>
## gap> c.Chi;
## -688
## gap> dc:=SCSurface(12345678910,true); time;
## [ [ 1, 1, 24691357816 ], [ 2, 4, 24691357812 ], [ 3, 3, 24691357812 ], 
##   [ 4, 12345678907, 12345678907 ] ]
## 0
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSeriesS2xS2">
## <ManSection>
## <Func Name="SCSeriesS2xS2" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial version of <M>(S^2 \times S^2)^{\# k}</M>.
## <Example><![CDATA[
## gap> c:=SCSeriesS2xS2(3);
## <SimplicialComplex: (S^2 x S^2)^(# 3) | dim = 4 | n = 24>
## gap> c.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 6, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
