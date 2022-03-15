################################################################################
##
##  simpcomp / complex.gi
##
##  GAP object type for simplicial complex   
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCIsSimplicialComplex">
## <ManSection>
## <Filt Name="SCIsSimplicialComplex" Arg="object"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Checks if <Arg>object</Arg> is of type <C>SCSimplicialComplex</C>. The 
## object type <C>SCSimplicialComplex</C> is derived from the object type 
## <C>SCPropertyObject</C>.
## <Example><![CDATA[
## gap> c:=SCEmpty();;
## gap> SCIsSimplicialComplex(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDetails">
## <ManSection>
## <Func Name="SCDetails" Arg="complex"/>
## <Returns>a string of type <C>IsString</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## The function returns a list of known properties of <Arg>complex</Arg>
## an lists some of these properties explicitly.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4],[2,3,4]]);
## <SimplicialComplex: unnamed complex 1 | dim = 2 | n = 4>
## gap> Print(SCDetails(c));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
##  Name="unnamed complex 1"
##  Dim=2
## 
## /SimplicialComplex]
## gap> c.F;
## [ 4, 6, 4 ]
## gap> c.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> Print(SCDetails(c));
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Homology, Name, Vertices.
##  Name="unnamed complex 1"
##  Dim=2
##  Homology=[ [ 0, [ ] ], [ 0, [ ] ], [ 1, [ ] ] ]
## 
## /SimplicialComplex]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpPlusSCInt">
## <ManSection>
## <Meth Name="Operation + (SCSimplicialComplex, Integer)" Arg="complex, value"/>
## <Returns>the simplicial complex passed as argument upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Positively shifts the vertex labels of <Arg>complex</Arg> (provided that 
## all labels satisfy the property <C>IsAdditiveElement</C>) by the amount 
## specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3)+10;;
## gap> c.Facets;
## [ [ 11, 12, 13 ], [ 11, 12, 14 ], [ 11, 13, 14 ], [ 12, 13, 14 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpMinusSCInt">
## <ManSection>
## <Meth Name="Operation - (SCSimplicialComplex, Integer)" Arg="complex, value"/>
## <Returns>the simplicial complex passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Negatively shifts the vertex labels of <Arg>complex</Arg> (provided that 
## all labels satisfy the property <C>IsAdditiveElement</C>) by the amount 
## specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3)-1;;
## gap> c.Facets;
## [ [ 0, 1, 2 ], [ 0, 1, 3 ], [ 0, 2, 3 ], [ 1, 2, 3 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="Operation * (SCSimplicialComplex, Integer)">
## <ManSection>
## <Meth Name="Operation * (SCSimplicialComplex, Integer" Arg="complex, value"/>
## <Returns>the simplicial complex passed as argument upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Multiplies the vertex labels of <Arg>complex</Arg> (provided that all 
## labels satisfy the property <C>IsAdditiveElement</C>) with the integer 
## specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3)*10;;
## gap> c.Facets;
## [ [ 10, 20, 30 ], [ 10, 20, 40 ], [ 10, 30, 40 ], [ 20, 30, 40 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpModSCInt">
## <ManSection>
## <Meth Name="Operation mod (SCSimplicialComplex, Integer)" Arg="complex, value"/>
## <Returns>the simplicial complex passed as argument upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Takes all vertex labels of <Arg>complex</Arg> modulo the value specified 
## in <Arg>value</Arg> (provided that all labels satisfy the property 
## <C>IsAdditiveElement</C>). Warning: this might result in different vertices 
## being assigned the same label or even in invalid facet lists, so be careful.
## <Example><![CDATA[
## gap> c:=(SCBdSimplex(3)*10) mod 7;;
## gap> c.Facets;
## [ [ 2, 3, 5 ], [ 2, 3, 6 ], [ 2, 5, 6 ], [ 3, 5, 6 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpPowSCInt">
## <ManSection>
## <Meth Name="Operation ^ (SCSimplicialComplex, Integer)" Arg="complex, value"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the <Arg>value</Arg>-th simplicial cartesian power of 
## <Arg>complex</Arg>, i.e. the <Arg>value</Arg>-fold cartesian product of 
## copies of <Arg>complex</Arg>. The complex passed as argument is not altered. 
## Internally calls <Ref Func="SCCartesianPower"/>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(2)^2; #a torus
## <SimplicialComplex: (S^1_3)^2 | dim = 2 | n = 9>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpPlusSCSC">
## <ManSection>
## <Meth Name="Operation + (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the connected sum of <Arg>complex1</Arg> and <Arg>complex2</Arg>. 
## Uses the lexicographically first facets of both complexes to do the gluing. 
## The complexes passed as arguments are not altered. Internally calls 
## <Ref Func="SCConnectedSum"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^3");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCLib.SearchByName("S^2~S^1"){[1..3]};
## [ [ 12, "S^2~S^1 (VT)" ], [ 26, "S^2~S^1 (VT)" ], [ 27, "S^2~S^1 (VT)" ] ]
## gap> d:=SCLib.Load(last[1][1]);;
## gap> c:=c+d; #form RP^3#(S^2~S^1)
## <SimplicialComplex: RP^3#+-S^2~S^1 (VT) | dim = 3 | n = 16>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpMinusSCSC">
## <ManSection>
## <Meth Name="Operation - (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Calls <Ref Func="SCDifference" Style="Text" />(<Arg>complex1</Arg>, 
## <Arg>complex2</Arg>)
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpMultSCSC">
## <ManSection>
## <Meth Name="Operation * (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the simplicial cartesian product of <Arg>complex1</Arg> and 
## <Arg>complex2</Arg>. Internally calls <Ref Func="SCCartesianProduct"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> c:=SCLib.Load(last[1][1])*SCBdSimplex(3); #form RP^2 x S^2
## <SimplicialComplex: RP^2 (VT)xS^2_4 | dim = 4 | n = 24>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpEqSCSC">
## <ManSection>
## <Meth Name="Operation = (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Calculates whether two simplicial complexes are isomorphic, i.e. are 
## equal up to a relabeling of the vertices.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> c=c+10;
## true
## gap> c=SCBdCrossPolytope(4);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpUnionSCSC">
## <ManSection>
## <Meth Name="Operation Union (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the union of two simplicial complexes by calling 
## <Ref Func="SCUnion"/>.
## <Example><![CDATA[
## gap> c:=Union(SCBdSimplex(3),SCBdSimplex(3)+3); #a wedge of two 2-spheres
## <SimplicialComplex: S^2_4 cup S^2_4 | dim = 2 | n = 7>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpDiffSCSC">
## <ManSection>
## <Meth Name="Operation Difference (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the ``difference'' of two simplicial complexes by calling 
## <Ref Func="SCDifference" />.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> d:=SC([[1,2,3]]);;
## gap> disc:=Difference(c,d);;
## gap> disc.Facets;
## [ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
## gap> empty:=Difference(d,c);;
## gap> empty.Dim;
## -1
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCOpIsecSCSC">
## <ManSection>
## <Meth Name="Operation Intersection (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the ``intersection'' of two simplicial complexes by calling 
## <Ref Func="SCIntersection" />.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;        
## gap> d:=SCBdSimplex(3);;        
## gap> d:=SCMove(d,[[1,2,3],[]]);;
## gap> d:=d+1;;                   
## gap> s1.Facets;                 
## Error, Variable: 's1' must have a value
## not in any function at *stdin*:77
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCShallowCopy">
## <ManSection>
## <Meth Name="ShallowCopy (SCSimplicialComplex)" Arg="complex"/>
## <Returns>a copy of <Arg>complex</Arg> upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Makes a copy of <Arg>complex</Arg>. This is actually a ``deep copy'' 
## such that all properties of the copy can be altered without changing 
## the original complex. Internally calls <Ref Func="SCCopy"/>.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(7);;
## gap> d:=ShallowCopy(c)+10;;
## gap> c.Facets=d.Facets;
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCopy">
## <ManSection>
## <Meth Name="SCCopy" Arg="complex"/>
## <Returns>a copy of <Arg>complex</Arg> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Makes a ``deep copy'' of <Arg>complex</Arg> -- this is a copy such that 
## all properties of the copy can be altered without changing the original 
## complex.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> d:=SCCopy(c)-1;;
## gap> c.Facets=d.Facets;
## false
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> d:=SCCopy(c);;
## gap> IsIdenticalObj(c,d);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSize">
## <ManSection>
## <Meth Name="Size (SCSimplicialComplex)" Arg="complex"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the ``size'' of a simplicial complex. This is <M>d+1</M>, where 
## <M>d</M> is the dimension of the complex. <M>d+1</M> is returned instead 
## of <M>d</M>, as all lists in &GAP; are indexed beginning with 1 -- thus 
## this also holds for all the face lattice related properties of the complex.   
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F=[12,66,108,54]");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> for i in [1..Size(c)] do Print(c.F[i],"\n"); od;
## 12
## 66
## 108
## 54
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLength">
## <ManSection>
## <Meth Name="Length (SCSimplicialComplex)" Arg="complex"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the ``size'' of a simplicial complex by calling 
## <C>Size(</C><Arg>complex</Arg><C>)</C>.   
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F=[12,66,108,54]");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> for i in [1..Length(c)] do Print(c.F[i],"\n"); od;
## 12
## 66
## 108
## 54
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCAccess">
## <ManSection>
## <Meth Name="Operation [] (SCSimplicialComplex)" Arg="complex, pos"/>
## <Returns>a list of faces upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the <M>(pos-1)</M>-dimensional faces of <Arg>complex</Arg> as a 
## list. If <M>pos \geq d+2</M>, where <M>d</M> is the dimension of 
## <Arg>complex</Arg>, the empty set is returned. Note that <Arg>pos</Arg> 
## must be <M>\geq 1</M>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2");
## [ [ 18, "K^2 (VT)" ], [ 221, "K^2 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c[2];
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ], [ 1, 7 ], [ 1, 9 ], [ 1, 10 ], [ 2, 3 ], 
##   [ 2, 4 ], [ 2, 6 ], [ 2, 8 ], [ 2, 10 ], [ 3, 4 ], [ 3, 5 ], [ 3, 7 ], 
##   [ 3, 9 ], [ 4, 5 ], [ 4, 6 ], [ 4, 8 ], [ 4, 10 ], [ 5, 6 ], [ 5, 7 ], 
##   [ 5, 9 ], [ 6, 7 ], [ 6, 8 ], [ 6, 10 ], [ 7, 8 ], [ 7, 9 ], [ 8, 9 ], 
##   [ 8, 10 ], [ 9, 10 ] ]
## gap> c[4];
## [  ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIterator">
## <ManSection>
## <Meth Name="Iterator (SCSimplicialComplex)" Arg="complex"/>
## <Returns>an iterator on the face lattice of <Arg>complex</Arg> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Provides an iterator object for the face lattice of a simplicial complex.   
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> for faces in c do Print(Length(faces),"\n"); od;
## 8
## 24
## 32
## 16
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertiesDropped">
## <ManSection>
## <Func Name="SCPropertiesDropped" Arg="complex"/>
## <Returns>a object of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## An object of the type <C>SCSimplicialComplex</C> caches its previously 
## calculated properties such that each property only has to be calculated 
## once. This function returns a copy of <Arg>complex</Arg> with all 
## properties (apart from Facets, Dim and Name) dropped, clearing all 
## previously computed properties. See also <Ref Meth="SCPropertyDrop" /> 
## and <Ref Meth="SCPropertyTmpDrop" />.
## <Example><![CDATA[
## gap> c:=SC(SCFacets(SCBdCyclicPolytope(10,12)));
## <SimplicialComplex: unnamed complex 27 | dim = 9 | n = 12>
## gap> c.F; time;                                 
## [ 12, 66, 220, 495, 792, 922, 780, 465, 180, 36 ]
## 39
## gap> c.F; time;                                 
## [ 12, 66, 220, 495, 792, 922, 780, 465, 180, 36 ]
## 71
## gap> c:=SCPropertiesDropped(c);                 
## <SimplicialComplex: unnamed complex 27 | dim = 9 | n = 12>
## gap> c.F; time;                                 
## [ 12, 66, 220, 495, 792, 922, 780, 465, 180, 36 ]
## 54
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
