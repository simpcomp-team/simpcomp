################################################################################
##
##  simpcomp / labelops.gi
##
##  Functions operating on the labels of a complex such a the name or the
##  vertex labeling.
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCName">
## <ManSection>
## <Oper Name="SCName" Arg="complex"/>
## <Returns> a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the name of a simplicial complex <Arg>complex</Arg>.
## <Example>
## gap&gt; c:=SCBdSimplex(5);;
## gap&gt; SCName(c);
## "S^4_6"
## </Example>
## <Example>
## gap&gt; c:=SC([[1,2],[2,3],[3,1]]);;
## gap&gt; SCName(c);
## "unnamed complex 2"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRename">
## <ManSection>
## <Meth Name="SCRename" Arg="complex,name"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Renames a polyhedral complex. The argument <Arg>name</Arg> has to be given in form of a string.
## <Example>
## gap&gt; c:=SCBdSimplex(5);;
## gap&gt; SCName(c);
## "S^4_6"
## gap&gt; SCRename(c,"mySphere");
## true
## gap&gt; SCName(c);
## "mySphere"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCReference">
## <ManSection>
## <Oper Name="SCReference" Arg="complex"/>
## <Returns> a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a literature reference of a polyhedral complex <Arg>complex</Arg>.
## <Example>
## gap&gt; c:=SCLib.Load(253);;
## gap&gt; SCReference(c);
## "F.H.Lutz: 'The Manifold Page', http://www.math.tu-berlin.de/diskregeom/stella\
## r/"
## gap&gt; c:=SC([[1,2],[2,3],[3,1]]);;
## gap&gt; SCReference(c);
## #I  SCReference: complex lacks reference.
## fail
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSetReference">
## <ManSection>
## <Meth Name="SCSetReference" Arg="complex,ref"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Sets the literature reference of a polyhedral complex. The argument <Arg>ref</Arg> has to be given in form of a string.
## <Example>
## gap&gt; c:=SCBdSimplex(5);;
## gap&gt; SCReference(c);
## #I  SCReference: complex lacks reference.
## fail
## gap&gt; SCSetReference(c,"my 5-sphere in my cool paper");
## true
## gap&gt; SCReference(c);
## "my 5-sphere in my cool paper"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCDate">
## <ManSection>
## <Oper Name="SCDate" Arg="complex"/>
## <Returns> a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the date stamp of a simplicial complex <Arg>complex</Arg>.
## <Example>
## gap&gt; c:=SC([[1,2],[2,3],[3,1]]);;
## gap&gt; SCSetDate(c,"2011-11-11");
## true
## gap&gt; SCDate(c);
## "2011-11-11"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSetDate">
## <ManSection>
## <Meth Name="SCSetDate" Arg="complex,date"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Sets the date stamp of a simplicial complex. The argument <Arg>date</Arg> has to be given in form of a string.
## <Example>
## gap&gt; c:=SCBdSimplex(5);;
## gap&gt; SCDate(c);
## #I  SCDate: complex lacks date.
## fail
## gap&gt; SCSetDate(c,"2011-11-11");
## true
## gap&gt; SCDate(c);
## "2011-11-11"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLabels">
## <ManSection>
## <Meth Name="SCLabels" Arg="complex"/>
## <Returns>a list of vertex labels of <Arg>complex</Arg> (a list of integers, short lists, characters, short strings, ...) upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the vertex labels of <Arg>complex</Arg> as a list. This is a synonym of <Ref Meth="SCVertices"/>.
## <Example>
## gap&gt; c:=SCFromFacets(Combinations(["a","b","c","d"],3));;
## gap&gt; SCLabels(c);
## [ "a", "b", "c", "d" ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRelabelStandard">
## <ManSection>
## <Meth Name="SCRelabelStandard" Arg="complex"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Maps vertex labels <M>v_1 , \ldots , v_n</M> of <Arg>complex</Arg> to <M>[1 , \ldots , n]</M>. Internally the property "SCVertices" is replaced by <M>[1 , \ldots , n]</M>.
## <Example>
## gap&gt; list:=SCLib.SearchByAttribute("F[1]=12");; 
## gap&gt; c:=SCLib.Load(list[1][1]);;
## gap&gt; SCRelabel(c,[4..15]);
## true
## gap&gt; SCVertices(c);
## [ 4 .. 15 ]
## gap&gt; SCRelabelStandard(c);
## true
## gap&gt; SCLabels(c);
## [ 1 .. 12 ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRelabel">
## <ManSection>
## <Meth Name="SCRelabel" Arg="complex,maptable"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <Arg>maptable</Arg> has to be a list of length <M>n</M> where <M>n</M> is the number of vertices of <Arg>complex</Arg>. The function maps the <M>i</M>-th entry of <Arg>maptable</Arg> to the <M>i</M>-th entry of the current vertex labels. If <Arg>complex</Arg> has the standard vertex labeling <M>[1, \ldots , n]</M> the vertex label <M>i</M> is mapped to <Arg>maptable[i]</Arg>.<P/>
## Note that the elements of <Arg>maptable</Arg> must admit a total ordering. Hence, following Section 4.11 of the &GAP; manual, they must be members of one of the following families: rationals <C>IsRat</C>, cyclotomics <C>IsCyclotomic</C>, finite field elements <C>IsFFE</C>, permutations <C>IsPerm</C>, booleans <C>IsBool</C>, characters <C>IsChar</C> and lists (strings) <C>IsList</C>.<P/>
## Internally the property ``SCVertices'' of <Arg>complex</Arg> is replaced by <Arg>maptable.</Arg><P/>
## <Example>
## gap&gt; list:=SCLib.SearchByAttribute("F[1]=12");; 
## gap&gt; c:=SCLib.Load(list[1][1]);;
## gap&gt; SCVertices(c);
## [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
## gap&gt; SCRelabel(c,["a","b","c","d","e","f","g","h","i","j","k","l"]);
## true
## gap&gt; SCLabels(c);
## [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l" ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRelabelTransposition">
## <ManSection>
## <Meth Name="SCRelabelTransposition" Arg="complex,pair"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Permutes vertex labels of a single pair of vertices. <Arg>pair</Arg> has to be a list of length <M>2</M> and a sublist of the property ``SCVertices''.<P/>
## The function is equivalent to <Ref Meth="SCRelabel"/> with <Arg>maptable</Arg> <M>= [ SCVertices[1] , \ldots , SCVertices[j] , \ldots , SCVertices[i] , \dots , SCVertices[n]]</M> if <Arg>pair</Arg> <M>= [ SCVertices[j] , SCVertices[i]]</M>, <M>j \leq i</M>, <M>j \neq i</M>.<P/>
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; SCVertices(c);
## [ 1, 2, 3, 4 ]
## gap&gt; SCRelabelTransposition(c,[1,2]);;
## gap&gt; SCLabels(c);
## [ 2, 1, 3, 4 ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLabelMax">
## <ManSection>
## <Meth Name="SCLabelMax" Arg="complex"/>
## <Returns>vertex label of <Arg>complex</Arg> (an integer, a short list, a character, a short string) upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The maximum over all vertex labels is determined by the &GAP; function <C>MaximumList</C>.
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; SCRelabel(c,[10,100,100000,3500]);;
## gap&gt; SCLabelMax(c);
## 100000
## </Example>
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; SCRelabel(c,["a","bbb",5,[1,1]]);;
## gap&gt; SCLabelMax(c);
## "bbb"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLabelMin">
## <ManSection>
## <Meth Name="SCLabelMin" Arg="complex"/>
## <Returns>vertex label of <Arg>complex</Arg> (an integer, a short list, a character, a short string) upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The minimum over all vertex labels is determined by the &GAP; function <C>MinimumList</C>.
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; SCRelabel(c,[10,100,100000,3500]);;
## gap&gt; SCLabelMin(c);
## 10
## </Example>
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; SCRelabel(c,["a","bbb",5,[1,1]]);;
## gap&gt; SCLabelMin(c);
## 5
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################,
################################################################################
##<#GAPDoc Label="SCUnlabelFace">
## <ManSection>
## <Meth Name="SCUnlabelFace" Arg="complex,face"/>
## <Returns> a list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the standard labeling of <Arg>face</Arg> in <Arg>complex</Arg>. 
## <Example>
## gap&gt; c:=SCBdSimplex(3);;
## gap&gt; SCRelabel(c,["a","bbb",5,[1,1]]);;
## gap&gt; SCUnlabelFace(c,["a","bbb",5]);
## [ 1, 2, 3 ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
