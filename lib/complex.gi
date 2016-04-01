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
## <Example>
## gap> c:=SCEmpty();;
## gap> SCIsSimplicialComplex(c);
## true
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################

SCSimplicialComplexFamily:=NewFamily("SCSimplicialComplexFamily",
  SCIsSimplicialComplex and IsMutable and IsCopyable);
SCSimplicialComplexType:=NewType(SCSimplicialComplexFamily,
  SCIsSimplicialComplex and IsAttributeStoringRep and IsListOrCollection);


#properties of which the values are displayed by ViewObj of SCSimplicialComplex 
SCIntFunc.SCViewProperties:=[ "Name", "Dim", "AltshulerSteinberg", 
"AutomorphismGroupSize", "AutomorphismGroupStructure", 
"AutomorphismGroupTransitivity", "EulerCharacteristic", "Cohomology", 
"FVector", "GVector", "HVector", "HasBoundary", "HasInterior", "Homology", 
"IsCentrallySymmetric", "IsConnected", "IsEulerianManifold", "IsOrientable", 
"IsPseudoManifold", "IsPure", "IsShellable", "IsStronglyConnected", 
"Neighborliness", "TopologicalType" ];

#print simplicial complex info (in compact format)
#compact format: dim, chi, fvec, hom
InstallMethod(ViewObj,"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(sc)
	Print(SCIntFunc.StringEx(sc,true,SCIntFunc.SCViewProperties));
end);


#serialize simplicial complex to string, only use attributes given in list view
SCIntFunc.StringEx:=
function(sc,view,vprops)
	local buf,props,pprops,prop,p,pp,size,pos,sort,type;

	if(SCIsSimplicialComplex(sc)) then
		type:="SimplicialComplex";
	elif(SCIsNormalSurface(sc)) then
		type:="NormalSurface";
	else
		type:="OtherComplex";
	fi;
	
	buf:=Concatenation("[",type,"\n\n");
	Append(buf," Properties known: ");
	pos:=19;
	
	# get known attributes
	props:=KnownAttributesOfObject(sc);

	# make short names of attributes (without prefix SC...)
	pprops:=[];
	for p in [1..Length(props)] do
		pp:=props[p];
		if(Length(pp)>2 and pp{[1,2]}="SC") then
			pp:=pp{[3..Length(pp)]};
		elif(Length(pp)>10 and pp{[1..10]}="ComputedSC") then
			if(pp{[Length(pp)-1,Length(pp)]}="ss") then
				pp:=pp{[1..Length(pp)-1]};
			fi;
			pp:=Concatenation(pp{[11..Length(pp)]},"[]");
		fi;
		Add(pprops,pp);
	od;

	sort:=SortingPerm(pprops);
	pprops:=Permuted(pprops,sort);
	props:=Permuted(props,sort);
	
	# respect screen size
	if view then
		size:=SizeScreen()[1]-8;
		if(size<0) then
			size:=0;
		fi;
	else
		size:=0;
	fi;
	
	
	# display list of all known attributes
	for p in [1..Length(pprops)] do
		if(size>0 and pos>0 and pos+Length(pprops[p])+2>=size) then
			Append(buf,"\n                   ");
			pos:=19;
		fi;
			
		Append(buf,pprops[p]);
		pos:=pos+Length(pprops[p]);
		if(p=Length(pprops)) then
			Append(buf,".\n\n");
		else
			Append(buf,", ");
			pos:=pos+2;
		fi;
	od;

	# display view properties with values
	for p in vprops do
		pos:=Position(pprops,p);
		if(pos<>fail) then
			prop:=EvalString(props[pos])(sc);
			#sc.(pprops[pos]);
			if(IsStringRep(prop)) then
				Append(buf,Concatenation([" ",p,"=\"",prop,"\"\n"]));
			else
				Append(buf,Concatenation([" ",p,"=",String(prop),"\n"]));
			fi;
		fi;
	od;

	Append(buf,Concatenation("\n/",type,"]"));
	return buf;
end;

#simplicial complex -> string method
InstallMethod(String,"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(sc)
	return SCIntFunc.StringEx(sc,false,SCIntFunc.SCViewProperties);
end);


#print simplicial complex info
InstallMethod(PrintObj,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(sc)
	Print(SCIntFunc.StringEx(sc,true,SCIntFunc.SCViewProperties));
end);


#perform an opertation op on the vertex labels
SCIntFunc.OperationLabels:=
function(sc,op)
	local labels,c;
	
	labels:=SCVertices(sc);
	c:=SCCopy(sc);
	if(labels=fail) then
		return fail;
	fi;
	
	if ForAll(labels,x->IsAdditiveElement(x)) then
		c!.SCVertices:=List(labels,op);
		return c;
	else
		Info(InfoSimpcomp,1,"SCIntFunc.OperationsLabels: vertex labels of ",
      "complex can not be changed by +, -, * or mod.");
		return fail;
	fi;
end;



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
## <Example>
## gap> c:=SCBdSimplex(3)+10;;
## gap> c.Facets;
## [[11, 12, 13], [11, 12, 14], [11, 13, 14], [12, 13, 14]]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\+,"for SCSimplicialComplex, Integer",
	[SCIsSimplicialComplex,IsInt],
function(complex, value)
	return SCIntFunc.OperationLabels(complex,function(x) return x+value; end);
end);

################################################################################
##<#GAPDoc Label="SCOpMinusSCInt">
## <ManSection>
## <Meth Name="Operation - (SCSimplicialComplex, Integer)" Arg="complex, value"/>
## <Returns>the simplicial complex passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Negatively shifts the vertex labels of <Arg>complex</Arg> (provided that 
## all labels satisfy the property <C>IsAdditiveElement</C>) by the amount 
## specified in <Arg>value</Arg>.
## <Example>
## gap> c:=SCBdSimplex(3)-1;;
## gap> c.Facets;
## [[0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\-,"for SCSimplicialComplex, Integer",
	[SCIsSimplicialComplex,IsInt],
function(complex, value)
	return complex+(-value);
end);

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
## <Example>
## gap> c:=SCBdSimplex(3)*10;;
## gap> c.Facets;
## [[10, 20, 30], [10, 20, 40], [10, 30, 40], [20, 30, 40]]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\*,"for SCSimplicialComplex, Integer",
	[SCIsSimplicialComplex,IsInt],
function(complex, value)
	return SCIntFunc.OperationLabels(complex,function(x) return x*value; end);
end);

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
## <Example>
## gap> c:=(SCBdSimplex(3)*10) mod 7;;
## gap> c.Facets;
## [[3, 6, 2], [3, 6, 5], [3, 2, 5], [6, 2, 5]]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\mod,"for SCSimplicialComplex, Integer",
	[SCIsSimplicialComplex,IsInt],
function(complex, value)
	return SCIntFunc.OperationLabels(complex,function(x) return x mod value; end);
end);

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
## <Example>
## gap> c:=SCBdSimplex(2)^2; #a torus
## [SimplicialComplex
## 
##  Properties known: Dim, Facets, Name, TopologicalType, SCVertices.
## 
##  Name="(S^1_3)^2"
##  Dim=2
##  TopologicalType="(S^1)^2"
## 
## /SimplicialComplex]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\^,"for SCSimplicialComplex, Integer",
	[SCIsSimplicialComplex,IsPosInt],
function(sc, val)
	return SCCartesianPower(sc,val);
end);


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
## <Example>
## gap> SCLib.SearchByName("RP^3");
## [ [ 45, "RP^3" ], [ 103, "RP^3=L(2,1) (VT)" ], [ 246, "(S^2~S^1)#RP^3" ], 
##   [ 247, "(S^2xS^1)#RP^3" ], [ 283, "(S^2~S^1)#2#RP^3" ], 
##   [ 285, "(S^2xS^1)#2#RP^3" ], [ 409, "RP^3#RP^3" ], ...
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCLib.SearchByName("S^2~S^1"){[1..3]};
## [ [ 14, "S^2~S^1 (VT)" ], [ 29, "S^2~S^1 (VT)" ], [ 34, "S^2~S^1 (VT)" ], 
##   [ 42, "S^2~S^1 (VT)" ], [ 48, "S^2~S^1 (VT)" ], [ 49, "S^2~S^1 (VT)" ], 
##   [ 84, "S^2~S^1 (VT)" ], [ 87, "S^2~S^1 (VT)" ], ...
## gap> d:=SCLib.Load(last[1][1]);;
## gap> c:=c+d; #form RP^3#(S^2~S^1)
## [SimplicialComplex
## 
##  Properties known: Dim, Facets, Name, SCVertices, Vertices.
## 
##  Name="RP^3#+-S^2~S^1 (VT)"
##  Dim=3
## 
## /SimplicialComplex]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\+,"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	return SCConnectedSum(complex1,complex2);
end);

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
InstallMethod(
	\-,"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	return SCDifference(complex1,complex2);
end);


################################################################################
##<#GAPDoc Label="SCOpMultSCSC">
## <ManSection>
## <Meth Name="Operation * (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the simplicial cartesian product of <Arg>complex1</Arg> and 
## <Arg>complex2</Arg>. Internally calls <Ref Func="SCCartesianProduct"/>.
## <Example>
## gap> SCLib.SearchByName("RP^2");
## [ [ 3, "RP^2 (VT)" ], [ 284, "RP^2xS^1" ] ]
## gap> c:=SCLib.Load(last[1][1])*SCBdSimplex(3); #form RP^2 x S^2
## [SimplicialComplex
## 
##  Properties known: Dim, Facets, Name, SCVertices.
## 
##  Name="RP^2 (VT)xS^2_4"
##  Dim=4
## 
## /SimplicialComplex]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\*,"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	return SCCartesianProduct(complex1,complex2);
end);

################################################################################
##<#GAPDoc Label="SCOpEqSCSC">
## <ManSection>
## <Meth Name="Operation = (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Calculates whether two simplicial complexes are isomorphic, i.e. are 
## equal up to a relabeling of the vertices.
## <Example>
## gap> c:=SCBdSimplex(3);;
## gap> c=c+10;
## true
## gap> c=SCBdCrossPolytope(4);
## false
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\=,"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	return SCIsIsomorphic(complex1,complex2);
end);




################################################################################
##<#GAPDoc Label="SCOpUnionSCSC">
## <ManSection>
## <Meth Name="Operation Union (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the union of two simplicial complexes by calling 
## <Ref Func="SCUnion"/>.
## <Example>
## gap> c:=Union(SCBdSimplex(3),SCBdSimplex(3)+3); #a wedge of two 2-spheres
## [SimplicialComplex
## 
##  Properties known: Dim, Facets, Name, SCVertices.
## 
##  Name="S^2_4 cup S^2_4"
##  Dim=2
## 
## /SimplicialComplex]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	Union2,
	"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1,complex2)
	return SCUnion(complex1,complex2);
end);



################################################################################
##<#GAPDoc Label="SCOpDiffSCSC">
## <ManSection>
## <Meth Name="Operation Difference (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the ``difference'' of two simplicial complexes by calling 
## <Ref Func="SCDifference" />.
## <Example>
## gap> c:=SCBdSimplex(3);;
## gap> d:=SC([[1,2,3]]);;
## gap> disc:=Difference(c,d);;
## gap> disc.Facets;
## [ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
## gap> empty:=Difference(d,c);;
## gap> empty.Dim;
## -1
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	Difference,"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	return SCDifference(complex1,complex2);
end);


################################################################################
##<#GAPDoc Label="SCOpIsecSCSC">
## <ManSection>
## <Meth Name="Operation Intersection (SCSimplicialComplex, SCSimplicialComplex)" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the ``intersection'' of two simplicial complexes by calling 
## <Ref Func="SCIntersection" />.
## <Example>
## gap> c:=SCBdSimplex(3);;        
## gap> d:=SCBdSimplex(3);;        
## gap> d:=SCMove(d,[[1,2,3],[]]);;
## gap> d:=d+1;;                   
## gap> s1:=SCIntersection(c,d);   
## [SimplicialComplex
## 
##  Properties known: Dim, Facets, Name, SCVertices.
## 
##  Name="S^2_4 cap unnamed complex m"
##  Dim=1
## 
## /SimplicialComplex]
## gap> s1.Facets;                 
## [ [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	Intersection2,
	"for SCSimplicialComplex, SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	return SCIntersection(complex1,complex2);
end);



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
## <Example>
## gap> c:=SCBdCrossPolytope(7);;
## gap> d:=ShallowCopy(c)+10;;
## gap> c.Facets=d.Facets;
## false
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(ShallowCopy,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	return SCCopy(complex);
end);



################################################################################
##<#GAPDoc Label="SCCopy">
## <ManSection>
## <Meth Name="SCCopy" Arg="complex"/>
## <Returns>a copy of <Arg>complex</Arg> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Makes a ``deep copy'' of <Arg>complex</Arg> -- this is a copy such that 
## all properties of the copy can be altered without changing the original 
## complex.
## <Example>
## gap> c:=SCBdSimplex(4);;
## gap> d:=SCCopy(c)-1;;
## gap> c.Facets=d.Facets;
## false
## </Example>
## <Example>
## gap> c:=SCBdSimplex(4);;
## gap> d:=SCCopy(c);;
## gap> IsIdenticalObj(c,d);
## false
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCopy,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local a,c,attr;
	
	attr:=KnownAttributesOfObject(complex);
	c:=SCIntFunc.SCNew();
	if c = fail then
		return fail;
	fi;
	
	for a in attr do
		Setter(EvalString(a))(c,complex!.(a));
	od;
	return c;
end);



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
## <Example>
## gap> SCLib.SearchByAttribute("F=[12,66,108,54]");
## [ [ 116, "S^2xS^1 (VT)" ], [ 117, "S^2xS^1 (VT)" ], 
##   [ 118, "(S^2xS^1)#(S^2xS^1) (VT)" ], [ 119, "S^2~S^1 (VT)" ], 
##   [ 120, "(S^2xS^1)#(S^2xS^1) (VT)" ], [ 121, "(S^2xS^1)#(S^2xS^1) (VT)" ], 
##   [ 122, "S^2xS^1 (VT)" ], [ 123, "(S^2xS^1)#(S^2xS^1) (VT)" ], ...
## gap> c:=SCLib.Load(last[1][1]);;
## gap> for i in [1..Size(c)] do Print(c.F[i],"\n"); od;
## 12
## 66
## 108
## 54
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(Size,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local dim;
	
	dim:=SCDim(complex);
	
	if(dim=fail) then
		return fail;
	else
		return dim+1;
	fi;
end);

################################################################################
##<#GAPDoc Label="SCLength">
## <ManSection>
## <Meth Name="Length (SCSimplicialComplex)" Arg="complex"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the ``size'' of a simplicial complex by calling 
## <C>Size(</C><Arg>complex</Arg><C>)</C>.   
## <Example>
## gap> SCLib.SearchByAttribute("F=[12,66,108,54]");
## [ [ 116, "Sˆ2xSˆ1 (VT)" ], [ 117, "Sˆ2xSˆ1 (VT)" ],
## [ 118, "(Sˆ2xSˆ1)#(Sˆ2xSˆ1) (VT)" ], [ 119, "Sˆ2˜Sˆ1 (VT)" ],
## [ 120, "(Sˆ2xSˆ1)#(Sˆ2xSˆ1) (VT)" ], [ 121, "(Sˆ2xSˆ1)#(Sˆ2xSˆ1) (VT)" ],
## [ 122, "Sˆ2xSˆ1 (VT)" ], [ 123, "(Sˆ2xSˆ1)#(Sˆ2xSˆ1) (VT)" ], ...
## gap> c:=SCLib.Load(last[1][1]);;
## gap> for i in [1..Length(c)] do Print(c.F[i],"\n"); od;
## 12
## 66
## 108
## 54
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(Length,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	return Size(complex);
end);



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
## <Example>
## gap> SCLib.SearchByName("K^2");
## [ [ 19, "K^2 (VT)" ], [ 230, "K^2 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c[2];
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 7 ], [ 1, 9 ], [ 1, 13 ], [ 1, 14 ], [ 2, 3 ], 
##   [ 2, 4 ], [ 2, 8 ], [ 2, 10 ], [ 2, 14 ], [ 3, 4 ], [ 3, 5 ], [ 3, 9 ], 
##   [ 3, 11 ], [ 4, 5 ], [ 4, 6 ], [ 4, 10 ], [ 4, 12 ], [ 5, 6 ], [ 5, 7 ], 
##   [ 5, 11 ], [ 5, 13 ], [ 6, 7 ], [ 6, 8 ], [ 6, 12 ], [ 6, 14 ], [ 7, 8 ], 
##   [ 7, 9 ], [ 7, 13 ], [ 8, 9 ], [ 8, 10 ], [ 8, 14 ], [ 9, 10 ], [ 9, 11 ], 
##   [ 10, 11 ], [ 10, 12 ], [ 11, 12 ], [ 11, 13 ], [ 12, 13 ], [ 12, 14 ], 
##   [ 13, 14 ] ]
## gap> c[4];
## [  ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\[\],"for SCSimplicialComplex",
	[SCIsSimplicialComplex,IsPosInt],
function(complex, pos)
	local skel,dim;

	dim:=SCDim(complex);
	
	if(dim=fail) then
		return fail;
	fi;
	
	if(pos<1 or pos>dim+1) then
		return [];
	fi;
	
	skel:=SCSkel(complex,pos-1);

	if(skel=fail) then
		return fail;
	fi;
	
	return skel;
end);

InstallMethod(
	IsBound\[\],"for SCSimplicialComplex",
	[SCIsSimplicialComplex,IsPosInt],
function(complex, pos)
	local dim;
	dim:=SCDim(complex);
	
	if(dim=fail) then
		return fail;
	else
		return pos>=1 and pos<=dim+1;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCIterator">
## <ManSection>
## <Meth Name="Iterator (SCSimplicialComplex)" Arg="complex"/>
## <Returns>an iterator on the face lattice of <Arg>complex</Arg> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Provides an iterator object for the face lattice of a simplicial complex.   
## <Example>
## gap> c:=SCBdCrossPolytope(4);;
## gap> for faces in c do Print(Length(faces),"\n"); od;
## 8
## 24
## 32
## 16
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	Iterator,"for SCSimplicialComplex",
	[SCIsSimplicialComplex],
function(complex)
	local faces;
	faces:=SCFaceLattice(complex);

	if(faces=fail) then
		return fail;
	fi;
	
	return Iterator(faces);
end);

InstallMethod(
	IsSubset,"for SCSimplicialComplex",
	[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1,complex2)
	return SCIsSubcomplex(complex1,complex2);
end);



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
## <Example>
## gap> c:=SC(SCFacets(SCBdCyclicPolytope(10,12)));
## gap> c.F; time;                                 
## gap> c.F; time;                                 
## gap> c:=SCPropertiesDropped(c);                 
## gap> c.F; time;                                 
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCPropertiesDropped,
function(complex)
	local sc;
	
	if(not SCIsSimplicialComplex(complex)) then
		Info(InfoSimpcomp,1,"SCPropertiesDropped: argument must be of type ",
      "SCSimplicialComplex.");
		return fail;
	fi;
	
	sc:=SCFromFacets(SCFacetsEx(complex));
	
	if(sc=fail) then
		return fail;
	fi;
	
	if(SCName(complex)<>fail) then
		SCRename(sc,SCName(complex));
	fi;
	
	return sc;
end);



# create new complex as SCSimplicialComplex and empty attributes
SCIntFunc.SCNew:=
function()
	local sc;
	sc:=Objectify(SCSimplicialComplexType,rec(Properties:=rec(), 
  PropertiesTmp:=rec(forceCalc:=false), 
  PropertyHandlers:=SCIntFunc.SCPropertyHandlers));
	
	if(sc=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCNew: Error creating new instance of ",
      "SCSimplicialComplex!");
	fi;
	
	return sc;
end;



# create new complex as SCSimplicialComplex with predefined attributes
SCIntFunc.SCNewWithProperties:=
function(props)
	return Objectify(SCSimplicialComplexType,rec(Properties:=ShallowCopy(props),
  PropertiesTmp:=rec(forceCalc:=false), 
  PropertyHandlers:=SCIntFunc.SCPropertyHandlers));
end;
