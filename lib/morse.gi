################################################################################
##
##  simpcomp / morse.gi
##
##  Polyhedral Morse functions 
##
##  $Id$
##
################################################################################

SCIntFunc.MorseLevel:=function(c,lower,upper)
  
  local star,lowStar,beta,morseLevel,i,dim,kron1;
  
  kron1:=function(a) if a = 1 then return 1; fi; return 0; end;
  
  if upper = [] then
    Info(InfoSimpcomp,1,"SCIntFunc.MorseLevel: invalid arguments.");
    return fail;
  fi;
  dim:=SCDim(c);
  if dim = fail then
    return fail;
  fi;
  star:=SCStar(c,[upper[1]]);
  if star = fail then
    return fail;
  fi;
  lowStar:=SCSpan(star,lower);
  if lowStar = fail then
    return fail;
  fi;
  beta:=ShallowCopy(SCFpBettiNumbers(lowStar,2));
  if beta = fail then
    return fail;
  fi;
  if beta = [] then
    return List([1..dim+1],x->kron1(x));
  else
    beta[1]:=beta[1]-1;
    morseLevel:=Concatenation([0],beta{[1..Size(beta)]});
  fi;
  for i in [Size(beta)+2..dim+1] do
    morseLevel[i]:=0;
  od;
  
  return morseLevel;
  
end;
  


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
## [ [ 1, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], 
##   [ 0, 0, 1, 0, 0 ], [ 0, 0, 2, 0, 0 ], [ 0, 0, 1, 0, 0 ], 
##   [ 0, 0, 4, 0, 0 ], [ 0, 0, 3, 0, 0 ], [ 0, 0, 3, 0, 0 ], 
##   [ 0, 0, 4, 0, 0 ], [ 0, 0, 1, 0, 0 ], [ 0, 0, 2, 0, 0 ], 
##   [ 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0 ], 
##   [ 0, 0, 0, 0, 1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseMultiplicityVector,
  function(c,f)

  local dim, verts, tmp, j, mv;
  
   if not SCIsSimplicialComplex(c) then
     Info(InfoSimpcomp,1,"SCMorseMultiplicityVector: first argument must be ",
      "of type SCSimplicialComplex.");
     return fail;
   fi;
  mv:=[];
  dim:=SCDim(c);
  if dim = fail then
    return fail;
  fi;
  
  if dim < 1 then 
    Info(InfoSimpcomp,1,"SCMultiplicityVector: Complex must be at least ",
      "1-dimensional.");
    return fail;
  fi;

  verts:=ShallowCopy(SCVertices(c));
  if verts = fail then
    return fail;
  fi;

  Sort(verts);
  tmp:=ShallowCopy(f);
  Sort(tmp);

  if verts <> tmp then
    Info(InfoSimpcomp,1,"SCMultiplicityVector: Vertex ordering not valid. ",
      "Second argument must equal a permuted list of vertex labels.");
    return fail;
  fi;

  for j in [1..Size(f)] do
    mv[j]:=SCIntFunc.MorseLevel(c,f{[1..j-1]},f{[j..Size(f)]});
  od;

  return mv;

end);


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
InstallGlobalFunction(SCMorseNumberOfCriticalPoints,
  function(c,f)
  
  local mv, numCP, i, verts, tmp;
  
   if not SCIsSimplicialComplex(c) then
     Info(InfoSimpcomp,1,"SCMorseNumberOfCriticalPoints: first argument must ",
       "be of type SCSimplicialComplex.");
     return fail;
   fi;
  
    verts:=ShallowCopy(SCVertices(c));
  if verts = fail then
    return fail;
  fi;

  Sort(verts);
  tmp:=ShallowCopy(f);
  Sort(tmp);

  if verts <> tmp then
    Info(InfoSimpcomp,1,"SCMorseNumberOfCriticalPoints: Vertex ordering not ",
      "valid. Second argument must equal a permuted list of vertex labels.");
    return fail;
  fi;

  mv:=SCMorseMultiplicityVector(c,f);
  if mv=fail then
    return fail;
  fi;

  numCP:=[];
  for i in [1..Size(mv[1])] do
    numCP[i]:=Sum(List(mv,x->x[i]));
  od;
  return [Sum(numCP),numCP];
end);


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
InstallGlobalFunction(SCMorseIsPerfect,
  function(c,f)

   local betti, sumMv, verts, tmp, j;

  if not SCIsSimplicialComplex(c) then
     Info(InfoSimpcomp,1,"SCMorseIsPerfect: first argument must be of type ",
       "SCSimplicialComplex.");
     return fail;
   fi;
  
  verts:=ShallowCopy(SCVertices(c));
  if verts = fail then
    return fail;
  fi;

  Sort(verts);
  tmp:=ShallowCopy(f);
  Sort(tmp);

  if verts <> tmp then
    Info(InfoSimpcomp,1,"SCMorseIsPerfect: Vertex ordering not valid. Second ",
      "argument must equal a permuted list of vertex labels.");
    return fail;
  fi;
  
  betti:=SCFpBettiNumbers(c,2);
  if betti = fail then
    return fail;
  fi;

  sumMv:=SCIntFunc.MorseLevel(c,[],f);
  for j in [2..Size(f)] do
    sumMv:=sumMv+SCIntFunc.MorseLevel(c,f{[1..j-1]},f{[j..Size(f)]});
    if Minimum(betti-sumMv) < 0 then
      return false;
    fi;
  od;
  
  return true;
end);

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
## [ 1, 2, 3, 4, 5, 6 ]
## gap> SCMinimalNonFaces(c);
## [ [  ], [  ], [ [ 1, 3, 5 ], [ 2, 4, 6 ] ] ]
## gap> ns:=SCSlicing(c,[v{[1,3,5]},v{[2,4,6]}]);     
## [NormalSurface
## 
##  Properties known: Chi, ConnectedComponents, Dim, F, Facets, Genus, IsConnecte\
## d, Name, Oriented, Subdivision, TopologicalType, SCVertices, Vertices.
## 
##  Name="slicing [ [ 1, 3, 5 ], [ 2, 4, 6 ] ] of Bd(C_4(6))"
##  Dim=2
##  Chi=0
##  F=[ 9, 18, 0, 9 ]
##  IsConnected=true
##  TopologicalType="T^2"
## 
## /NormalSurface]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> v:=SCVertices(c);
## [ 1, 2, 3, 4, 5, 6 ]
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
InstallGlobalFunction(SCSlicing,
function(complex,slicing)
  local vertices, facets, nsfacets, dim, tmp, tmp1, tmp2, i;

  if not SCIsSimplicialComplex(complex) then
    Info(InfoSimpcomp,1,"SCSlicing: first argument must be of type ",
      "SCSimplicialComplex.");
    return fail;
  fi;
  dim:=SCDim(complex);
  if dim = fail or dim < 1 then
       Info(InfoSimpcomp,1,"SCSlicing: first argument must be of type ",
         "SCSimplicialComplex of dimension > 0");
      return fail;
  fi;
  
  if dim = 3 then
    return SCNSSlicing(complex,slicing);
  fi;
  
   vertices:=SCVertices(complex);
   facets:=SCFacets(complex);
  if vertices = fail or facets = fail then
    return fail;
  fi;
  tmp:=Union(ShallowCopy(slicing));
  Sort(tmp);
   if(not IsList(slicing) or Size(slicing)<>2 or tmp<>vertices) then
     Info(InfoSimpcomp,1,"SCSlicing: slicing must be a partition of ",
       "'vertices'"); 
     return fail;
   fi;

   nsfacets:=[];
  for i in [1..Size(facets)] do
    tmp1:=Intersection(facets[i], slicing[1]);
    tmp2:=Intersection(facets[i], slicing[2]);
    if tmp1<>[] and tmp2<>[] then
      Add(nsfacets,Cartesian(tmp1,tmp2));
     fi;
  od;
  
  return nsfacets;
end);

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
## gap> SCInfoLevel(2); # print information while running
## gap> SCIsTight(s2s1); time;
## #I  SCIsTight: checking non faces...
## #I  SCIsTight: found no contradiction so far.
## #I  SCIsTight: generating lookup table...
## #I  SCIsTight: lookup table done, size = 2304.
## #I  SCIsTight: computing automorphism group...
## #I  SCIsTight: automorphism group done, transitivity = 1.
## #I  SCIsTight: checking rsl-functions...
## #I  SCIsTight: processed 10000 of 40320 rsl-functions so far, all perfect.
## #I  SCIsTight: processed 20000 of 40320 rsl-functions so far, all perfect.
## #I  SCIsTight: processed 30000 of 40320 rsl-functions so far, all perfect.
## #I  SCIsTight: processed 40000 of 40320 rsl-functions so far, all perfect.
## true
## 11217
## ]]></Example> 
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F[1] = 120");
## [ [ 648, "Bd(600-cell)" ] ]
## gap> id:=last[1][1];;
## gap> c:=SCLib.Load(id);;
## gap> SCIsTight(c); time;
## #I  SCIsTight: checking non faces...
## #I  SCIsTight: found non perfect rsl-function: 
## [ 1, 3, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 
##   22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
##   41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 
##   60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 
##   79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 
##   98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 
##   113, 114, 115, 116, 117, 118, 119, 120 ], complex not tight.
## false
## 28
## ]]></Example>
## <Example><![CDATA[
## gap> SCInfoLevel(0);
## gap> SCLib.SearchByName("K3");  
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCIsManifold(c);
## true
## gap> SCInfoLevel(1);
## gap> c.IsTight;                 
## #I  SCIsTight: complex is (k+1)-neighborly 2k-manifold and thus tight.
## true
## ]]></Example>
## <Example><![CDATA[
## gap> SCInfoLevel(1);
## gap> dc:=[ [ 1, 1, 1, 1, 45 ], [ 1, 2, 1, 27, 18 ], [ 1, 27, 9, 9, 3 ], 
## > [ 4, 7, 20, 9, 9 ], [ 9, 9, 11, 9, 11 ], [ 6, 9, 9, 17, 8 ], 
## > [ 6, 10, 8, 17, 8 ], [ 8, 8, 8, 8, 17 ], [ 5, 6, 9, 9, 20 ] ];;
## gap> c:=SCBoundary(SCFromDifferenceCycles(dc));;
## gap> SCAutomorphismGroup(c);;
## gap> SCIsTight(c);
## #I  SCIsKStackedSphere: checking if complex is a 1-stacked sphere...
## #I  SCIsKStackedSphere: try 1/50
## #I  SCIsKStackedSphere: complex is a 1-stacked sphere.
## #I  SCIsTight: complex is 3-dimensional, 2-neighbourly, and stacked, and thus tight.
## true
## ]]></Example>
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^3xS^1");;
## gap> c:=SCLib.Load(list[1][1]);           
## gap> SCInfoLevel(0);
## gap> SCIsManifold(c);
## true
## gap> SCInfoLevel(2); 
## gap> c.IsTight;                
## #I  SCIsInKd: checking link 1/11
## #I  SCIsKStackedSphere: try 1/50
## #I  round 0: [ 9, 26, 34, 17 ]
## #I  round 1: [ 8, 22, 28, 14 ]
## #I  round 2: [ 7, 18, 22, 11 ]
## #I  round 3: [ 6, 14, 16, 8 ]
## #I  round 4: [ 5, 10, 10, 5 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 5 rounds.
## #I  SCIsInKd: complex has transitive automorphism group, all links are 
## 1-stacked.
## #I  SCIsTight: complex is in class K(1) and 2-neighborly, thus tight.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsTight,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
   local cc, dim, conn, connComps, c, tight, nonFaces, i, j, tuple, n, diff, f, 
    vertices, nextFace, beta, ctr, tmpSum, tmp, idx, level, key, fl, faces, nn, 
    G, g, t, order, ism, ispm, iscl;
   
   
  nextFace:=function(face,n)
    local l,i,dim;
    l:=Length(face);
    dim:=l-1;
    face[l]:=face[l]+1;
    
    while(face[l]>n-(dim+1-l) and l>1) do
      l:=l-1;
      face[l]:=face[l]+1;
      for i in [l+1..dim+1] do
        face[i]:=face[i-1]+1;
      od;
    od;
    
    if(l=1 and face[1]>n-dim) then
      return [];
    fi;
    
    return face;
  end;

  dim:=SCDim(complex);
  if dim = fail or dim < 1 then
       Info(InfoSimpcomp,1,"SCIsTight: argument must be of type ",
         "SCSimplicialComplex of dimension > 0.");
      return fail;
  fi;

  ispm:=SCIsPseudoManifold(complex);
  if ispm = fail then
    return fail;
  fi;
  if ispm = false then
    Info(InfoSimpcomp,1,"SCIsTight: argument must be a weak ",
     "pseudomanifold.");
    return fail;
  fi;

  iscl:=SCHasBoundary(complex);
  if iscl = fail then
    return fail;
  fi;
  if iscl = true then
    Info(InfoSimpcomp,1,"SCIsTight: argument must be a closed weak ",
     "pseudomanifold.");
    return fail;
  fi;

  cc:=SCCopy(complex);
  SCRelabelStandard(cc);
  
  conn:=SCIsConnected(cc);
  if conn = fail then
    return fail;
  fi;
  
  if not conn then
    Info(InfoSimpcomp,1,"SCIsTight: complex not connected, checking connected ",
      "components.");
    connComps:=SCConnectedComponents(cc);
    for c in connComps do
      tight:=SCIsTight(c);
      if not tight then
        return false;
      fi;
    od;
    return true;
  fi;

  nonFaces:=SCMinimalNonFaces(cc);
  if nonFaces = fail then
    return fail;
  fi;
  
  vertices:=SCVertices(cc);
  if vertices = fail then
    return fail;
  fi;
  n:=Size(vertices);
  
  if dim <= 3 then
    ism:=SCIsManifold(cc);
    if ism = fail then
      return fail;
    fi;
  fi;

  if SCIsKNeighborly(cc,2) = false then
    Info(InfoSimpcomp,1,"SCIsTight: complex is connected but ",
      "not 2-neighbourly, and thus not tight.");
    return false;
  fi;

  #quick test for manifolds
  if HasSCIsManifold(cc) and SCIsManifold(cc)=true then
    if dim = 1 then
      Info(InfoSimpcomp,1,"SCIsTight: complex is a 1-manifold and ",
        "2-neighbourly, and thus tight.");
      return true;
    fi;

    if IsEvenInt(dim) then
      tmp:=dim/2+1;
      if SCIsKNeighborly(cc,tmp)=true then
        Info(InfoSimpcomp,1,"SCIsTight: complex is (k+1)-neighborly ",
          "2k-manifold and thus tight.");
        return true;
      fi;
    fi;

    if IsOddInt(dim) then
      tmp:=(dim-1)/2+2;
      if SCIsKNeighborly(cc,tmp)=true then
        Info(InfoSimpcomp,1,"SCIsTight: complex is (k+2)-neighborly ",
          "(2k+1)-manifold and thus tight.");
        return true;
      fi;
    fi;

    if dim = 3 then
      beta:=SCFpBettiNumbers(cc,2);
      if  (n-4)*(n-5) = 20*beta[2] then
        Info(InfoSimpcomp,1,"SCIsTight: complex is 3-dimensional and ",
          "tight neighbourly, and thus tight.");
        return true;
      else
         Info(InfoSimpcomp,1,"SCIsTight: complex is 3-dimensional but not ",
          "tight neighbourly, and thus not tight.");
          return true;
      fi;
    fi;     

    if dim>=4 and SCIsKNeighborly(cc,2)=true then
      tmp:=SCIsInKd(cc,1);
      if tmp=true then
        Info(InfoSimpcomp,1,"SCIsTight: complex is in class K(1) and ",
          "2-neighborly, thus tight.");
        return true;
      fi;
      
      if tmp=fail then
        return fail;
      fi;
    fi;

  else
    Info(InfoSimpcomp,1,"SCIsTight: complex is not a manifold or manifold ",
      "property is unknown. Preliminary tests are skipped. If your complex ",
      "is a manifold, set the manifold property and try again.");
  fi;


  # quick test
  Info(InfoSimpcomp,2,"SCIsTight: checking non faces...");
  for i in [1..Size(nonFaces)] do
    for tuple in nonFaces[i] do
      diff:=Difference(vertices,tuple);
      f:=Concatenation(tuple,diff);
      if not SCMorseIsPerfect(cc,f) then
        Info(InfoSimpcomp,2,"SCIsTight: found non perfect rsl-function: ",f,
          ", complex not tight.");
        return false;
      fi;
    od;
  od;
  Info(InfoSimpcomp,2,"SCIsTight: found no contradiction so far.");
  
  # proof
  Info(InfoSimpcomp,2,"SCIsTight: generating lookup table...");
  beta:=SCFpBettiNumbers(cc,2);
  if beta = fail then
    return fail;
  fi;
  fl:=SCFaceLattice(cc);
  if fl = fail then
    return fail;
  fi;
  faces:=Union(fl);
  # compute LUT of all 2^n levels
  level:=[];
  key:=[];
  ctr:=1;
  tmp:=SCIntFunc.MorseLevel(cc,[],vertices);
  for j in [1..n] do
    level[ctr]:=ShallowCopy(tmp);
    key[ctr]:=[j];
    ctr:=ctr+1;
  od;
  for j in [2..n] do
    tuple:=[1..j];
    while tuple <> [] do
      if tuple in faces then
        for i in tuple do
          tmp:=Difference(tuple,[i]);
          level[ctr]:=ListWithIdenticalEntries(dim+1,0);
          key[ctr]:=Concatenation(tmp,[i]);
          ctr:=ctr+1;
        od;
      else
        diff:=Difference(vertices,tuple);
        for i in tuple do
          tmp:=Difference(tuple,[i]);
          level[ctr]:=SCIntFunc.MorseLevel(cc,tmp,Concatenation([i],diff));
          key[ctr]:=Concatenation(tmp,[i]);
          ctr:=ctr+1;
        od;
      fi;
      tuple:=nextFace(tuple,n);
    od;
  od;
  Info(InfoSimpcomp,2,"SCIsTight: lookup table done, size = ",Size(level),".");
  
  Info(InfoSimpcomp,2,"SCIsTight: computing automorphism group...");
  G:=SCAutomorphismGroup(cc);
  t:=Transitivity(G);
  order:=n-t;
  Info(InfoSimpcomp,2,"SCIsTight: automorphism group done, transitivity = ",
    t,".");
  Info(InfoSimpcomp,2,"SCIsTight: checking rsl-functions...");
  ctr:=0;
  nn:=Factorial(order);
  for g in SymmetricGroup(order) do
    tmpSum:=ListWithIdenticalEntries(dim+1,0);
    tuple:=Permuted(vertices,g);
    for j in [1..n] do
      tmp:=ShallowCopy(tuple{[1..j-1]});
      Sort(tmp);
      idx:=Position(key,Concatenation(tmp,[tuple[j]]));
      tmpSum:=tmpSum+level[idx];
    od;
    if Minimum(beta-tmpSum) < 0 then
      Info(InfoSimpcomp,1,"SCIsTight: found non perfect rsl-function: ",tuple,
        ", complex not tight.");
      return false;
    fi;
    ctr:=ctr+1;
    if ctr mod 10000 = 0 then
      Info(InfoSimpcomp,1,"SCIsTight: processed ",ctr," of ",nn,
      " rsl-functions so far, all perfect.");
    fi;
  od;

  return true;
  
end);

