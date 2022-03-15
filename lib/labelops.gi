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
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCName(c);
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[3,1]]);;
## gap> SCName(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCName,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)
	if not HasSCName(complex) then
		Info(InfoSimpcomp,1,"SCName: complex lacks name.");
		return fail;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCRename">
## <ManSection>
## <Meth Name="SCRename" Arg="complex,name"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Renames a polyhedral complex. The argument <Arg>name</Arg> has to be given in form of a string.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCName(c);
## "S^4_6"
## gap> SCRename(c,"mySphere");
## true
## gap> SCName(c);
## "mySphere"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCRename,
"for SCPolyhedralComplex and String",
[SCIsPolyhedralComplex,IsString],
function(complex, name)
	
	if HasSCName(complex) then
		complex!.SCName:=name;
	else
		SetSCName(complex,name);
	fi;
	return true;
end);



################################################################################
##<#GAPDoc Label="SCReference">
## <ManSection>
## <Oper Name="SCReference" Arg="complex"/>
## <Returns> a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a literature reference of a polyhedral complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SCLib.Load(253);;
## gap> SCReference(c);
## gap> c:=SC([[1,2],[2,3],[3,1]]);;
## gap> SCReference(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCReference,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)
	if not HasSCReference(complex) then
		Info(InfoSimpcomp,1,"SCReference: complex lacks reference.");
		return fail;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCSetReference">
## <ManSection>
## <Meth Name="SCSetReference" Arg="complex,ref"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Sets the literature reference of a polyhedral complex. The argument <Arg>ref</Arg> has to be given in form of a string.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCReference(c);
## gap> SCSetReference(c,"my 5-sphere in my cool paper");
## true
## gap> SCReference(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSetReference,
"for SCPolyhedralComplex and String",
[SCIsPolyhedralComplex,IsString],
function(complex, ref)
	
	if HasSCReference(complex) then
		complex!.SCReference:=ref;
	else
		SetSCReference(complex,ref);
	fi;
	return true;
end);


################################################################################
##<#GAPDoc Label="SCDate">
## <ManSection>
## <Oper Name="SCDate" Arg="complex"/>
## <Returns> a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the date stamp of a simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[3,1]]);;
## gap> SCSetDate(c,"2011-11-11");
## gap> SCDate(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDate,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)
	if not HasSCDate(complex) then
		Info(InfoSimpcomp,1,"SCDate: complex lacks date.");
		return fail;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCSetDate">
## <ManSection>
## <Meth Name="SCSetDate" Arg="complex,date"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Sets the date stamp of a simplicial complex. The argument <Arg>date</Arg> has to be given in form of a string.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCDate(c);
## gap> SCSetDate(c,"2011-11-11");
## true
## gap> SCDate(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSetDate,
"for SCPolyhedralComplex and String",
[SCIsPolyhedralComplex,IsString],
function(complex, date)
	
	if HasSCDate(complex) then
		complex!.SCDate:=date;
	else
		SetSCDate(complex,date);
	fi;
	return true;
end);



################################################################################
##<#GAPDoc Label="SCLabels">
## <ManSection>
## <Meth Name="SCLabels" Arg="complex"/>
## <Returns>a list of vertex labels of <Arg>complex</Arg> (a list of integers, short lists, characters, short strings, ...) upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the vertex labels of <Arg>complex</Arg> as a list. This is a synonym of <Ref Meth="SCVertices"/>.
## <Example><![CDATA[
## gap> c:=SCFromFacets(Combinations(["a","b","c","d"],3));;
## gap> SCLabels(c);
## [ "a", "b", "c", "d" ]
## ]]></Example>
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
## <Example><![CDATA[
## gap> list:=SCLib.SearchByAttribute("F[1]=12");; 
## gap> c:=SCLib.Load(list[1][1]);;
## gap> SCRelabel(c,[4..15]);
## true
## gap> SCVertices(c);
## [ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]
## gap> SCRelabelStandard(c);
## true
## gap> SCLabels(c);
## [ 1 .. 12 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCRelabelStandard,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)

	local labels,propLabels,elm,recNames,idx,props;
	
	labels:=SCVerticesEx(complex);
	if labels = fail then
		Info(InfoSimpcomp,1,"SCRelabelStandard: complex has no vertex labels");
		return fail;
	fi;
		
	if HasSCVertices(complex) then
		complex!.SCVertices:=labels;
	else
		SetSCVertices(complex,labels);
	fi;
	return true; 
end);


################################################################################
##<#GAPDoc Label="SCRelabel">
## <ManSection>
## <Meth Name="SCRelabel" Arg="complex,maptable"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <Arg>maptable</Arg> has to be a list of length <M>n</M> where <M>n</M> is the number of vertices of <Arg>complex</Arg>. The function maps the <M>i</M>-th entry of <Arg>maptable</Arg> to the <M>i</M>-th entry of the current vertex labels. If <Arg>complex</Arg> has the standard vertex labeling <M>[1, \ldots , n]</M> the vertex label <M>i</M> is mapped to <Arg>maptable[i]</Arg>.<P/>
## Note that the elements of <Arg>maptable</Arg> must admit a total ordering. Hence, following Section 4.11 of the &GAP; manual, they must be members of one of the following families: rationals <C>IsRat</C>, cyclotomics <C>IsCyclotomic</C>, finite field elements <C>IsFFE</C>, permutations <C>IsPerm</C>, booleans <C>IsBool</C>, characters <C>IsChar</C> and lists (strings) <C>IsList</C>.<P/>
## Internally the property ``SCVertices'' of <Arg>complex</Arg> is replaced by <Arg>maptable.</Arg><P/>
## <Example><![CDATA[
## gap> list:=SCLib.SearchByAttribute("F[1]=12");; 
## gap> c:=SCLib.Load(list[1][1]);;
## gap> SCVertices(c);
## [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
## gap> SCRelabel(c,["a","b","c","d","e","f","g","h","i","j","k","l"]);
## true
## gap> SCLabels(c);
## [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l" ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCRelabel,
"for SCPolyhedralComplex and List",
[SCIsPolyhedralComplex,IsList],
function(complex,maptable)

		local labels,propLabels,elm,recNames,idx,props,facets,vertices,i,j;
		
		for elm in maptable do
			if IsRat(elm) or IsCyclotomic(elm) or IsFFE(elm) or IsPerm(elm) or IsBool(elm) or IsChar(elm) or IsList(elm) then
				continue;
			else
				Info(InfoSimpcomp,1,"SCRelabel: vertex labels must be rationals, cyclotomics, finite field elements, permutations, characters, lists or strings");
				return fail;
			fi;
		od;
		
		if HasSCVertices(complex) then
			complex!.SCVertices:=maptable;
		else
			SetSCVertices(complex,maptable);
		fi;
		return true;
end);


################################################################################
##<#GAPDoc Label="SCRelabelTransposition">
## <ManSection>
## <Meth Name="SCRelabelTransposition" Arg="complex,pair"/>
## <Returns> <K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Permutes vertex labels of a single pair of vertices. <Arg>pair</Arg> has to be a list of length <M>2</M> and a sublist of the property ``SCVertices''.<P/>
## The function is equivalent to <Ref Meth="SCRelabel"/> with <Arg>maptable</Arg> <M>= [ SCVertices[1] , \ldots , SCVertices[j] , \ldots , SCVertices[i] , \dots , SCVertices[n]]</M> if <Arg>pair</Arg> <M>= [ SCVertices[j] , SCVertices[i]]</M>, <M>j \leq i</M>, <M>j \neq i</M>.<P/>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCVertices(c);
## [ 1, 2, 3, 4 ]
## gap> SCRelabelTransposition(c,[1,2]);;
## gap> SCLabels(c);
## [ 2, 1, 3, 4 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCRelabelTransposition,
"for SCPolyhedralComplex and List",
[SCIsPolyhedralComplex,IsList],
function(complex,pair)

		local labels,pos,tmp;
				
		labels:=ShallowCopy(SCVertices(complex));
		if labels = fail then
			Info(InfoSimpcomp,1,"SCRelabel: complex has no vertex labels");
			return fail;
		fi;
		pos:=[Position(labels,pair[1]),Position(labels,pair[2])];
		if(Length(pair)<>2 or fail in pos) then
			Info(InfoSimpcomp,1,"SCRelabelTransposition: second argument must be a pair of vertex labels.");
			return fail;
		fi;
		tmp:=labels[pos[1]];
		labels[pos[1]]:=labels[pos[2]];
		labels[pos[2]]:=tmp;
		
		return	SCRelabel(complex,labels);
end);


################################################################################
##<#GAPDoc Label="SCLabelMax">
## <ManSection>
## <Meth Name="SCLabelMax" Arg="complex"/>
## <Returns>vertex label of <Arg>complex</Arg> (an integer, a short list, a character, a short string) upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The maximum over all vertex labels is determined by the &GAP; function <C>MaximumList</C>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCRelabel(c,[10,100,100000,3500]);;
## gap> SCLabelMax(c);
## 100000
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCRelabel(c,["a","bbb",5,[1,1]]);;
## gap> SCLabelMax(c);
## "bbb"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCLabelMax,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)
	local labels;
	
	if SCIsEmpty(complex) then
		Info(InfoSimpcomp,1,"SCLabelMax: complex is empty.");
		return [];
	fi;
	
	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCLabelMax: complex lacks vertex labels.");
		return fail;
	fi;
	
	return MaximumList(labels);
	
end);


################################################################################
##<#GAPDoc Label="SCLabelMin">
## <ManSection>
## <Meth Name="SCLabelMin" Arg="complex"/>
## <Returns>vertex label of <Arg>complex</Arg> (an integer, a short list, a character, a short string) upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The minimum over all vertex labels is determined by the &GAP; function <C>MinimumList</C>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCRelabel(c,[10,100,100000,3500]);;
## gap> SCLabelMin(c);
## 10
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCRelabel(c,["a","bbb",5,[1,1]]);;
## gap> SCLabelMin(c);
## 5
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################,
InstallMethod(SCLabelMin,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)
	local labels;
	
	if SCIsEmpty(complex) then
		Info(InfoSimpcomp,1,"SCLabelMin: complex is empty.");
		return [];
	fi;
	
	labels:=SCVertices(complex);
		
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCLabelMin: complex lacks vertex labels.");
		return fail;
	fi;
	return MinimumList(labels);

end);

################################################################################
##<#GAPDoc Label="SCUnlabelFace">
## <ManSection>
## <Meth Name="SCUnlabelFace" Arg="complex,face"/>
## <Returns> a list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the standard labeling of <Arg>face</Arg> in <Arg>complex</Arg>. 
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCRelabel(c,["a","bbb",5,[1,1]]);;
## gap> SCUnlabelFace(c,["a","bbb",5]);
## [ 1, 2, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCUnlabelFace,
"for SCPolyhedralComplex and List",
[SCIsPolyhedralComplex,IsList],
function(complex,face)

	local labels,d,unlabel;
	
	if(face=[]) then
		return [];
	fi;
	
	d:=SCDim(complex);
	labels:=SCLabels(complex);
	if(d=fail or labels=fail) then
		return fail;
	fi;
	
	if(Length(face)>d+1) then
		Info(InfoSimpcomp,1,"SCUnlabelFace: second argument is not a proper face of the given complex.");
		return fail;
	fi;
	
	unlabel:=List(face,x->Position(labels,x));
	
	if(fail in unlabel) then
		return fail;
	fi;
	
	return unlabel;
end);