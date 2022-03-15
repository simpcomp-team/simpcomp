################################################################################
##
##  simpcomp / morse.gi
##
##  Polyhedral Morse functions 
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseMultiplicityVector">
## <ManSection>
## <Meth Name="SCMorseMultiplicityVector" Arg="c, f"/>
## <Returns> a list of <M>(d+1)</M>-tuples if <C>c</C> is a 
## <M>d</M>-dimensional simplicial complex upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Computes all multiplicity vectors of a rsl-function <C>f</C> on a simplicial
## complex <C>c</C>. <C>f</C> is given as an ordered list 
## <M>(v_1 , \ldots v_n)</M> of all vertices  of <C>c</C> where <C>f</C> is 
## defined by <C>f</C><M>(v_i) = \frac{i-1}{n-1}</M>. The <M>i</M>-th entry 
## of the returned list denotes the multiplicity vector of vertex <M>v_i</M>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");      
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> c:=SCLib.Load(last[1][1]);;    
## gap> f:=SCVertices(c);              
## [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ]
## gap> SCMorseMultiplicityVector(c,f);
## [ [ 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ], 
##   [ 0, 0, 2, 0, 0 ], [ 0, 0, 1, 0, 0 ], [ 0, 0, 4, 0, 0 ], [ 0, 0, 3, 0, 0 ], 
##   [ 0, 0, 3, 0, 0 ], [ 0, 0, 4, 0, 0 ], [ 0, 0, 1, 0, 0 ], [ 0, 0, 2, 0, 0 ], 
##   [ 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseNumberOfCriticalPoints">
## <ManSection>
## <Meth Name="SCMorseNumberOfCriticalPoints" Arg="c, f"/>
## <Returns> an integer and a list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the number of critical points of each index of a rsl-function 
## <C>f</C> on a simplicial complex <C>c</C> as well as the total number of 
## critical points.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");      
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> c:=SCLib.Load(last[1][1]);;    
## gap> f:=SCVertices(c);              
## [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ]
## gap> SCMorseNumberOfCriticalPoints(c,f);
## [ 24, [ 1, 0, 22, 0, 1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMorseIsPerfect">
## <ManSection>
## <Meth Name="SCMorseIsPerfect" Arg="c, f"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.
## </Returns>
## <Description>
## Checks whether the rsl-function <C>f</C> is perfect on the simplicial 
## complex <C>c</C> or not. A rsl-function is said to be perfect, if it has 
## the minimum number of critical points, i. e. if the sum of its critical 
## points equals the sum of the Betti numbers of <C>c</C>.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,6);;
## gap> SCMinimalNonFaces(c);
## [ [  ], [  ], [ [ 1, 3, 5 ], [ 2, 4, 6 ] ] ]
## gap> SCMorseIsPerfect(c,[1..6]);
## true
## gap> SCMorseIsPerfect(c,[1,3,5,2,4,6]);   
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSlicing">
## <ManSection>
## <Meth Name="SCSlicing" Arg="complex, slicing"/>
## <Returns> a facet list of a polyhedral complex or a <C>SCNormalSurface</C> 
## object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the pre-image <M>f^{-1} (\alpha )</M> of a rsl-function <M>f</M> on 
## the simplicial complex <Arg>complex</Arg> where <M>f</M> is given in the 
## second argument <Arg>slicing</Arg> by a partition of the set of vertices 
## <Arg>slicing</Arg><M>=[ V_1 , V_2 ]</M> such that <M>f(v_1)</M> 
## (<M>f(v_2)</M>) is smaller (greater) than <M>\alpha</M> for all <M>v_1 
## \in V_1</M> (<M>v_2 \in V_2</M>).<P/>
##
## If <Arg>complex</Arg> is of dimension <M>3</M>, a &GAP; object of type 
## <C>SCNormalSurface</C> is returned. Otherwise only the facet list is 
## returned. See also <Ref Meth="SCNSSlicing"/>.<P/>
##
## The vertex labels of the returned slicing are of the form 
## <M>(v_1 , v_2)</M> where <M>v_1 \in V_1</M> and <M>v_2 \in V_2</M>. They 
## represent the center points of the edges <M>\rangle v_1 , v_2 \langle </M> 
## defined by the intersection of <Arg>slicing</Arg> with <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,6);;
## gap> v:=SCVertices(c);
## [ 1 .. 6 ]
## gap> SCMinimalNonFaces(c);
## [ [  ], [  ], [ [ 1, 3, 5 ], [ 2, 4, 6 ] ] ]
## gap> ns:=SCSlicing(c,[v{[1,3,5]},v{[2,4,6]}]);     
## <NormalSurface: slicing [ [ 1, 3, 5 ], [ 2, 4, 6 ] ] of Bd(C_4(6)) | dim = 2>
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> v:=SCVertices(c);
## [ 1 .. 6 ]
## gap> slicing:=SCSlicing(c,[v{[1,3,5]},v{[2,4,6]}]);
## [ [ [ 1, 2 ], [ 1, 4 ], [ 3, 2 ], [ 3, 4 ], [ 5, 2 ], [ 5, 4 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 4 ], [ 3, 6 ] ], 
##   [ [ 1, 2 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 6 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 6 ], [ 5, 2 ], [ 5, 4 ], [ 5, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 6 ], [ 3, 4 ], [ 3, 6 ], [ 5, 4 ], [ 5, 6 ] ], 
##   [ [ 3, 2 ], [ 3, 4 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 5, 6 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIsTight">
## <ManSection>
## <Meth Name="SCIsTight" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.
## </Returns>
## <Description>
##
## Checks whether a simplicial complex <C>complex</C> (<C>complex</C> must
## satisfy the weak pseudomanifold property and must be closed) is a tight 
## triangulation 
## (with respect to the field with two elements) or not. A simplicial complex 
## with <M>n</M> vertices is said to be a tight 
## triangulation if it can be tightly embedded into the <M>(n-1)</M>-simplex. 
## See Section <Ref Chap="sec:tight" /> for a short introduction to the field 
## of tightness.<P/>
##
## First, if <C>complex</C> is a <M>(k+1)</M>-neighborly <M>2k</M>-manifold 
## (cf.  <Cite Key="Kuehnel95TightPolySubm" />, Corollary 4.7), or  
## <C>complex</C> is of dimension <M>d\geq 4</M>, <M>2</M>-neighborly and all 
## its vertex links are stacked spheres (i.e. the complex is in Walkup's class 
## <M>K(d)</M>, see <Cite Key="Effenberger09StackPolyTightTrigMnf" />)
## <K>true</K> is returned as the complex is a tight triangulation in these 
## cases. If <C>complex</C> is of dimension <M>d = 3</M>, <K>true</K> is 
## returned if and only if <C>complex</C> is <M>2</M>-neighborly and stacked 
## (i.e. tight-neighbourly, see <Cite Key="BDSSSepIndex" />), otherwise 
## <K>false</K> is returned, see <Cite Key="Bagchi16Tight3Mflds" />.<P/>
##
## Note that, for dimension <M>d \geq 4</M>, it is not computed whether or not 
## <C>complex</C> is a 
## combinatorial manifold as this computation might take a long time. Hence, 
## only if the manifold flag of the complex is set (this can be achieved by 
## calling <Ref Meth="SCIsManifold" /> and the complex indeed is a 
## combinatorial manifold) these checks are performed.<P/>
##
## In a second step, the algorithm first checks certain rsl-functions allowing 
## slicings between minimal non faces and the rest of the complex. In most 
## cases where <C>complex</C> is not tight at least one of these rsl-functions 
## is not perfect and thus <C>false</C> is returned as the complex is not a 
## tight triangulation.<P/>
## 
## If the complex passed all checks so far, the remaining rsl-functions are 
## checked for being perfect functions. As there are ``only'' <M>2^n</M> 
## different multiplicity vectors, but <M>n!</M> different rsl-functions, a 
## lookup table containing all possible multiplicity vectors is computed first. 
## Note that nonetheless the complexity of this algorithm is <M>O(n!)</M>.<P/>
##
## In order to reduce the number of rsl-functions that need to be checked, the 
## automorphism group of <C>complex</C> is computed first using 
## <Ref Meth="SCAutomorphismGroup" />. In case it is <M>k</M>-transitive, the 
## complexity is reduced by the factor of <M>n \cdot (n-1) \cdot \dots \cdot 
## (n-k+1)</M>.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2~S^1 (VT)"){[1..9]};;
## gap> s2s1:=SCLib.Load(list[1][1]);
## <SimplicialComplex: S^2~S^1 (VT) | dim = 3 | n = 9>
## gap> SCInfoLevel(2); # print information while running
## true
## gap> SCIsTight(s2s1); time;
## #I  SCIsTight: complex is 3-dimensional and tight neighbourly, and thus tight.
## true
## 2
## ]]></Example> 
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F[1] = 120");
## [ [ 648, "Bd(600-cell)" ] ]
## gap> id:=last[1][1];;
## gap> c:=SCLib.Load(id);;
## gap> SCIsTight(c); time;
## #I  SCIsTight: complex is connected but not 2-neighbourly, and thus not tight.
## false
## 194392
## ]]></Example>
## <Example><![CDATA[
## gap> SCInfoLevel(0);
## true
## gap> SCLib.SearchByName("K3");  
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCIsManifold(c);
## true
## gap> SCInfoLevel(1);
## true
## gap> c.IsTight;                 
## #I  SCIsTight: complex is (k+1)-neighborly 2k-manifold and thus tight.
## true
## ]]></Example>
## <Example><![CDATA[
## gap> SCInfoLevel(1);
## true
## gap> dc:=[ [ 1, 1, 1, 1, 45 ], [ 1, 2, 1, 27, 18 ], [ 1, 27, 9, 9, 3 ], 
## > [ 4, 7, 20, 9, 9 ], [ 9, 9, 11, 9, 11 ], [ 6, 9, 9, 17, 8 ], 
## > [ 6, 10, 8, 17, 8 ], [ 8, 8, 8, 8, 17 ], [ 5, 6, 9, 9, 20 ] ];;
## gap> c:=SCBoundary(SCFromDifferenceCycles(dc));;
## gap> SCAutomorphismGroup(c);;
## gap> SCIsTight(c);
## #I  SCIsTight: complex is (k+1)-neighborly 2k-manifold and thus tight.
## true
## ]]></Example>
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^3xS^1");;
## gap> c:=SCLib.Load(list[1][1]);           
## <SimplicialComplex: S^3xS^1 (VT) | dim = 4 | n = 11>
## gap> SCInfoLevel(0);
## true
## gap> SCIsManifold(c);
## true
## gap> SCInfoLevel(2); 
## true
## gap> c.IsTight;                
## #I  SCIsInKd: checking link 1/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 2/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 3/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 4/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 5/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 6/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 7/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 8/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 9/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 10/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: checking link 11/11
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/1
## #I  round 0
## Reduced complex, F: [ 9, 26, 34, 17 ]
## #I  round 1
## Reduced complex, F: [ 8, 22, 28, 14 ]
## #I  round 2
## Reduced complex, F: [ 7, 18, 22, 11 ]
## #I  round 3
## Reduced complex, F: [ 6, 14, 16, 8 ]
## #I  round 4
## Reduced complex, F: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsInKd: all links are 1-stacked.
## #I  SCIsTight: complex is in class K(1) and 2-neighborly, thus tight.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
