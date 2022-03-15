################################################################################
##
##  simpcomp / DMT.gi
##
##  Functions for discrete Morse theory, manifold recognition 
##  and simply connectivity testing
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCHasseDiagram">
## <ManSection>
## <Func Name="SCHasseDiagram" Arg="c"/>
## <Returns>two lists of lists upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes the Hasse diagram of <C>SCSimplicialComplex</C> object 
## <Arg>c</Arg>. The Hasse diagram is returned as two sets of lists. The first
## set of lists contains the upward part of the Hasse diagram, the second
## set of lists contains the downward part of the Hasse diagram.
## <P/>
## The <M>i</M>-th list of each set of lists represents the incidences between
## the <M>(i-1)</M>-faces and the <M>i</M>-faces. The faces are given by their 
## indices of the face lattice.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> HD:=SCHasseDiagram(c);
## [ [ [ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 2, 4, 6 ], [ 3, 5, 6 ] ], 
##       [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], [ 1, 4 ], [ 2, 4 ], [ 3, 4 ] ] ], 
##   [ [ [ 2, 1 ], [ 3, 1 ], [ 4, 1 ], [ 3, 2 ], [ 4, 2 ], [ 4, 3 ] ], 
##       [ [ 4, 2, 1 ], [ 5, 3, 1 ], [ 6, 3, 2 ], [ 6, 5, 4 ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
#########################################################
### Three methods to compute discrete Morse functions ###
#########################################################
################################################################################
##<#GAPDoc Label="SCMorseEngstroem">
## <ManSection>
## <Func Name="SCMorseEngstroem" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following the Engstroem method by reducing 
## the input complex to smaller complexes defined by minimal link and deletion 
## operations. See <Cite Key="Engstroem09DiscMorseFuncFourierTrans" /> for 
## details.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> f:=SCMorseEngstroem(c);
## [ [ [ 2 ], [ 2, 3 ], [ 2, 4 ], [ 2 .. 4 ], [  ], [ 3 ], [ 4 ], [ 3, 4 ], 
##       [ 1, 3 ], [ 1, 3, 4 ], [ 1 ], [ 1, 4 ], [ 1, 2, 4 ], [ 1, 2 ], 
##       [ 1 .. 3 ] ], [ [ 2 ], [ 1 .. 3 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseRandom">
## <ManSection>
## <Func Name="SCMorseRandom" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following Lutz and Benedetti's random
## discrete Morse theory approach: Faces are paired with free co-dimension one 
## faces until now free faces remain. Then a critical face is removed at random.
## See <Cite Key="Benedetti13RandomDMT" /> for details.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> f:=SCMorseRandom(c);;
## gap> Size(f[2]);
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseRandomLex">
## <ManSection>
## <Func Name="SCMorseRandomLex" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following Adiprasito, Benedetti and Lutz' 
## lexicographic random
## discrete Morse theory approach. See <Cite Key="Benedetti13RandomDMT" />, 
## <Cite Key="Adiprasito14RDMTII" /> for details.
## <Example><![CDATA[
## gap> c := SCSurface(3,true);;
## gap> f:=SCMorseRandomLex(c);;
## gap> Size(f[2]);
## 8
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseRandomRevLex">
## <ManSection>
## <Func Name="SCMorseRandomRevLex" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following Adiprasito, Benedetti and Lutz' 
## reverse lexicographic random
## discrete Morse theory approach. See <Cite Key="Benedetti13RandomDMT" />, 
## <Cite Key="Adiprasito14RDMTII" /> for details.
## <Example><![CDATA[
## gap> c := SCSurface(5,false);;
## gap> f:=SCMorseRandomRevLex(c);;
## gap> Size(f[2]);
## 7
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCollapseGreedy">
## <ManSection>
## <Meth Name="SCCollapseGreedy" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm to collapse the simplicial complex 
## <Arg>complex</Arg>. 
## See also <Ref Meth="SCCollapseLex" /> and <Ref Meth="SCCollapseRevLex" />.
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]}; 
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], [ 10, "T^2 (VT)" ],
##   [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> bdtorus:=SCDifference(torus,SC([torus.Facets[1]]));;
## gap> coll:=SCCollapseGreedy(bdtorus);
## <SimplicialComplex: collapsed version of T^2 (VT) \ unnamed complex 8 | dim = \
## 1 | n = 4>
## gap> coll.Facets;
## [ [ 2, 5 ], [ 2, 6 ], [ 2, 7 ], [ 5, 6 ], [ 5, 7 ] ]
## gap> sphere:=SCBdSimplex(4);;                              
## gap> bdsphere:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap> coll:=SCCollapseGreedy(bdsphere);
## <SimplicialComplex: collapsed version of S^3_5 \ unnamed complex 12 | dim = 0 \
## | n = 1>
## gap> coll.Facets;                     
## [ [ 2 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCollapseLex">
## <ManSection>
## <Meth Name="SCCollapseLex" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm in lexicographical order to collapse 
## the simplicial complex <Arg>complex</Arg>. See also 
## <Ref Meth="SCCollapseGreedy" /> and <Ref Meth="SCCollapseRevLex" />.
## <Example><![CDATA[
## gap> s:=SCSurface(1,true);;
## gap> s:=SCDifference(s,SC([SCFacets(s)[1]]));;
## gap> coll:=SCCollapseGreedy(s);
## <SimplicialComplex: collapsed version of T^2 \ unnamed complex 18 | dim = 1 | \
## n = 5>
## gap> coll.Facets;
## [ [ 1, 6 ], [ 1, 7 ], [ 2, 5 ], [ 2, 7 ], [ 5, 7 ], [ 6, 7 ] ]
## gap> sphere:=SCBdSimplex(4);;                              
## gap> ball:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap> coll:=SCCollapseLex(ball);
## <SimplicialComplex: collapsed version of S^3_5 \ unnamed complex 22 | dim = 0 \
## | n = 1>
## gap> coll.Facets;                     
## [ [ 5 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCollapseRevLex">
## <ManSection>
## <Meth Name="SCCollapseRevLex" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm in reverse lexicographical order to 
## collapse the simplicial complex <Arg>complex</Arg>. 
## See also <Ref Meth="SCCollapseGreedy" /> and <Ref Meth="SCCollapseLex" />.
## <Example><![CDATA[
## gap> s:=SCSurface(1,true);;
## gap> s:=SCDifference(s,SC([SCFacets(s)[1]]));;
## gap> coll:=SCCollapseGreedy(s);
## <SimplicialComplex: collapsed version of T^2 \ unnamed complex 28 | dim = 1 | \
## n = 5>
## gap> coll.Facets;
## [ [ 1, 3 ], [ 1, 7 ], [ 3, 4 ], [ 3, 5 ], [ 4, 7 ], [ 5, 7 ] ]
## gap> sphere:=SCBdSimplex(4);;                              
## gap> ball:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap> coll:=SCCollapseRevLex(ball);
## <SimplicialComplex: collapsed version of S^3_5 \ unnamed complex 32 | dim = 0 \
## | n = 1>
## gap> coll.Facets;                     
## [ [ 1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseUST">
## <ManSection>
## <Func Name="SCMorseUST" Arg="complex"/>
## <Returns>a random Morse function of a simplicial complex and a list of 
## critical faces.</Returns>
## <Description>
## Builds a random Morse function by removing a uniformly sampled spanning tree 
## from the dual 1-skeleton followed by a collapsing approach.
## <Arg>complex</Arg> needs to be a closed weak pseudomanifold for this to work.
## For details of the algorithm, see <Cite Key="Paixao143SphereRec" />.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> f:=SCMorseUST(c);;
## gap> Size(f[2]);
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseSpec">
## <ManSection>
## <Func Name="SCMorseSpec" Arg="complex, iter [, morsefunc]"/>
## <Returns>a list upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes <Arg>iter</Arg> versions of a discrete Morse function of 
## <Arg>complex</Arg> using a randomised 
## method specified by <Arg>morsefunc</Arg> (default choice is 
## <Ref Func="SCMorseRandom"/>,
## other randomised methods available are <Ref Func="SCMorseRandomLex"/>
## <Ref Func="SCMorseRandomRevLex"/>, and <Ref Func="SCMorseUST"/>). The
## result is referred to by the Morse spectrum of <Arg>complex</Arg> and is 
## returned in form of a list containing all Morse vectors sorted by number of 
## critical points together with the actual vector of critical points and how 
## often they ocurred (see <Cite Key="Benedetti13RandomDMT" /> for details).
## <Example><![CDATA[
## gap> c:=SCSeriesTorus(2);;
## gap> f:=SCMorseSpec(c,30);
## [ [ 4, [ 1, 2, 1 ], 30 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCSeriesHomologySphere(2,3,5);;
## gap> f:=SCMorseSpec(c,30,SCMorseRandom);
## [ [ 6, [ 1, 2, 2, 1 ], 25 ], [ 8, [ 1, 3, 3, 1 ], 5 ] ]
## gap> f:=SCMorseSpec(c,30,SCMorseRandomLex);
## [ [ 6, [ 1, 2, 2, 1 ], 30 ] ]
## gap> f:=SCMorseSpec(c,30,SCMorseRandomRevLex);
## [ [ 6, [ 1, 2, 2, 1 ], 7 ], [ 8, [ 1, 3, 3, 1 ], 13 ], 
##   [ 10, [ 1, 4, 4, 1 ], 9 ], [ 10, [ 2, 4, 3, 1 ], 1 ] ]
## gap> f:=SCMorseSpec(c,30,SCMorseUST);
## [ [ 6, [ 1, 2, 2, 1 ], 18 ], [ 8, [ 1, 3, 3, 1 ], 8 ], 
##   [ 10, [ 1, 4, 4, 1 ], 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomologyEx">
## <ManSection>
## <Meth Name="SCHomologyEx" Arg="c, morsechoice, smithchoice"/>
## <Returns>a list of pairs of the form <C>[ integer, list ]</C> upon success, 
## fail otherwise.</Returns>
## <Description>
## Computes the homology groups of a given simplicial complex <Arg>c</Arg> 
## using the function <Arg>morsechoice</Arg> for discrete Morse function 
## computations and <Arg>smithchoice</Arg> for Smith normal form 
## computations.<P/>
##
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, 
## where <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the 
## homology groups <M>H_i</M> is given in terms of their maximal cyclic 
## subgroups, i.e. a homology group 
## <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> 
## is returned in form of a list 
## <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> is the (integer) 
## free part of <M>H_i</M> and <M>t_i</M> denotes the torsion parts of 
## <M>H_i</M> ordered in weakly increasing size.<P/>
## <Example><![CDATA[
## gap> c:=SCSeriesTorus(2);;
## gap> f:=SCHomology(c);
## [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseRandom,SmithNormalFormIntegerMat); time;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## 31
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseRandomLex,SmithNormalFormIntegerMat); time;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## 30
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseRandomRevLex,SmithNormalFormIntegerMat); time;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## 33
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseEngstroem,SmithNormalFormIntegerMat); time;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## 63
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseUST,SmithNormalFormIntegerMat); time;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## 74
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomology">
## <ManSection>
## <Meth Name="SCHomology" Arg="complex"/>
## <Returns>a list of pairs of the form <C>[ integer, list ]</C> upon 
## success</Returns>
## <Description>
## Computes the homology groups of a given simplicial complex 
## <Arg>complex</Arg> using 
## <Ref Func="SCMorseRandom"/> to obtain a Morse function and 
## <C>SmithNormalFormIntegerMat</C>.
## Use <Ref Func="SCHomologyEx"/> to use alternative methods to compute 
## discrete Morse functions (such as <Ref Func="SCMorseEngstroem"/>, 
## or <Ref Func="SCMorseUST"/>) or the Smith normal form. <P/>
##
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, 
## where <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the 
## homology groups <M>H_i</M> is given in terms of their maximal cyclic 
## subgroups, i.e. a homology group 
## <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> 
## is returned in form of a list <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> 
## is the (integer) free part of <M>H_i</M> and <M>t_i</M> denotes the torsion 
## parts of <M>H_i</M> ordered in weakly increasing size.<P/>
## <Example><![CDATA[
## gap> c:=SCSeriesTorus(2);;
## gap> f:=SCHomology(c);
## [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSpanningTreeRandom">
## <ManSection>
## <Func Name="SCSpanningTreeRandom" Arg="HD, top"/>
## <Returns>a list of edges upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes a uniformly sampled spanning tree of the complex belonging
## to the Hasse diagram <Arg>HD</Arg> using Wilson's algorithm (see 
## <Cite Key="Wilson96UST" />). 
## If <Arg>top = true</Arg> the output is a
## spanning tree of the dual graph of the underlying complex. If
## <Arg>top = false</Arg> the output is a spanning tree of the primal graph 
## (i.e., the <M>1</M>-skeleton.
## <Example><![CDATA[
## gap> c:=SCSurface(1,false);;
## gap> HD:=SCHasseDiagram(c);;
## gap> stTop:=SCSpanningTreeRandom(HD,true);
## [ 15, 2, 6, 12, 7, 8, 1, 3, 11 ]
## gap> stBot:=SCSpanningTreeRandom(HD,false);
## [ 9, 5, 3, 6, 11 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsSimplyConnectedEx">
## <ManSection>
## <Func Name="SCIsSimplyConnectedEx" Arg="c [, top, tries]"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes if the <C>SCSimplicialComplex</C> object <Arg>c</Arg> is simply 
## connected. The optional boolean argument <Arg>top</Arg> determines whether 
## a spanning graph in the dual or the primal graph of <Arg>c</Arg> will be 
## used for a collapsing sequence. The optional positive integer argument 
## <Arg>tries</Arg> determines the number of times the algorithm will try to 
## find a collapsing sequence. The algorithm is a heuristic method and is 
## described in <Cite Key="Paixao143SphereRec" />.
## <Example><![CDATA[
## gap> rp2:=SCSurface(1,false);;
## gap> SCIsSimplyConnectedEx(rp2);
## false
## gap> c:=SCBdCyclicPolytope(8,18);;
## gap> SCIsSimplyConnectedEx(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsSimplyConnected">
## <ManSection>
## <Func Name="SCIsSimplyConnected" Arg="c"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes if the <C>SCSimplicialComplex</C> object <Arg>c</Arg> is simply 
## connected. The algorithm is a heuristic method and is described in 
## <Cite Key="Paixao143SphereRec" />. Internally calls 
## <Ref Func="SCIsSimplyConnectedEx" />.
## <Example><![CDATA[
## gap> rp2:=SCSurface(1,false);;
## gap> SCIsSimplyConnected(rp2);
## false
## gap> c:=SCBdCyclicPolytope(8,18);;
## gap> SCIsSimplyConnected(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsManifoldEx">
## <ManSection>
## <Func Name="SCIsManifoldEx" Arg="c [,aut, quasi]"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## If the boolean argument <Arg>aut</Arg> is <C>true</C> the automorphism group
## is computed and only one link per orbit is checked to be a sphere.
## If <Arg>aut</Arg> is not provided symmetry information is only used if
## the automorphism group is already known.
## If the boolean argument <Arg>quasi</Arg> is <C>false</C> the algorithm
## returns whether or not <Arg>c</Arg> is a combinatorial manifold. If
## <Arg>quasi</Arg> is <C>true</C> the <M>4</M>-dimensional links are
## not verified to be standard PL <M>4</M>-spheres and <Arg>c</Arg> is
## a combinatorial manifold modulo the smooth Poincare conjecture. 
## By default <Arg>quasi</Arg> is set to <C>false</C>. The algorithm
## is a heuristic method and is described in <Cite Key="Paixao143SphereRec" /> 
## in more detail.<P/>
##
## See <Ref Func="SCBistellarIsManifold" /> for an alternative method for 
## manifold verification.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,20);;
## gap> SCIsManifold(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsManifold">
## <ManSection>
## <Func Name="SCIsManifold" Arg="c"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## The algorithm is a heuristic method and is described in 
## <Cite Key="Paixao143SphereRec" /> in more detail.
## Internally calls <Ref Func="SCIsManifoldEx" />.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,20);;
## gap> SCIsManifold(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsSphere">
## <ManSection>
## <Func Name="SCIsSphere" Arg="c"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Determines whether the <C>SCSimplicialComplex</C> object <Arg>c</Arg>
## is a topological sphere.
## In dimension <M>\neq 4</M> the algorithm determines whether <Arg>c</Arg>
## is PL-homeomorphic to the standard sphere. In dimension <M>4</M>
## the PL type is not specified. The algorithm uses a result due to 
## <Cite Key="Kirby77PLStructures" />
## stating that, in dimension <M>\neq 4</M>, any simply connected homology 
## sphere with PL structure
## is a standard PL sphere. The function calls 
## <Ref Meth="SCIsSimplyConnected" /> which uses
## a heuristic method described in <Cite Key="Paixao143SphereRec" />.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,20);;
## gap> SCIsSphere(c);
## true
## gap> c:=SCSurface(1,true);;
## gap> SCIsSphere(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
