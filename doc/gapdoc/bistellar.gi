################################################################################
##
##  simpcomp / bistellar.gi
##
##  Functions for bistellar moves  
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCBistellarOptions">
## <ManSection>
## <Var Name="SCBistellarOptions"/>
## <Description>
## Record of global variables to adjust output an behavior of bistellar moves 
## in <Ref Func="SCIntFunc.SCChooseMove"/> and <Ref Func="SCReduceComplexEx"/> 
## respectively.
## <Enum>
## <Item><C>BaseRelaxation</C>: determines the length of the relaxation period. 
## Default: <M>3</M></Item>
## <Item><C>BaseHeating</C>: determines the length of the heating period. 
## Default: <M>4</M></Item>
## <Item><C>Relaxation</C>: value of the current relaxation period. Default: 
## <M>0</M></Item>
## <Item><C>Heating</C>: value of the current heating period. Default: 
## <M>0</M></Item>
## <Item><C>MaxRounds</C>: maximal over all number of bistellar flips that 
## will be performed. Default: <M>500000</M></Item>
## <Item><C>MaxInterval</C>: maximal number of bistellar flips that will be 
## performed without a change of the <M>f</M>-vector of the moved complex. 
## Default: <M>100000</M></Item>
## <Item><C>Mode</C>: flip mode, <M>0</M>=reducing, <M>1</M>=comparing, 
## <M>2</M>=reduce as sub-complex, <M>3</M>=randomize. Default: <M>0</M> 
## </Item>
## <Item><C>WriteLevel</C>: <M>0</M>=no output, <M>1</M>=storing of every 
## vertex minimal complex to user library, <M>2</M>=e-mail notification. 
## Default: <M>1</M> </Item>
## <Item><C>MailNotifyIntervall</C>: (minimum) number of seconds between 
## two e-mail notifications. Default: 
## <M>24 \cdot 60 \cdot 60</M> (one day)</Item>
## <Item><C>MaxIntervalIsManifold</C>: maximal number of bistellar flips that 
## will be performed without a change of the <M>f</M>-vector of a vertex link 
## while trying to prove that the complex is a combinatorial manifold. Default:
## <M>5000</M></Item>
## <Item><C>MaxIntervalRandomize := 50</C>: number of flips performed to create 
## a randomized sphere. Default: <M>50</M></Item>
## </Enum>
## <Example><![CDATA[
## gap> SCBistellarOptions.BaseRelaxation;
## 3
## gap> SCBistellarOptions.BaseHeating;
## 4
## gap> SCBistellarOptions.Relaxation;
## 0
## gap> SCBistellarOptions.Heating;
## 0
## gap> SCBistellarOptions.MaxRounds;
## 500000
## gap> SCBistellarOptions.MaxInterval;
## 100000
## gap> SCBistellarOptions.Mode;
## 0
## gap> SCBistellarOptions.WriteLevel;
## 0
## gap> SCBistellarOptions.MailNotifyInterval;
## 86400
## gap> SCBistellarOptions.MaxIntervalIsManifold;
## 5000
## gap> SCBistellarOptions.MaxIntervalRandomize;
## 50
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##
##                    [,<mode>,<complex >])
##
##
##
## INPUT:      r: codimension of faces that are about to be examined
##              ("testelement")
##             sComplex: simplicial Complex by faces
##             max: Size of maximal Elements of sComplex (max-1) =
##              Dimension of complex
##
## OUTPUT:     rawOptions: vector containing all possible candidates for r-moves
##
## DESCRIPTION:
##
## Initial options for moves (and reverse moves)
## (Reverse_k_Move=(max-k-1)-move)
##
## Test for all (dim-r)-dimensional faces "testelement" whether there are
## exactly (r + 1) maximal faces "maxface" containing "testelement".
## If this is true return all vertices of those maximal faces ("linkface"), and
## "testelement" in rawOptions[r+1] (#(raw_element[r+1])<=#(faces[max-r]))
##
## EXAMPLE:
## r:=1;
## faces[max]:=[[1,2,3],[2,3,4], ...];
## faces[max-r]:=[[1,2],[2,3],[3,1],[2,4],[3,4], ...];
## raw_options[r+1]:=[[[2,3],[1,4]],[...], ...];
##
## r:=2;
## faces[max]:=[[1,2,3],[1,2,4],[1,3,4],[2,3,5],[2,4,6],[2,5,6], ...];
## faces[max-r]:=[[1],[2],[3],[4],[5],[6], ...];
## raw_options[r+1]:=[[[1],[2,3,4]],[...], ...];
## [[2],[1,3,4,5,6]] not in raw_options[r+1]
##
## Elements in raw_options[r+1] -> canditates for r-moves
## changes of global vars:
## raw_options[r+1] -> all faces in "faces[max-r]" which are contained in (r+1)
## maximal faces, including all vertices of those maximal faces.
##
################################################################################
##
##
## Include options for moves (and reverse moves)
## Test for all elements in "raw_options[r+1]" whether they are
## really candidates for a r-move or not.
##
## EXAMPLE:
## r:=0;
## faces[max]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]]; (2-sphere)
## faces[max-r]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]];
## raw_options[r+1]:=[[[1,2,3],[]],[[2,3,4],[]],[[1,3,4],[]],[[1,2,4],[]]];
## r:=1;
## faces[max]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]]; (2-sphere)
## faces[max-r]:=[[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]];
## raw_options[r+1]:=[[[1,2],[3,4]],[[1,3],[2,4]],[[1,4],[2,4]],[[2,3],[1,4]],
## [[2,4],[1,3]],[[[3,4],[1,2]]];
## r:=2;
## faces[max]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]]; (2-sphere)
## faces[max-r]:=[[1],[2],[3],[4]];
## raw_options[r+1]:=[[[1],[2,3,4]],[[2],[1,3,4]],
## [[3],[1,2,4]],[[4],[1,2,3]]];
##
## but: [1,2] -> [3,4] in faces[2], etc. ...
##      [1] -> [2,3,4] in faces[3], etc. ...
## -> options:=[[[1,2,3],[]],[[2,3,4],[]],[[1,3,4],[]],[[1,2,4],[]]];
##
###################################################################
###                Moves (and reverse moves)                    ###
###################################################################
################################################################################
##
##    < ball_boundary_faces>,<mode,complex >)
##
## test all elements in "ball_boundary_faces" whether they can be flipped or
## not (in this case, add them to "raw_options") (this routine is part
## of every r-move (at the end))
##
################################################################################
##
##  <mode>,   < randomelement>,<complex >)
##
## realizes a 0-move (i.e. f[1] -> f[1] + 1, ..., f[max] -> f[max] + dim)
## FURTHER EXPLANATION:
##
## A "0-move" subdivides a maximal (dim-)simplex into (dim+1)=max
## (dim-)simplices, coned over a new vertex in its center (see Paper
## "Simplicial Manifolds..." by Lutz/Björner for a formal definition of
## bistellar k-moves)
##
################################################################################
##
##    < raw_options> ,<mode>,<complex>)
##
## realizes a r-move
##
################################################################################
##<#GAPDoc Label="SCIsMovableComplex">
## <ManSection>
## <Meth Name="SCIsMovableComplex" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.
## </Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> can be modified by 
## bistellar moves, i. e. if it is a pure simplicial complex which fulfills 
## the weak pseudomanifold property with empty boundary.<P/>
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> SCIsMovableComplex(c);
## true
## ]]></Example>
## Complex with non-empty boundary:
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[3,4],[3,1]]);;
## gap> SCIsMovableComplex(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRMoves">
## <ManSection>
## <Meth Name="SCRMoves" Arg="complex, r"/>
## <Returns> a list of pairs of the form <C>[ list, list ]</C>, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## A bistellar <M>r</M>-move of a <M>d</M>-dimensional combinatorial manifold 
## <Arg>complex</Arg> is a <M>r</M>-face <M>m_1</M> together with a 
## <M>d-r</M>-tuple <M>m_2</M> where <M>m_1</M> is a common face of exactly 
## <M>(d+1-r)</M> facets and <M>m_2</M> is not a face of <Arg>complex</Arg>.<P/>
## The <M>r</M>-move removes all facets containing <M>m_1</M> and replaces 
## them by the <M>(r+1)</M> faces obtained by uniting <M>m_2</M> with any 
## subset of <M>m_1</M> of order <M>r</M>.<P/>
## The resulting complex is PL-homeomorphic to <Arg>complex</Arg>. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> moves:=SCRMoves(c,1);
## [ [ [ 1, 3 ], [ 5, 6 ] ], [ [ 1, 4 ], [ 5, 6 ] ], [ [ 1, 5 ], [ 3, 4 ] ], 
##   [ [ 1, 6 ], [ 3, 4 ] ], [ [ 2, 3 ], [ 5, 6 ] ], [ [ 2, 4 ], [ 5, 6 ] ], 
##   [ [ 2, 5 ], [ 3, 4 ] ], [ [ 2, 6 ], [ 3, 4 ] ], [ [ 3, 5 ], [ 1, 2 ] ], 
##   [ [ 3, 6 ], [ 1, 2 ] ], [ [ 4, 5 ], [ 1, 2 ] ], [ [ 4, 6 ], [ 1, 2 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMoves">
## <ManSection>
## <Meth Name="SCMoves" Arg="complex"/>
## <Returns> a list of list of pairs of lists upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## See <Ref Meth="SCRMoves"/> for further information.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> moves:=SCMoves(c);
## [ [ [ [ 1, 3, 5 ], [  ] ], [ [ 1, 3, 6 ], [  ] ], [ [ 1, 4, 5 ], [  ] ], 
##       [ [ 1, 4, 6 ], [  ] ], [ [ 2, 3, 5 ], [  ] ], [ [ 2, 3, 6 ], [  ] ], 
##       [ [ 2, 4, 5 ], [  ] ], [ [ 2, 4, 6 ], [  ] ] ], 
##   [ [ [ 1, 3 ], [ 5, 6 ] ], [ [ 1, 4 ], [ 5, 6 ] ], [ [ 1, 5 ], [ 3, 4 ] ], 
##       [ [ 1, 6 ], [ 3, 4 ] ], [ [ 2, 3 ], [ 5, 6 ] ], [ [ 2, 4 ], [ 5, 6 ] ], 
##       [ [ 2, 5 ], [ 3, 4 ] ], [ [ 2, 6 ], [ 3, 4 ] ], [ [ 3, 5 ], [ 1, 2 ] ], 
##       [ [ 3, 6 ], [ 1, 2 ] ], [ [ 4, 5 ], [ 1, 2 ] ], [ [ 4, 6 ], [ 1, 2 ] ] ]
##     , [  ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMove">
## <ManSection>
## <Meth Name="SCMove" Arg="c, move"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Applies the bistellar move <Arg>move</Arg> to a simplicial complex 
## <Arg>c</Arg>. <Arg>move</Arg> is given as a <M>(r+1)</M>-tuple together 
## with a <M>(d+1-r)</M>-tuple if <M>d</M> is the dimension of <Arg>c</Arg> 
## and if <Arg>move</Arg> is a <M>r</M>-move. See <Ref Meth="SCRMoves"/> for 
## detailed information about bistellar <M>r</M>-moves.<P/>
## Note: <Arg>move</Arg> and <Arg>c</Arg> should be given in standard 
## labeling to ensure a correct result.
## <Example><![CDATA[
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,1]]);
## <SimplicialComplex: unnamed complex 5 | dim = 1 | n = 4>
## gap> moves:=SCMoves(obj);
## [ [ [ [ 1, 2 ], [  ] ], [ [ 1, 4 ], [  ] ], [ [ 2, 3 ], [  ] ], 
##       [ [ 3, 4 ], [  ] ] ], 
##   [ [ [ 1 ], [ 2, 4 ] ], [ [ 2 ], [ 1, 3 ] ], [ [ 3 ], [ 2, 4 ] ], 
##       [ [ 4 ], [ 1, 3 ] ] ] ]
## gap> obj:=SCMove(obj,last[2][1]);
## <SimplicialComplex: unnamed complex 6 | dim = 1 | n = 3>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIntFunc.SCChooseMove">
## <ManSection>
## <Func Name="SCIntFunc.SCChooseMove" Arg="dim, moves"/>
## <Returns> a bistellar move, i. e. a pair of lists upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Since the problem of finding a bistellar flip sequence that reduces a 
## simplicial complex is undecidable, we have to use an heuristic approach to 
## choose the next move. <P/> 
## The implemented strategy <C>SCIntFunc.SCChooseMove</C> first tries to 
## directly remove vertices, edges, <M>i</M>-faces in increasing dimension etc. 
## If this is not possible it inserts high dimensional faces in decreasing 
## co-dimension. To do this in an efficient way a number of parameters have 
## to be adjusted, namely <C>SCBistellarOptions.BaseHeating</C> and 
## <C>SCBistellarOptions.BaseRelaxation</C>. See 
## <Ref Var="SCBistellarOptions"/> for further options.
## <P/>
## If this strategy does not work for you, just implement a customized 
## strategy and pass it to <Ref Func="SCReduceComplexEx"/>.<P/>
## See <Ref Meth="SCRMoves" /> for further information.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExamineComplexBistellar">
## <ManSection>
## <Meth Name="SCExamineComplexBistellar" Arg="complex"/>
## <Returns> simplicial complex passed as argument with additional properties 
## upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the face lattice, the <M>f</M>-vector, the AS-determinant, the 
## dimension and the maximal vertex label of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]);
## <SimplicialComplex: unnamed complex 7 | dim = 1 | n = 6>
## gap> SCExamineComplexBistellar(obj);
## <SimplicialComplex: unnamed complex 7 | dim = 1 | n = 6>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCReduceComplexEx">
## <ManSection>
## <Func Name="SCReduceComplexEx" Arg="complex, refComplex, 
## mode, choosemove"/>
## <Returns><C>SCBistellarOptions.WriteLevel=0</C>: a triple of the form 
## <C>[ boolean, simplicial complex, rounds  ]</C> upon termination of the 
## algorithm.<P/>
## <C>SCBistellarOptions.WriteLevel=1</C>: A library of simplicial complexes 
## with a number of complexes from the reducing process and (upon termination) 
## a triple of the form <C>[ boolean, simplicial complex, rounds ]</C>.<P/>
## <C>SCBistellarOptions.WriteLevel=2</C>: A mail in case a smaller version 
## of <Arg>complex1</Arg> was found, a library of simplicial complexes with 
## a number of complexes from the reducing process and (upon termination) a 
## triple of the form <C>[ boolean, simplicial complex, rounds ]</C>.<P/>
## Returns <K>fail</K> upon an error.</Returns>
## <Description>
## Reduces a pure simplicial complex <Arg>complex</Arg> satisfying the weak 
## pseudomanifold property via bistellar moves <Arg>mode = 0</Arg>, compares 
## it to the simplicial complex <Arg>refComplex</Arg> (<Arg>mode = 1</Arg>) or 
## reduces it as a sub-complex of <Arg>refComplex</Arg> 
## (<Arg>mode = 2</Arg>).<P/>
## <Arg>choosemove</Arg> is a function containing a flip strategy, see also 
## <Ref Func="SCIntFunc.SCChooseMove"/>. <P/>
## The currently smallest complex is stored to the variable <C>minComplex</C>, 
## the currently smallest <M>f</M>-vector to <C>minF</C>. Note that in general 
## the algorithm will not stop until the maximum number of rounds is reached. 
## You can adjust the maximum number of rounds via the property 
## <Ref Var="SCBistellarOptions"/>. The number of rounds performed is returned 
## in the third entry of the triple returned by this function.<P/>
## This function is called by
## <Enum>
## <Item> <Ref Meth="SCReduceComplex" Style="Text"/>,</Item>
## <Item> <Ref Meth="SCEquivalent" Style="Text"/>,</Item>
## <Item> <Ref Meth="SCReduceAsSubcomplex" Style="Text"/>,</Item>
## <Item> <Ref Meth="SCBistellarIsManifold" Style="Text"/>.</Item>
## <Item> <Ref Meth="SCRandomize" Style="Text"/>.</Item>
## </Enum>
## Please see <Ref Func="SCMailIsPending"/> for further information about the 
## email notification system in case <C>SCBistellarOptions.WriteLevel</C> is 
## set to <M>2</M>.<P/>
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save complexes                      
## gap> SCReduceComplexEx(c,SCEmpty(),0,SCIntFunc.SCChooseMove);
## [ true, <SimplicialComplex: unnamed complex 13 | dim = 3 | n = 5>, 7 ]
## gap> SCReduceComplexEx(c,SCEmpty(),0,SCIntFunc.SCChooseMove);
## [ true, <SimplicialComplex: unnamed complex 18 | dim = 3 | n = 5>, 9 ]
## gap> SCMailSetAddress("johndoe@somehost");   
## true
## gap> SCMailIsEnabled();                     
## true
## gap> SCReduceComplexEx(c,SCEmpty(),0,SCIntFunc.SCChooseMove);
## [ true, <SimplicialComplex: unnamed complex 23 | dim = 3 | n = 5>, 7 ]
## ]]></Example>
## Content of sent mail:
## <Example><![CDATA[ 
## Greetings master,
## 
## this is simpcomp 0.0.0 running on comp01.maths.fancytown.edu
##
## I have been working hard for 0 seconds and have a message for you, see below.
## 
## #### START MESSAGE ####
## 
## SCReduceComplex:
## 
## Computed locally minimal complex after 7 rounds:
## 
## [SimplicialComplex
## 
##  Properties known: Boundary, Chi, Date, Dim, F, Faces, Facets, G, H,
##  HasBoundary, Homology, IsConnected, IsManifold, IsPM, Name, SCVertices,
##  Vertices.
## 
##  Name="ReducedComplex_5_vertices_7"
##  Dim=3
##  Chi=0
##  F=[ 5, 10, 10, 5 ]
##  G=[ 0, 0 ]
##  H=[ 1, 1, 1, 1 ]
##  HasBoundary=false
##  Homology=[ [ 0, [ ] ], [ 0, [ ] ], [ 0, [ ] ], [ 1, [ ] ] ]
##  IsConnected=true
##  IsPM=true
## 
## /SimplicialComplex]
## 
## ##### END MESSAGE #####
## 
## That's all, I hope this is good news! Have a nice day.
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCReduceComplex">
## <ManSection>
## <Meth Name="SCReduceComplex" Arg="complex"/>
## <Returns> <C>SCBistellarOptions.WriteLevel=0</C>: a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C> upon termination 
## of the algorithm.<P/>
## <C>SCBistellarOptions.WriteLevel=1</C>: A library of simplicial complexes 
## with a number of complexes from the reducing process and (upon termination) 
## a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## <C>SCBistellarOptions.WriteLevel=2</C>: A mail in case a smaller version 
## of <Arg>complex1</Arg> was found, a library of simplicial complexes with a 
## number of complexes from the reducing process and (upon termination) a 
## triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## Returns <K>fail</K> upon an error..</Returns>
## <Description>
## Reduces a pure simplicial complex <Arg>complex</Arg> satisfying the weak 
## pseudomanifold property via bistellar moves. 
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text" />
## <C>(complex,SCEmpty(),0,SCIntFunc.SCChooseMove);</C>
## <Example><![CDATA[
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]);; # hexagon
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save complexes                      
## gap> tmp := SCReduceComplex(obj);
## [ true, <SimplicialComplex: unnamed complex 27 | dim = 1 | n = 3>, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCEquivalent">
## <ManSection>
## <Meth Name="SCEquivalent" Arg="complex1, complex2"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> or a list 
## of type <C>[ fail, SCSimplicialComplex, Integer, facet list]</C> 
## otherwise.</Returns>
## <Description>
## Checks if the simplicial complex <Arg>complex1</Arg> (which has to fulfill 
## the weak pseudomanifold property with empty boundary) can be reduced to the 
## simplicial complex <Arg>complex2</Arg> via bistellar moves, i. e. if 
## <Arg>complex1</Arg> and <Arg>complex2</Arg> are <M>PL</M>-homeomorphic. 
## Note that in general the problem is undecidable. In this case <K>fail</K> 
## is returned.<P/>
## It is recommended to use a minimal triangulation <Arg>complex2</Arg> for 
## the check if possible.<P/>
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text"/>
## <C>(complex1,complex2,1,SCIntFunc.SCChooseMove);</C>
## <Example><![CDATA[
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save complexes to disk
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]);; # hexagon
## gap> refObj:=SCBdSimplex(2);; # triangle as a (minimal) reference object
## gap> SCEquivalent(obj,refObj);
## #I  SCReduceComplexEx: complexes are bistellarly equivalent.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCReduceAsSubcomplex">
## <ManSection>
## <Meth Name="SCReduceAsSubcomplex" Arg="complex1, complex2"/>
## <Returns> <C>SCBistellarOptions.WriteLevel=0</C>: a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed  ]</C> upon termination 
## of the algorithm.<P/>
## <C>SCBistellarOptions.WriteLevel=1</C>: A library of simplicial complexes 
## with a number of complexes from the reducing process and (upon termination) 
## a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## <C>SCBistellarOptions.WriteLevel=2</C>: A mail in case a smaller version of 
## <Arg>complex1</Arg> was found, a library of simplicial complexes with a 
## number of complexes from the reducing process and (upon termination) a 
## triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## Returns <K>fail</K> upon an error.</Returns>
## <Description>
## Reduces a  simplicial complex <Arg>complex1</Arg> (satisfying the weak 
## pseudomanifold property with empty boundary) as a sub-complex of the 
## simplicial complex <Arg>complex2</Arg>. <P/> 
## Main application: Reduce a sub-complex of the cross polytope without 
## introducing diagonals.
## <P/>
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text"  />
## <C>(complex1,complex2,2,SCIntFunc.SCChooseMove);</C>
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,3],[3,5],[4,5],[4,1]]);;
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save any complexes                      
## gap> SCReduceAsSubcomplex(c,SCBdCrossPolytope(3));
## [ true, <SimplicialComplex: unnamed complex 36 | dim = 1 | n = 3>, 1 ]
##]]></Example>
##</Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCBistellarIsManifold">
## <ManSection>
## <Meth Name="SCBistellarIsManifold" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> 
## otherwise.</Returns> 
## <Description>
## Tries to prove that a closed simplicial <M>d</M>-pseudomanifold is a 
## combinatorial manifold by reducing its vertex links to the boundary of the 
## d-simplex.<P/>
## <K>false</K> is returned if it can be proven that there exists a vertex link 
## which is not PL-homeomorphic to the standard PL-sphere, <K>true</K> is 
## returned if all vertex links are bistellarly equivalent to the boundary of 
## the simplex, <K>fail</K> is returned if the algorithm does not terminate 
## after the number of rounds indicated by 
## <C>SCBistellarOptions.MaxIntervallIsManifold</C>.<P/>
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text"/>
## <C>(link,SCEmpty(),0,SCIntFunc.SCChooseMove);</C> for every link of 
## <Arg>complex</Arg>. Note that <K>false</K> is returned in case of a bounded 
## manifold.<P/>
##
## See <Ref Func="SCIsManifoldEx" /> and <Ref Func="SCIsManifold" /> for 
## alternative methods for manifold verification.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> SCBistellarIsManifold(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsKStackedSphere">
## <ManSection>
## <Meth Name="SCIsKStackedSphere" Arg="complex, k"/>
## <Returns>a list upon success, <K>fail</K> otherwise.</Returns> 
## <Description>
## Checks, whether the given simplicial complex <Arg>complex</Arg> that must 
## be a PL <M>d</M>-sphere is a <Arg>k</Arg>-stacked sphere with 
## <M>1\leq k\leq \lfloor\frac{d+2}{2}\rfloor</M> using a randomized algorithm 
## based on bistellar moves (see 
## <Cite Key="Effenberger09StackPolyTightTrigMnf" />,
## <Cite Key="Effenberger10Diss" />). Note that it is not checked whether 
## <Arg>complex</Arg> is a PL sphere -- if not, the algorithm will not succeed.
## Returns a list upon success: the first entry is a boolean, where 
## <K>true</K>  means that the complex is <C>k</C>-stacked and <K>false</K> 
## means that the complex cannot be <Arg>k</Arg>-stacked. A value of -1 means 
## that the question could not be decided. The second argument contains a 
## simplicial complex that, in case of success, contains the trigangulated 
## <M>(d+1)</M>-ball <M>B</M> with <M>\partial B=S</M> and 
## <M>\operatorname{skel}_{d-k}(B)=\operatorname{skel}_{d-k}(S)</M>, 
## where <M>S</M> denotes the simplicial complex passed in 
## <Arg>complex</Arg>.<P/>   
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text" />.
## <Example><![CDATA[
## gap> SCLib.SearchByName("S^4~S^1");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> l:=SCLink(c,1);
## <SimplicialComplex: lk([ 1 ]) in S^4~S^1 (VT) | dim = 4 | n = 12>
## gap> SCIsKStackedSphere(l,1);
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## [ true, 
##   <SimplicialComplex: Filled 1-stacked sphere (lk([ 1 ]) in S^4~S^1 (VT)) | di\
## m = 5 | n = 12> ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRandomize">
## <ManSection>
## <Func Name="SCRandomize" Arg="complex [ [, rounds] [,allowedmoves] ]"/>
## <Returns>a simplicial complex upon success, <K>fail</K> otherwise.</Returns> 
## <Description>
## Randomizes the given simplicial complex <Arg>complex</Arg> via bistellar 
## moves chosen at random. By passing the optional array 
## <Arg>allowedmoves</Arg>, which has to be a dense array of integer values 
## of length <C>SCDim(complex)</C>, certain moves can be allowed or forbidden 
## in the proccess. An entry <C>allowedmoves[i]=1</C> allows <M>(i-1)</M>-moves 
## and an entry <C>allowedmoves[i]=0</C> forbids <M>(i-1)</M>-moves in the 
## randomization process.<P />With optional positive integer argument 
## <Arg>rounds</Arg>, the amount of randomization can be controlled. The 
## higher the value of <Arg>rounds</Arg>, the more bistellar moves will be 
## randomly performed on <Arg>complex</Arg>. Note that the argument 
## <Arg>rounds</Arg> overrides the global setting 
## <C>SCBistellarOptions.MaxIntervalRandomize</C> (this value is used, if 
## <Arg>rounds</Arg> is not specified).       
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text" />.
## <Example><![CDATA[
## gap> c:=SCRandomize(SCBdSimplex(4));
## <SimplicialComplex: Randomized S^3_5 | dim = 3 | n = 16>
## gap> c.F;
## [ 16, 65, 98, 49 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCReduceComplexFast">
## <ManSection>
## <Func Name="SCReduceComplexFast" Arg="complex"/>
## <Returns>a simplicial complex upon success, <K>fail</K> otherwise.</Returns> 
## <Description>
## Same as <Ref Func="SCReduceComplex" Style="Text" />, but calls an external 
## binary provided with the simpcomp package.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
