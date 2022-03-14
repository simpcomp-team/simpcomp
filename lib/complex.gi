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
	Print(SCIntFunc.StringEx(sc));
end);


SCIntFunc.StringEx:=
function(sc)
	local type,buf,props,name,dim,n;

	if(SCIsSimplicialComplex(sc)) then
		type:="SimplicialComplex";
	elif(SCIsNormalSurface(sc)) then
		type:="NormalSurface";
	else
		type:="OtherComplex";
	fi;
	
	buf:=Concatenation("<",type,": ");
	
        name := SCName(sc);
        if name = fail then
          Append(buf,"unnamed complex");
        else
          Append(buf,name);
        fi;

	Append(buf," | dim = ");

        if type = "NormalSurface" or type = "SimplicialComplex" then
          dim := SCDim(sc);
          if dim = fail then
            Info(InfoSimpcomp,1,"SCIntFunc.StringEx: could not compute dimension of complex.");
            Append(buf,"unknown");
          else
            Append(buf,String(dim));
          fi;
	else
          Append(buf,"unknown");
        fi;
        if type = "SimplicialComplex" then
          n := SCNumFaces(sc,0);
          if n = fail then
            Info(InfoSimpcomp,1,"SCIntFunc.StringEx: could not compute number of vertices of complex.");
          else
            Append(buf," | n = ");
            Append(buf,String(n));
          fi;
        fi;

	Append(buf,">");

	return buf;
end;


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
## gap> Print(SCDetails(c));
## gap> c.F;
## gap> c.Homology;
## gap> Print(SCDetails(c));
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCDetails,
function(arg)
	local buf,props,pprops,prop,p,pp,size,pos,sort,type,sc,view,vprops;

        if Length(arg) < 1 or Length(arg) > 3 then
          Info(InfoSimpcomp,1,"SCDetails: function takes between one and three arguments.");
	  return fail;
	fi;

        if Length(arg) >= 1 then
          sc := arg[1];
        fi;

        if Length(arg) >= 2 then
          view := arg[2];
          if not IsBool(view) then
            Info(InfoSimpcomp,1,"SCDetails: second argument must be of type IsBoolean.");
	    return fail;
	  fi;
        fi;

        if Length(arg) >= 3 then
          vprops := arg[3];
          if not IsList(vprops) then
            Info(InfoSimpcomp,1,"SCDetails: third argument must be a list of strings.");
	    return fail;
	  fi;
        fi;

	if(SCIsSimplicialComplex(sc)) then
		type:="SimplicialComplex";
	elif(SCIsNormalSurface(sc)) then
		type:="NormalSurface";
	else
		type:="OtherComplex";
	fi;

        if Length(arg) = 1 then
          if type = "SimplicialComplex" then
            vprops := SCIntFunc.SCViewProperties;
          elif type = "NormalSurface" then
            vprops := SCIntFunc.SCNSViewProperties;
          else
            vprops := [];
          fi;
          view := true;
        fi;

        if Length(arg) = 2 then
          if type = "SimplicialComplex" then
            vprops := SCIntFunc.SCViewProperties;
          elif type = "NormalSurface" then
            vprops := SCIntFunc.SCNSViewProperties;
          else
            vprops := [];
          fi;
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
			Append(buf,".\n");
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
end);


#simplicial complex -> string method
InstallMethod(String,"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(sc)
	return SCIntFunc.StringEx(sc);
end);


#print simplicial complex info
InstallMethod(PrintObj,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(sc)
	Print(SCIntFunc.StringEx(sc));
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
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3)+10;;
## gap> c.Facets;
## [[11, 12, 13], [11, 12, 14], [11, 13, 14], [12, 13, 14]]
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3)-1;;
## gap> c.Facets;
## [[0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]]
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3)*10;;
## gap> c.Facets;
## [[10, 20, 30], [10, 20, 40], [10, 30, 40], [20, 30, 40]]
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=(SCBdSimplex(3)*10) mod 7;;
## gap> c.Facets;
## [[3, 6, 2], [3, 6, 5], [3, 2, 5], [6, 2, 5]]
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=SCBdSimplex(2)^2; #a torus
## ]]></Example>
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
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^3");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCLib.SearchByName("S^2~S^1"){[1..3]};
## [ [ 12, "S^2~S^1 (VT)" ], [ 26, "S^2~S^1 (VT)" ], 
##   [ 27, "S^2~S^1 (VT)" ] ]
## gap> d:=SCLib.Load(last[1][1]);;
## gap> c:=c+d; #form RP^3#(S^2~S^1)
## ]]></Example>
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
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> c:=SCLib.Load(last[1][1])*SCBdSimplex(3); #form RP^2 x S^2
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=Union(SCBdSimplex(3),SCBdSimplex(3)+3); #a wedge of two 2-spheres
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;        
## gap> d:=SCBdSimplex(3);;        
## gap> d:=SCMove(d,[[1,2,3],[]]);;
## gap> d:=d+1;;                   
## gap> s1.Facets;                 
## [ [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## ]]></Example>
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
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2");
## [ [ 18, "K^2 (VT)" ], [ 221, "K^2 (VT)" ] ]
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
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=SC(SCFacets(SCBdCyclicPolytope(10,12)));
## gap> c.F; time;                                 
## gap> c.F; time;                                 
## gap> c:=SCPropertiesDropped(c);                 
## gap> c.F; time;                                 
## ]]></Example>
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
