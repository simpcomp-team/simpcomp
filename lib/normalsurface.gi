################################################################################
##
##  simpcomp / normalsurface.gi
##
##  Normal surfaces
##
##  $Id$
##
################################################################################

SCNormalSurfaceFamily:=NewFamily("SCNormalSurfaceFamily",SCIsNormalSurface and IsMutable and IsCopyable);
SCNormalSurfaceType:=NewType(SCNormalSurfaceFamily,SCIsNormalSurface and IsAttributeStoringRep and IsListOrCollection);

#properties of which the values are displayed by ViewObj of SCNormalSurface 
SCIntFunc.SCNSViewProperties:=[ "Name", "Dim", "FVector", "EulerCharacteristic", "IsOrientable", "Homology", "TopologicalType" ];

#print simplicial complex info (in compact format)
#compact format: dim, chi, fvec, hom
InstallMethod(ViewObj,"for SCNormalSurface",
[SCIsNormalSurface],
function(sc)
	Print(SCIntFunc.StringEx(sc));
end);

#simplicial complex -> string method
InstallMethod(String,"for SCNormalSurface",
[SCIsNormalSurface],
function(sc)
	return SCIntFunc.StringEx(sc);
end);


#print simplicial complex info
InstallMethod(PrintObj,
"for SCNormalSurface",
[SCIsNormalSurface],
function(sc)
	Print(SCIntFunc.StringEx(sc));
end);

# create new complex as SCNormalSurface and empty attributes
SCIntFunc.SCNSNew:=
function()
	return Objectify(SCNormalSurfaceType,rec(Properties:=rec(), PropertiesTmp:=rec(forceCalc:=false), PropertyHandlers:=SCIntFunc.SCNSPropertyHandlers));
end;

# create new complex as SCNormalSurface with predefined attributes
SCIntFunc.SCNSNewWithProperties:=
function(props)
	return Objectify(SCNormalSurfaceType,rec(Properties:=ShallowCopy(props),  PropertiesTmp:=rec(forceCalc:=false), PropertyHandlers:=SCIntFunc.SCNSPropertyHandlers));
end;

################################################################################
##<#GAPDoc Label="NSOpPlusSCInt">
## <ManSection>
## <Meth Name="Operation + (SCNormalSurface, Integer)" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Positively shifts the vertex labels of <Arg>complex</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>) by the amount specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;
## gap> sl.Facets;                                    
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl + 2;;                                  
## gap> sl.Facets;  
## [ [ [ 3, 4 ], [ 3, 5 ], [ 3, 6 ] ], [ [ 3, 4 ], [ 3, 5 ], [ 3, 7 ] ], 
##   [ [ 3, 4 ], [ 3, 6 ], [ 3, 7 ] ], [ [ 3, 5 ], [ 3, 6 ], [ 3, 7 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\+,"for SCNormalSurface, Integer",
	[SCIsNormalSurface,IsInt],
function(complex, value)
	return SCIntFunc.OperationLabels(complex,function(x) return x+value; end);
end);

################################################################################
##<#GAPDoc Label="NSOpMinusSCInt">
## <ManSection>
## <Meth Name="Operation - (SCNormalSurface, Integer)" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Negatively shifts the vertex labels of <Arg>complex</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>) by the amount specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;
## gap> sl.Facets;                                    
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl - 2;;                                  
## gap> sl.Facets;  
## [ [ [ -1, 0 ], [ -1, 1 ], [ -1, 2 ] ], [ [ -1, 0 ], [ -1, 1 ], [ -1, 3 ] ], 
##   [ [ -1, 0 ], [ -1, 2 ], [ -1, 3 ] ], [ [ -1, 1 ], [ -1, 2 ], [ -1, 3 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\-,"for SCNormalSurface, Integer",
	[SCIsNormalSurface,IsInt],
function(complex, value)
	return complex+(-value);
end);

################################################################################
##<#GAPDoc Label="Operation * (SCNormalSurface, Integer)">
## <ManSection>
## <Meth Name="Operation * (SCNormalSurface, Integer" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Multiplies the vertex labels of <Arg>complex</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>) with the integer specified in <Arg>value</Arg>.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;
## gap> sl.Facets;                                    
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl * 2;;                                  
## gap> sl.Facets;  
## [ [ [ 2, 4 ], [ 2, 6 ], [ 2, 8 ] ], [ [ 2, 4 ], [ 2, 6 ], [ 2, 10 ] ], 
##   [ [ 2, 4 ], [ 2, 8 ], [ 2, 10 ] ], [ [ 2, 6 ], [ 2, 8 ], [ 2, 10 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\*,"for SCNormalSurface, Integer",
	[SCIsNormalSurface,IsInt],
function(complex, value)
	return SCIntFunc.OperationLabels(complex,function(x) return x*value; end);
end);

################################################################################
##<#GAPDoc Label="NSOpModSCInt">
## <ManSection>
## <Meth Name="Operation mod (SCNormalSurface, Integer)" Arg="complex, value"/>
## <Returns>the discrete normal surface passed as argument upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Takes all vertex labels of <Arg>complex</Arg> modulo the value specified in <Arg>value</Arg> (provided that all labels satisfy the property <C>IsAdditiveElement</C>). Warning: this might result in different vertices being assigned the same label or even invalid facet lists, so be careful.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);;    
## gap> sl.Facets;
## [ [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ] ]
## gap> sl:=sl mod 2;;
## gap> sl.Facets;    
## [ [ [ 1, 0 ], [ 1, 1 ], [ 1, 0 ] ], [ [ 1, 0 ], [ 1, 1 ], [ 1, 1 ] ], 
##   [ [ 1, 0 ], [ 1, 0 ], [ 1, 1 ] ], [ [ 1, 1 ], [ 1, 0 ], [ 1, 1 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	\mod,"for SCNormalSurface, Integer",
	[SCIsNormalSurface,IsInt],
function(complex, value)
	return SCIntFunc.OperationLabels(complex,function(x) return x mod value; end);
end);

################################################################################
##<#GAPDoc Label="NSOpUnionSCSC">
## <ManSection>
## <Meth Name="Operation Union (SCNormalSurface, SCNormalSurface)" Arg="complex1, complex2"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the union of two discrete normal surfaces by calling <Ref Meth="SCUnion"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F = [ 10, 35, 50, 25 ]");
## [ [ 19, "S^3 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> sl1:=SCNSSlicing(c,[[1,3,5,7,9],[2,4,6,8,10]]);;
## gap> sl2:=sl1+10;;
## gap> SCTopologicalType(sl1);
## "T^2"
## gap> sl3:=Union(sl1,sl2);;
## gap> SCTopologicalType(sl3);
## "T^2 U T^2"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(
	Union2,
	"for SCNormalSurface, SCNormalSurface",
	[SCIsNormalSurface,SCIsNormalSurface],
function(complex1,complex2)
	return SCUnion(complex1,complex2);
end);

InstallMethod(Size,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)
	local f;
	
	f:=SCFVector(complex);
	
	if(f=fail) then
		return fail;
	else
		return Size(f);
	fi;
end);

InstallMethod(Length,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)
	return Size(complex);
end);

InstallMethod(
	\[\],"for SCNormalSurface",
	[SCIsNormalSurface,IsPosInt],
function(complex, pos)
	local skel,f;

	f:=SCFVector(complex);
	if(f=fail) then
		return fail;
	fi;
	
	if(pos<1 or pos>Size(f)) then
		return [];
	fi;
	
	skel:=SCSkel(complex,pos-1);

	if(skel=fail) then
		return fail;
	fi;
	
	return skel;
end);

InstallMethod(
	IsBound\[\],"for SCNormalSurface",
	[SCIsNormalSurface,IsPosInt],
function(complex, pos)
	local f;
	f:=SCFVector(complex);
	
	if(f=fail) then
		return fail;
	else
		return pos>=1 and pos<=Size(f);
	fi;
end);

InstallMethod(
	Iterator,"for SCNormalSurface",
	[SCIsNormalSurface],
function(complex)
	local faces;
	faces:=SCFaceLattice(complex);

	if(faces=fail) then
		return fail;
	fi;
	
	return Iterator(faces);
end);

InstallMethod(
	IsSubset,"for SCNormalSurface",
	[SCIsNormalSurface,SCIsNormalSurface],
function(complex1,complex2)
	return SCIsSubcomplex(complex1,complex2);
end);

SCIntFunc.isValidNormalSurface:=function(facets)
 	if(not IsList(facets) or not IsDuplicateFreeList(facets) or not ForAll(facets,x->IsList(x) and IsDuplicateFree(x) and (Size(x) in [3,4])) or not SCIntFunc.HasValidLabels(facets)) then
 		return false;
 	else
 		return true;
 	fi;
end;


################################################################################
##<#GAPDoc Label="SCNSFromFacets">
## <ManSection>
## <Meth Name="SCNSFromFacets" Arg="facets"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructor for a discrete normal surface from a facet list, see <Ref Meth="SCFromFacets"/> for details.
## <Example><![CDATA[
## gap> sl:=SCNSFromFacets([[1,2,3],[1,2,4,5],[1,3,4,6],[2,3,5,6],[4,5,6]]);
## [NormalSurface
## 
##  Properties known: Dim, Facets, Name, SCVertices.
## 
##  Name="unnamed discrete normal surface m"
##  Dim=2
## 
## /NormalSurface]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCNSFromFacets,
"for List",
[IsList],
function(facets)
	local obj,dim,faces,known,element,vertices,i,j,idx,lfacets;

	if(not SCIntFunc.isValidNormalSurface(facets)) then
		Info(InfoSimpcomp,1,"SCNormalSurface: invalid facet list.");
		return fail;
	fi;

	if(facets=[]) then
		obj:=SCNSEmpty();
	else

		lfacets:=Set(SCIntFunc.DeepCopy(facets));
		Perform(lfacets,Sort);
		vertices:=Union(lfacets);
		for i in [1..Size(lfacets)] do
			for j in [1..Size(lfacets[i])] do
				idx:=Position(vertices,lfacets[i][j]);
				if idx<>fail then
					lfacets[i][j]:=idx;
				else
					Info(InfoSimpcomp,1,"SCNSFromFacets: error in vertex index.");
					return fail;
				fi;
			od;
		od;

		obj:=SCIntFunc.SCNSNew();
		SetSCVertices(obj,vertices);
		SetSCDim(obj,2);
		SetSCFacetsEx(obj,lfacets);
		SetSCName(obj,Concatenation("unnamed complex ",String(SCSettings.ComplexCounter)));
		
		SCSettings.ComplexCounter:=SCSettings.ComplexCounter+1;
	fi;

	return obj;
end);

################################################################################
##<#GAPDoc Label="SCNS">
## <ManSection>
## <Meth Name="SCNS" Arg="facets"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Internally calls <Ref Meth="SCNSFromFacets"/>.
## <Example><![CDATA[
## gap> sl:=SCNS([[1,2,3],[1,2,4,5],[1,3,4,6],[2,3,5,6],[4,5,6]]);
## [NormalSurface
## 
##  Properties known: Dim, Facets, Name, SCVertices.
## 
##  Name="unnamed discrete normal surface n"
##  Dim=2
## 
## /NormalSurface]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCNS,
"for List",
[IsList],
function(facets)
	return SCNSFromFacets(facets);
end);

#print discrete normal surface info (in compact format)
#compact format: chi, fvec
InstallMethod(ViewObj,"for SCNormalSurface",
[SCIsNormalSurface],
	function(sl)
	Print(String(sl));
end);

##print simplicial complex info
InstallMethod(
PrintObj,"for SCNormalSurface",
[SCIsNormalSurface],
 function(sl)
 	Print(String(sl));
end);


################################################################################
##<#GAPDoc Label="SCNSCopy">
## <ManSection>
## <Meth Name="SCCopy" Arg="complex"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Copies a &GAP; object of type <C>SCNormalSurface</C> (cf. <Ref Meth="SCCopy"/>).
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdSimplex(4),[[1],[2..5]]);
## [NormalSurface
## 
##  Properties known: Chi, ConnectedComponents, Dim, F, Facets, Genus, IsConnect\
## ed, Name, Oriented, Subdivision, TopologicalType, SCVertices, Vertices.
## 
##  Name="slicing [ [ 1 ], [ 2, 3, 4, 5 ] ] of S^3_5"
##  Dim=2
##  Chi=2
##  F=[ 4, 6, 4 ]
##  IsConnected=true
##  TopologicalType="S^2"
## 
## /NormalSurface]
## gap> sl_2:=SCCopy(sl);                          
## [NormalSurface
## 
##  Properties known: Chi, ConnectedComponents, Dim, F, Facets, Genus, IsConnect\
## ed, Name, Oriented, Subdivision, TopologicalType, SCVertices, Vertices.
## 
##  Name="slicing [ [ 1 ], [ 2, 3, 4, 5 ] ] of S^3_5"
##  Dim=2
##  Chi=2
##  F=[ 4, 6, 4 ]
##  IsConnected=true
##  TopologicalType="S^2"
## 
## /NormalSurface]
## gap> IsIdenticalObj(sl,sl_2);                     
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCopy,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)

	local a,c,attr;
	
	attr:=KnownAttributesOfObject(complex);
	c:=SCIntFunc.SCNSNew();
	if c = fail then
		return fail;
	fi;
	
	for a in attr do
		Setter(EvalString(a))(c,complex!.(a));
	od;
	return c;
end);

#check which faces already exist (by dimension)
#existNSFaces:=function(complex,size)

# 	local faces;

# 	faces:=SCPropertyByName(complex,"Faces");
# 	if size<=4 then
# 		if faces<>fail then
# 			if size<=Size(faces) and IsBound(faces[size]) and faces[size]<>[] then
# 				if(not IsList(faces[size]) or not IsDuplicateFreeList(faces[size]) or not ForAll(faces[size],x->IsList(x) and IsDuplicateFree(x) and Size(x) in [3,4])) then
# 					Info(InfoSimpcomp,1,"existNSFaces: invalid face lattice found.");
# 					return fail;
# 				else
# 					return true;
# 				fi;
# 			else
# 				return false;
# 			fi;
# 		else
# 			return false;
# 		fi;
# 	else
# 		Info(InfoSimpcomp,1,"existNSFaces: Size must be equal or smaller then 4.");
# 		return fail;
# 	fi;
# end;


################################################################################
##<#GAPDoc Label="SCNSEmpty">
## <ManSection>
## <Func Name="SCNSEmpty" Arg=""/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates an empty complex (of dimension <M>-1</M>), i. e. an object of type <C>SCNormalSurface</C> with empty facet list.
## <Example><![CDATA[
## gap> SCNSEmpty();
## [NormalSurface
## 
##  Properties known: Dim, Faces, Facets, Name, SCVertices.
## 
##  Name="empty discrete normal surface"
##  Dim=-1
## 
## /NormalSurface]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCNSEmpty,
function()
	local obj;

	obj:=SCIntFunc.SCNSNew();
	SetSCVertices(obj,[]);
	SetSCDim(obj,-1);
	SetSCFacetsEx(obj,[]);
	SetSCName(obj,"empty normal surface");	
	SetFilterObj(obj,IsEmpty);
	
	return obj;
end);

################################################################################
##<#GAPDoc Label="SCNSDim">
## <ManSection>
## <Meth Name="SCDim" Arg="sl"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dimension of a discrete normal surface (which is always <M>2</M> if the slicing <Arg>sl</Arg> is not empty).
## <Example><![CDATA[
## gap> sl:=SCNSEmpty();;                                                    
## gap> SCDim(sl);                                                         
## -1
## gap> sl:=SCNSFromFacets([[1,2,3],[1,2,4,5],[1,3,4,6],[2,3,5,6],[4,5,6]]);;
## gap> SCDim(sl);                                                         
## 2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDim,
"for SCNormalSurface",
[SCIsNormalSurface],
function(sl)
	
	if SCIsEmpty(sl) then
		return -1;
	else
	 	return 2;
	fi;

end);

################################################################################
##<#GAPDoc Label="SCNSFVector">
## <ManSection>
## <Meth Name="SCFVector" Arg="sl"/>
## <Returns>a <M>1</M>, <M>3</M> or <M>4</M> tuple of (non-negative) integer values upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of a discrete normal surface, i. e. the number of vertices, edges, triangles and quadrilaterals of <Arg>sl</Arg>, cf. <Ref Meth="SCFVector"/>.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2xS^1");;
## gap> c:=SCLib.Load(list[1][1]);;             
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);;
## gap> SCFVector(sl);                 
## [ 20, 40, 16, 8 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFVector,
"for SCNormalSurface and SCIsEmpty",
[SCIsNormalSurface and IsEmpty],
function(sl)
	return [0];
end);


InstallMethod(SCFVector,
"for SCNormalSurface",
[SCIsNormalSurface],
function(sl)

 	local elements, f, faces, facets;


	facets:=SCFacetsEx(sl);
	if facets = fail then
		return fail;
	fi;
	f:=ShallowCopy(SCFVector(SCFromFacets(facets)));
	if f = fail then
		return fail;
	fi;
 	
 	if Length(f) =3 then
 	 		return f;
 	elif Length(f) =4 then
 		f[3]:=f[3] - 4*f[4];
 		f[2]:=f[2] - 2*f[4];
 	 		return f;
 	else
 		Info(InfoSimpcomp,1,"SCFVector: illegal f-vector found: ",f);
 		return fail;
 	fi;
end);

################################################################################
##<#GAPDoc Label="SCNSEulerCharacteristic">
## <ManSection>
## <Meth Name="SCEulerCharacteristic" Arg="sl"/>
## <Returns>an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Euler characteristic of a discrete normal surface <Arg>sl</Arg>, cf. <Ref Meth="SCEulerCharacteristic"/>.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2xS^1");;  
## gap> c:=SCLib.Load(list[1][1]);;             
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);;
## gap> SCEulerCharacteristic(sl);                 
## 4
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCEulerCharacteristic,
"for SCNormalSurface",
[SCIsNormalSurface],
function(sl)

 	local facets, f, chi;

  	
 	f:=SCFVector(sl);
 	if(f=fail) then
 		return fail;
 	fi;
	
	if Length(f) = 1 then
	 		return f[1];
	elif Length(f) =3 then
 	 		return f[1]-f[2]+f[3];
 	elif Length(f) =4 then
 	 		return f[1]-f[2]+f[3]+f[4];
 	else
 		Info(InfoSimpcomp,1,"SCEulerCharacteristic: illegal f-vector found: ",f,". ");
 		return fail;
 	fi;

end);


################################################################################
##<#GAPDoc Label="SCNSGenus">
## <ManSection>
## <Meth Name="SCGenus" Arg="sl"/>
## <Returns>a non-negative integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the genus of a discrete normal surface <Arg>sl</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;               
## gap> c.F;                               
## [ 27, 298, 542, 271 ]
## gap> sl:=SCNSSlicing(c,[[1..12],[13..27]]);;
## gap> SCIsConnected(sl);
## true
## gap> SCGenus(sl);                     
## 7
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCGenus,
"for SCNormalSurface",
[SCIsNormalSurface],
function(sl)

 	local facets, chi, g, conn;

  	
 	conn:=SCIsConnected(sl);
 	if conn<>true then
 		Info(InfoSimpcomp,1,"SCGenus: discrete normal surface needs to be connected and valid.");
 		return fail;
	fi;
	
 	chi:=SCEulerCharacteristic(sl);
 	if(chi=fail) then
 		return fail;
	fi;
  	return (2-chi)/2;

end);

################################################################################
##<#GAPDoc Label="SCNSIsEmpty">
## <ManSection>
## <Meth Name="SCIsEmpty" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a normal surface <Arg>complex</Arg> is the empty complex, i. e. a <C>SCNormalSurface</C> object with empty facet list.
## <Example><![CDATA[
## gap> sl:=SCNS([]);;
## gap> SCIsEmpty(sl);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsEmpty,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)

	local facets, empty;

			
	facets:=SCFacetsEx(complex);
	if(facets=fail) then
		return fail;
	fi;

	empty:=facets=[];
	if empty = true then
		SetFilterObj(complex,IsEmpty);
	fi;
	return facets=[];
end);

################################################################################
##<#GAPDoc Label="SCNSUnion">
## <ManSection>
## <Meth Name="SCUnion" Arg="complex1, complex2"/>
## <Returns>normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the union of two normal surfaces <Arg>complex1</Arg> and <Arg>complex2</Arg> as the normal surface formed by the union of their facet sets. The two arguments are not altered. Note: for the union process the vertex labelings of the complexes are taken into account, see also <Ref Meth="Operation Union (SCNormalSurface, SCNormalSurface)" />. Facets occurring in both arguments are treated as one facet in the new complex.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByAttribute("Dim=3 and F[1]=10");;
## gap> c:=SCLib.Load(list[1][1]);
## gap> sl1:=SCNSSlicing(c,[[1..5],[6..10]]);;
## gap> sl2:=sl1+10;;
## gap> sl3:=SCUnion(sl1,sl2);;
## gap> SCTopologicalType(sl3);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCUnion,
"for SCNormalSurface and SCNormalSurface",
[SCIsNormalSurface,SCIsNormalSurface],
function(complex1,complex2)
	local facets,un,f1,f2;
	
	f1:=SCIntFunc.DeepCopy(SCFacets(complex1));
	f2:=SCIntFunc.DeepCopy(SCFacets(complex2));
	if f1 = fail or f2 = fail then
		return fail;
	fi;
	SCIntFunc.DeepSortList(f1);
	SCIntFunc.DeepSortList(f2);
	
	facets:=Union(f1,f2);
	if(fail in facets) then
		return fail;
	fi;

	un:=SCNSFromFacets(facets);

	if un = fail then
		Info(InfoSimpcomp,1,"SCUnion: can not unite complexes.");
		return fail;
	fi;
	
	if(SCName(complex1)<>fail and SCName(complex2)<>fail) then
		SCRename(un,Concatenation(SCName(complex1)," cup ",SCName(complex2)));
	fi;
	
	return un;
end);


################################################################################
##<#GAPDoc Label="SCNSIsConnected">
## <ManSection>
## <Meth Name="SCIsConnected" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a normal surface <Arg>complex</Arg> is connected.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByAttribute("Dim=3 and F[1]=10");;
## gap> c:=SCLib.Load(list[1][1]);
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);
## gap> SCIsConnected(sl);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsConnected,
"for SCNormalSurface and IsEmpty",
[SCIsNormalSurface and IsEmpty],
function(complex)
		return false;
end);

InstallMethod(SCIsConnected,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)

	local vertices, star, connected,
		verticesComponent, innerVertices, treatedVertices, curv;
		

	vertices:=SCVertices(complex);
	if vertices=fail then
		return fail;
	fi;
	
	innerVertices:=[vertices[1]];
	treatedVertices:=[];
	verticesComponent:=[];
	
	while verticesComponent<>vertices and innerVertices<>[] do
		curv:=innerVertices[1];
		star:=SCStar(complex,[curv]);
		
		innerVertices:=Union(innerVertices,Difference(SCVertices(star),treatedVertices));
		
		AddSet(treatedVertices,curv);
		RemoveSet(innerVertices,curv);
		
		verticesComponent:=Union(verticesComponent,SCIntFunc.DeepCopy(SCVertices(star)));
	od;

	return verticesComponent=vertices;
end);

################################################################################
##<#GAPDoc Label="SCNSConnectedComponents">
## <ManSection>
## <Meth Name="SCConnectedComponents" Arg="complex"/>
## <Returns> a list of simplicial complexes of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all connected components of an arbitrary normal surface.
## <Example><![CDATA[
## gap> sl:=SCNSSlicing(SCBdCrossPolytope(4),[[1,2],[3..8]]);
## gap> cc:=SCConnectedComponents(sl);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>                                         
################################################################################
InstallMethod(SCConnectedComponents,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)

	local vertices, star, conncomps, verticesComponent, innerVertices, treatedVertices, name, i, labels, span, facets, sc;
	

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCConnectedComponents: complex lacks vertex labels.");
		return fail;
	fi;

	facets:=SCFacetsEx(complex);
	vertices:=SCVerticesEx(complex);
	if facets=fail or vertices=fail then
		return fail;
	fi;
	
	conncomps:=[];
	while vertices<>[] do 
		innerVertices:=[vertices[1]];
		treatedVertices:=[];
		verticesComponent:=[];
		while verticesComponent<>vertices and innerVertices<>[] do
			star:=Filtered(facets,x->innerVertices[1] in x);
			AddSet(treatedVertices,innerVertices[1]);
			RemoveSet(innerVertices,innerVertices[1]);
			innerVertices:=Union(innerVertices,Difference(Union(star),treatedVertices));
			verticesComponent:=Union(verticesComponent,Union(star));
		od;
		span:=Filtered(facets,x->IsSubset(verticesComponent,x));
		Add(conncomps,span);
		vertices:=Difference(vertices,verticesComponent);
	od;

	
	name:=SCName(complex);
	if name = fail then
		return fail;
	fi;
	
	if(Size(conncomps)>0) then
		for i in [1..Length(conncomps)] do
			conncomps[i]:=SCNSFromFacets(SCIntFunc.RelabelSimplexList(conncomps[i],labels));
			SCRename(conncomps[i],Concatenation(["Connected component #",String(i)," of ",name])); 
		od;
	fi;
	
	SetSCIsConnected(complex,Size(conncomps)=1);
	return conncomps;

end);



################################################################################
##<#GAPDoc Label="SCNSSkelEx">
## <ManSection>
## <Meth Name="SCSkelEx" Arg="sl,k"/>
## <Returns>a face list (of <Arg>k+1</Arg>tuples) or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all faces of cardinality <Arg>k+1</Arg> in the standard labeling: <Arg>k</Arg> <M>= 0</M> computes the vertices,  <Arg>k</Arg> <M>= 1</M> computes the edges,  <Arg>k</Arg> <M>= 2</M> computes the triangles,  <Arg>k</Arg> <M>= 3</M> computes the quadrilaterals.<P/>
## 
## If <Arg>k</Arg> is a list (necessarily a sublist of <C>[ 0,1,2,3 ]</C>) all faces of all cardinalities contained in <Arg>k</Arg> are computed.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkelEx(sl,1);                            
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkelEx(sl,3);                            
## [ ]
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCSkelEx(sl,3);                            
## [ [ 1, 2, 4, 5 ], [ 1, 3, 4, 6 ], [ 2, 3, 5, 6 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSkelExOp,
"for SCNormalSurface and Int",
[SCIsNormalSurface,IsInt],
function(sl, k)

	local element, faces, facets, i, ctr, edgecand;
	
	
	if(k<0 or k>3) then
			return [];
	fi;

	faces:=[];
  facets:=SCFacetsEx(sl);
  if facets = fail then
  	return fail;
  fi;
	
	if k=0 then
		faces:=Union(List(facets,x->Combinations(x,1)));
	elif k=1 then
		edgecand:=Union(List(facets,x->Combinations(x,2)));
		faces:=[];
		for i in [1..Size(edgecand)] do
			ctr:=0;
			for element in  facets do
				if IsSubset(element,edgecand[i]) then
					ctr:=ctr+1;
				fi;
				if ctr=2 then
					Add(faces,edgecand[i]);
					break;
				fi;
			od;
		od;
	else
		faces:=Filtered(facets,x->Size(x)=k+1);
	fi;	

	return faces;


end);

################################################################################
##<#GAPDoc Label="SCNSSkel">
## <ManSection>
## <Meth Name="SCSkel" Arg="sl,k"/>
## <Returns>a face list (of <Arg>k+1</Arg>tuples) or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all faces of cardinality <Arg>k+1</Arg> in the original labeling: <Arg>k</Arg> <M>= 0</M> computes the vertices,  <Arg>k</Arg> <M>= 1</M> computes the edges,  <Arg>k</Arg> <M>= 2</M> computes the triangles,  <Arg>k</Arg> <M>= 3</M> computes the quadrilaterals.<P/>
## 
## If <Arg>k</Arg> is a list (necessarily a sublist of <C>[ 0,1,2,3 ]</C>) all faces of all cardinalities contained in <Arg>k</Arg> are computed.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkel(sl,1);                            
## [ [ [ 1, 2 ], [ 1, 3 ] ], [ [ 1, 2 ], [ 1, 4 ] ], [ [ 1, 2 ], [ 1, 5 ] ], 
##   [ [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 3 ], [ 1, 5 ] ], [ [ 1, 4 ], [ 1, 5 ] ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1],[2..5]]);;
## gap> SCSkel(sl,3);                            
## [ ]
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCSkelEx(sl,3);                            
## [ [ [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ] ], 
##   [ [ 1, 3 ], [ 1, 5 ], [ 2, 3 ], [ 2, 5 ] ], 
##   [ [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 5 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSkel,
"for SCNormalSurface and Int",
[SCIsNormalSurface,IsInt],
function(sl, k)
	
	local labels,skel;
	
	labels:=SCLabels(sl);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCSkel: discrete normal surface lacks vertex labels.");
		return fail; 
	fi;
	
	if(IsList(k)) then
		skel:=List(SCSkelEx(sl,k),x->SCIntFunc.RelabelSimplexList(x,labels));
	else
		skel:=SCIntFunc.RelabelSimplexList(SCSkelEx(sl,k),labels);
	fi;
	
	return skel;
	
end);


################################################################################
##<#GAPDoc Label="SCNSFaceLatticeEx">
## <ManSection>
## <Meth Name="SCFaceLatticeEx" Arg="complex"/>
## <Returns>a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the face lattice of a discrete normal surface <Arg>sl</Arg> in the standard labeling. Triangles and quadrilaterals are stored separately (cf. <Ref Meth="SCSkelEx" />).
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCFaceLatticeEx(sl);                            
## [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
##   [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 5 ], 
##     [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], [ 5, 6 ] ], 
##   [ [ 1, 2, 3 ], [ 4, 5, 6 ] ], 
##   [ [ 1, 2, 4, 5 ], [ 1, 3, 4, 6 ], [ 2, 3, 5, 6 ] ] ]
## gap> sl.F;
## [ 6, 9, 2, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFaceLatticeEx,
"for SCNormalSurface and IsEmpty",
[SCIsNormalSurface and IsEmpty],
function(complex)
	return [];
end);

InstallMethod(SCFaceLatticeEx,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)

	local faces,dim,i,f,chi,flag;

	faces:=[];
	for i in [0..3] do
	  faces[i+1]:=SCSkelEx(complex,i);
		if(faces[i+1]=fail) then
			return fail;
		fi;
	od;

	return faces;

end);

################################################################################
##<#GAPDoc Label="SCNSFaceLattice">
## <ManSection>
## <Meth Name="SCFaceLattice" Arg="complex"/>
## <Returns>a list of facet lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the face lattice of a discrete normal surface <Arg>sl</Arg> in the original labeling. Triangles and quadrilaterals are stored separately (cf. <Ref Meth="SCSkel" />).
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;              
## gap> sl:=SCNSSlicing(c,[[1,2],[3..5]]);;
## gap> SCFaceLattice(sl);                            
## [ [ [ [ 1, 3 ] ], [ [ 1, 4 ] ], [ [ 1, 5 ] ], [ [ 2, 3 ] ], [ [ 2, 4 ] ], 
##       [ [ 2, 5 ] ] ], 
##   [ [ [ 1, 3 ], [ 1, 4 ] ], [ [ 1, 3 ], [ 1, 5 ] ], [ [ 1, 3 ], [ 2, 3 ] ], 
##     [ [ 1, 4 ], [ 1, 5 ] ], [ [ 1, 4 ], [ 2, 4 ] ], [ [ 1, 5 ], [ 2, 5 ] ],
##     [ [ 2, 3 ], [ 2, 4 ] ], [ [ 2, 3 ], [ 2, 5 ] ], [ [ 2, 4 ], [ 2, 5 ] ] ], 
##   [ [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ], [ [ 2, 3 ], [ 2, 4 ], [ 2, 5 ] ] ], 
##   [ [ [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ] ], 
##     [ [ 1, 3 ], [ 1, 5 ], [ 2, 3 ], [ 2, 5 ] ], 
##     [ [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 5 ] ] ] ]
## gap> sl.F;
## [ 6, 9, 2, 3 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFaceLattice,
"for SCNormalSurface and IsEmpty",
[SCIsNormalSurface and IsEmpty],
function(complex)
	return [];
end);

InstallMethod(SCFaceLattice,
"for SCNormalSurface",
[SCIsNormalSurface],
function(complex)

	local labels;
	labels:=SCLabels(complex);
	if labels = fail then
		return fail;
	fi;
	return List(SCFaceLatticeEx(complex),x->SCIntFunc.RelabelSimplexList(x,labels));

end);

################################################################################
##<#GAPDoc Label="SCNSTriangulation">
## <ManSection>
## <Meth Name="SCNSTriangulation" Arg="sl"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a simplicial subdivision of a slicing <Arg>sl</Arg> without introducing new vertices. The subdivision is stored as a property of <Arg>sl</Arg> and thus is returned as an immutable object. Note that symmetry may be lost during the computation. 
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F=[ 10, 35, 50, 25 ]");
## [ [ 19, "S^3 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> sl:=SCNSSlicing(c,[[1,3,5,7,9],[2,4,6,8,10]]);;
## gap> sl.F; 
## [ 9, 18, 0, 9 ]
## gap> sc:=SCNSTriangulation(sl);;
## gap> sc.F;
## [ 9, 27, 18 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCNSTriangulation,
"for SCNormalSurface",
[SCIsNormalSurface],
 	function(sl)

 	local slfacets, scomplex, element, sc;

 	slfacets:=SCFacetsEx(sl);
 	if(slfacets=fail) then
 		return fail;
 	fi;

	# compute simplicial subdivision
	scomplex:=[];
	for element in slfacets do
	 if Size(element)=3 then
		 Add(scomplex,element);
	 elif Size(element)=4 then
		 Add(scomplex,element{[1..3]});
		 Add(scomplex,element{[2..4]});
	 fi;
  od;
 	sc:=SCFromFacets(scomplex);
	if(sc=fail) then
 		return fail;
 	fi;
 	
	return ShallowCopy(sc);

end);


################################################################################
##<#GAPDoc Label="SCNSHomology">
## <ManSection>
## <Meth Name="SCHomology" Arg="sl"/>
## <Returns>a list of homology groups upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the homology of a slicing <Arg>sl</Arg>. Internally, <Arg>sl</Arg> is triangulated (cf. <Ref Meth="SCNSTriangulation"/>) and simplicial homology is computed via <Ref Meth="SCHomology"/> using the triangulation.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");       
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c.F;
## [ 27, 298, 542, 271 ]
## gap> sl:=SCNSSlicing(c,[[1..12],[13..27]]);;   
## gap> sl.Homology;
## [ [ 0, [  ] ], [ 14, [  ] ], [ 1, [  ] ] ]
## gap> sl:=SCNSSlicing(c,[[1..13],[14..27]]);;
## gap> sl.Homology;                       
## [ [ 1, [  ] ], [ 14, [  ] ], [ 2, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomology,
"for SCNormalSurface",
[SCIsNormalSurface],
 	function(sl)

 	local scomplex, hom;

 	scomplex:=SCNSTriangulation(sl);
 	if scomplex=fail then
 	  return fail;
 	fi;
 	hom:=SCHomology(scomplex);
  	return hom;

end); 
	
################################################################################
##<#GAPDoc Label="SCNSFpBettiNumbers">
## <ManSection>
## <Meth Name="SCFpBettiNumbers" Arg="sl,p"/>
## <Returns>a list of non-negative integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Betti numbers modulo <Arg>p</Arg> of a slicing <Arg>sl</Arg>. Internally, <Arg>sl</Arg> is triangulated (using <Ref Meth="SCNSTriangulation"/>) and the Betti numbers are computed via <Ref Meth="SCFpBettiNumbers"/> using the triangulation.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");       
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c.F;
## [ 27, 298, 542, 271 ]
## gap> sl:=SCNSSlicing(c,[[1..13],[14..27]]);;
## gap> SCFpBettiNumbers(sl,2);
## [ 2, 14, 2 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFpBettiNumbersOp,
"for SCNormalSurface and IsEmpty",
[SCIsNormalSurface and IsEmpty,IsInt],
function(complex,p)
	if not IsPrime(p) then
		Info(InfoSimpcomp,1,"SCFpBettiNumbersOp: second argument must be a prime.");
		return fail;
	fi;
	
	return [];
end);


InstallMethod(SCFpBettiNumbersOp,
"for SCNormalSurface and Prime",
[SCIsNormalSurface,IsInt],
function(sl,p)

 	local scomplex, pbetti;

  	
	if not IsPrime(p) then
		Info(InfoSimpcomp,1,"SCFpBettiNumbersOp: second argument must be a prime.");
		return fail;
	fi;

	scomplex:=SCNSTriangulation(sl);
 	if scomplex=fail then
 		return fail;
 	fi;
 	pbetti:=SCFpBettiNumbers(scomplex,p);
 	if  pbetti=fail then
 		return fail;
 	fi;

  	return pbetti;

end);	


################################################################################
##<#GAPDoc Label="SCNSTopologicalType">
## <ManSection>
## <Meth Name="SCTopologicalType" Arg="sl"/>
## <Returns>a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Determines the topological type of <Arg>sl</Arg> via the classification theorem for closed compact surfaces. If <Arg>sl</Arg> is not connected, the topological type of each connected component is computed.<P/>
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#20");      
## [ [ 633, "(S^2xS^1)#20" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> c.F;
## [ 27, 298, 542, 271 ]
## gap> for i in [1..26] do sl:=SCNSSlicing(c,[[1..i],[i+1..27]]); Print(sl.TopologicalType,"\n"); od;                                           
## S^2
## S^2
## S^2
## S^2
## S^2 U S^2
## S^2 U S^2
## S^2
## (T^2)#3
## (T^2)#5
## (T^2)#4
## (T^2)#3
## (T^2)#7
## (T^2)#7 U S^2
## (T^2)#7 U S^2
## (T^2)#7 U S^2
## (T^2)#8 U S^2
## (T^2)#7 U S^2
## (T^2)#8
## (T^2)#6
## (T^2)#6
## (T^2)#5
## (T^2)#3
## (T^2)#2
## T^2
## S^2
## S^2
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCTopologicalType,
"for SCNormalSurface",
[SCIsNormalSurface],
 	function(sl) 
	
 	local cc, c, scomplex, chi, f, g, dim, hom, name, element, ctr, ctype, conn;

 	
 	name:=SCName(sl);
 	if name = fail then
 		return fail;
 	fi;

	#compute simplicial subdivision
 	scomplex:=SCNSTriangulation(sl);
 	if scomplex=fail then
 		return fail;
 	fi;
	
 	hom:=SCHomology(scomplex);
	if hom=fail then
 		return fail;
 	fi;
 	if hom[3]=[hom[1][1]+1,[]] then
 		SetSCIsOrientable(sl,true);
 	else
 		SetSCIsOrientable(sl,false);
 	fi;
 	chi:=SCEulerCharacteristic(sl);
 	conn:=SCIsConnected(sl);
 	if conn then
 		g:=SCGenus(sl);
 		if g=fail then
 			return fail;
 		fi;
 	fi;
 	f:=SCFVector(sl);
 	if chi=fail or f=fail then
 		return fail;
 	fi;
 
 	ctype:="";
 	cc:=SCConnectedComponents(sl);
 	ctr:=0;
 	for c in cc do
 		ctr:=ctr+1;
 		if name<>fail then
 			SCRename(c,Concatenation([name,"_cc_#",String(ctr)]));
 		else
 			SCRename(c,Concatenation([name,"_cc_#",String(ctr)]));
 		fi;
		
		# compute simplicial subdivision
 		scomplex:=SCNSTriangulation(c);
 		if scomplex=fail then
 			return fail;
 		fi;
		
 		hom:=SCHomology(scomplex);
 		if hom=fail then
 			return fail;
 		fi;
 		SetSCIsConnected(c,true);
		
 		if hom[3]=[hom[1][1]+1,[]] then
 			SetSCIsOrientable(c,true);
 		else
 			SetSCIsOrientable(c,false);
 		fi;
 		chi:=SCEulerCharacteristic(c);
 		g:=SCGenus(c);
 		f:=SCFVector(c);
 		if chi=fail or g=fail or f=fail then
 			return fail;
 		fi;
 		if hom[1]=[0,[]] and hom[3]=[1,[]] then
 			if g=0 then
 				SetSCTopologicalType(c,"S^2");
 			elif g=1 then
 				SetSCTopologicalType(c,"T^2");
 			elif g>1 then
 				SetSCTopologicalType(c,Concatenation("(T^2)#",String(g)));
 			fi;
 		elif hom[1]=[0,[]] and hom[3]=[0,[]] then
 			if g=1/2 then
 				SetSCTopologicalType(c,"RP^2");
 			elif g>1/2 then
 				SetSCTopologicalType(c,Concatenation("(RP^2)#",String(2*g)));
 			fi;
 		fi;
		
 		if ctr>1 then
 			ctype:=Concatenation([ctype," U ",SCTopologicalType(c)]);
 		else
 			ctype:=Concatenation([ctype,SCTopologicalType(c)]);
 		fi;
 	od;

 	return ctype;
	
end);

################################################################################
##<#GAPDoc Label="SCNSIsOrientable">
## <ManSection>
## <Meth Name="SCIsOrientable" Arg="sl"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a discrete normal surface <Arg>sl</Arg> is orientable.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> sl:=SCNSSlicing(c,[[1,2],[3,4,5]]);
## gap> SCIsOrientable(sl);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsOrientable,
"for SCNormalSurface and IsEmpty",
[SCIsNormalSurface and IsEmpty],
function(sl)
	return true;
end);

InstallMethod(SCIsOrientable,
"for SCNormalSurface",
[SCIsNormalSurface],
function(sl)

	local  hom;

	
	hom:=SCHomology(sl);
	if hom = fail then
		return fail;
	fi;
	
	if hom[1][1] + 1 = hom[3][1] then
			return true;
	else
			return false;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCNSSlicing">
## <ManSection>
## <Func Name="SCNSSlicing" Arg="complex,slicing"/>
## <Returns>discrete normal surface of type <C>SCNormalSurface</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a slicing defined by a partition <Arg>slicing</Arg> of the set of vertices of the <M>3</M>-dimensional combinatorial pseudomanifold  <Arg>complex</Arg>. In particular, <Arg>slicing</Arg> has to be a pair of lists of vertex labels and has to contain all vertex labels of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F=[ 10, 35, 50, 25 ]");
## [ [ 19, "S^3 (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;                       
## gap> sl:=SCNSSlicing(c,[[1..5],[6..10]]);    
## [NormalSurface
## 
##  Properties known: Chi, ConnectedComponents, Dim, F, Facets, Genus, IsConnect\
## ed, Name, Oriented, Subdivision, TopologicalType, SCVertices, Vertices.
## 
##  Name="slicing [ [ 1, 2, 3 ], [ 4, 5, 6 ] ] of S^3 (VT)"
##  Dim=2
##  Chi=2
##  F=[ 9, 16, 4, 5 ]
##  IsConnected=true
##  TopologicalType="S^2"
## 
## /NormalSurface]
## gap> sl.Facets;
## [ [ [ 1, 4 ], [ 2, 4 ], [ 3, 4 ] ], 
##   [ [ 1, 6 ], [ 2, 6 ], [ 3, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 5 ] ], 
##   [ [ 1, 5 ], [ 1, 6 ], [ 2, 5 ], [ 2, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 6 ], [ 3, 4 ], [ 3, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 5 ], [ 1, 6 ] ], 
##   [ [ 2, 4 ], [ 2, 5 ], [ 3, 4 ], [ 3, 5 ] ], 
##   [ [ 2, 5 ], [ 2, 6 ], [ 3, 5 ], [ 3, 6 ] ], 
##   [ [ 3, 4 ], [ 3, 5 ], [ 3, 6 ] ] ]
## gap> sl:=SCNSSlicing(c,[[1,3,5,7,9],[2,4,6,8,10]]);    
## [NormalSurface
## 
##  Properties known: Chi, ConnectedComponents, Dim, F, Facets, Genus, IsConnect\
## ed, Name, Oriented, Subdivision, TopologicalType, SCVertices, Vertices.
## 
##  Name="slicing [ [ 1, 3, 5 ], [ 2, 4, 6 ] ] of S^3 (VT)"
##  Dim=2
##  Chi=0
##  F=[ 9, 18, 0, 9 ]
##  IsConnected=true
##  TopologicalType="T^2"
## 
## /NormalSurface]
## gap> sl.Facets;                           
## [ [ [ 1, 2 ], [ 1, 4 ], [ 3, 2 ], [ 3, 4 ] ], 
##   [ [ 1, 2 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ] ], 
##   [ [ 1, 2 ], [ 1, 4 ], [ 5, 2 ], [ 5, 4 ] ], 
##   [ [ 1, 2 ], [ 1, 6 ], [ 5, 2 ], [ 5, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 6 ], [ 3, 4 ], [ 3, 6 ] ], 
##   [ [ 1, 4 ], [ 1, 6 ], [ 5, 4 ], [ 5, 6 ] ], 
##   [ [ 3, 2 ], [ 3, 4 ], [ 5, 2 ], [ 5, 4 ] ], 
##   [ [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 6 ] ], 
##   [ [ 3, 4 ], [ 3, 6 ], [ 5, 4 ], [ 5, 6 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCNSSlicing,
 	function(complex,slicing)

 	local sl, cc, c, vertices, facets, slfacets, scomplex, chi, f, g, dim, hom, name, tmp1, tmp2, i, element, str, ctr, type;

 	if not SCIsSimplicialComplex(complex) then
 		Info(InfoSimpcomp,1,"SCNSSlicing: first argument must be of type SCSimplicialComplex.");
 		return fail;
 	fi;
	
	dim:=SCDim(complex);
	if dim = fail or dim <> 3 then
		Info(InfoSimpcomp,1,"SCNSSlicing: first argument must be a simplicial complex of dimension 3.");
		return fail;
	fi;
	
 	vertices:=SCVerticesEx(complex);
 	facets:=SCFacetsEx(complex);
	if vertices = fail or facets = fail then
		return fail;
	fi;
 	if(not IsList(slicing) or Size(slicing)<>2 or Union(slicing)<>vertices) then
 		Info(InfoSimpcomp,1,"SCNSSlicing: slicing must be a partition of 'vertices'"); 
 		return fail;
 	fi;

 	slfacets:=[];
  for i in [1..Size(facets)] do
		tmp1:=Intersection(facets[i], slicing[1]);
    tmp2:=Intersection(facets[i], slicing[2]);
		if tmp1<>[] and tmp2<>[] then
    	Add(slfacets,Cartesian(tmp1,tmp2));
 		fi;
  od;
	
	# create discrete normal surface from facets
 	sl:=SCNS(slfacets);
 	str:=String(slicing);
  name:=SCName(complex);
	
	type:=SCTopologicalType(sl);
 	if  type=fail then
 		return fail;
 	fi;
 	SetSCTopologicalType(sl,type);
	if name <> fail then
		SCRename(sl,Concatenation(["slicing ",str," of ",String(name)]));
	else
		SCRename(sl,Concatenation(["slicing ",str," of unnamed complex"]));
 	fi;
	
 	return sl;
	
end);

