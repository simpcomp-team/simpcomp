###############################################################################
##
##  simpcomp / glprops.gi
##
##  Compute Global Properties of Simplicial Complexes.  
##
##  $Id$
##
################################################################################

################################################################################
##<#GAPDoc Label="SCSpanningTree">
## <ManSection>
## <Meth Name="SCSpanningTree" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a spanning tree of a connected simplicial complex <Arg>complex</Arg> using a greedy algorithm.
## <Example><![CDATA[
## gap> c:=SC([["a","b","c"],["a","b","d"], ["a","c","d"], ["b","c","d"]]);;
## gap> s:=SCSpanningTree(c);
## gap> s.Facets;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSpanningTree,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  dim,skel,st,seen,e,n,vertices;


	dim:=SCDim(complex);
	if(dim=fail) then
		return fail;
	fi;
	
	if(dim<1) then
		st:=SCEmpty();
			return st;
	fi;
	
	if(SCIsConnected(complex)<>true) then
		Info(InfoSimpcomp,1,"SCSpanningTree: complex must be connected. You can calculate the spanning trees of the connected components separately (SCConnectedComponents).");
		return fail;
	fi;
	
	skel:=List([0..2],x->SCSkelEx(complex,x));

	if(skel=fail or fail in skel) then
		return fail;
	fi;

	#find spanning tree, greedy
	st:=[];
	seen:=[skel[1][1][1]];
	n:=Length(skel[1]);
	
	while(Length(seen)<n) do
		for e in skel[2] do
			# bug fix by Jack Schmidt, thanks!
			if Number(e,v->v in seen) <> 1 then continue; fi;
			Add(st,e);
			UniteSet( seen, e );
		od;
	od;
	
	st:=SCFromFacets(Set(st));
	
	if(st=fail) then
		return fail;
	fi;
	
	vertices:=SCVertices(complex);
	if vertices = fail then
		return fail;
	fi;
	SetSCVertices(st,SCIntFunc.DeepCopy(vertices));
	
	if(SCName(complex)<>fail) then
		SCRename(st,Concatenation("spanning tree of ",SCName(complex)));
	fi;
	
	return st;
end);

################################################################################
##<#GAPDoc Label="SCFundamentalGroup">
## <ManSection>
## <Meth Name="SCFundamentalGroup" Arg="complex"/>
## <Returns>a &GAP; fp group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the first fundamental group of <Arg>complex</Arg>, which must be a connected simplicial complex, and returns it in form of a finitely presented group. The generators of the group are given as 2-tuples that correspond to the edges of <Arg>complex</Arg> in standard labeling. You can use GAP's <C>SimplifiedFpGroup</C> to simplify the group presenation.
## <Example><![CDATA[
## # an RP^2
## gap> list:=SCLib.SearchByName("RP^2");
## gap> c:=SCLib.Load(list[1][1]);
## gap> g:=SCFundamentalGroup(c);;
## gap> StructureDescription(g);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFundamentalGroup,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  dim,skel,st,gens,egens,gensstr,gprime,g,e,edges,eg,t,rels,p;


	if(SCIsConnected(complex)<>true) then
		Info(InfoSimpcomp,1,"SCFundamentalGroup: complex must be connected.");
	fi;
	
	dim:=SCDim(complex);
	
	if(dim=fail) then
		return fail;
	fi;
	
	if(dim<1) then
		eg:=FreeGroup([]);
			return eg;
	fi;
	
	skel:=List([0..2],x->SCSkelEx(complex,x));
	st:=SCSpanningTree(complex);
	
	if(skel=fail or fail in skel or st=fail) then
		return fail;
	fi;
	
	st:=SCFacetsEx(st);
	
	egens:=Difference(skel[2],st);
	
	if(egens=[]) then
		eg:=FreeGroup([]);
			return eg;
	fi;
	
	#make free group
	gensstr:=List(egens,x->Concatenation("[",String(x[1]),",",String(x[2]),"]"));
	gprime:=FreeGroup(gensstr);
	gens:=GeneratorsOfGroup(gprime);
	
	#make relations
	rels:=[];
	for t in skel[3] do
		edges:=Combinations(t,2);
		if edges[1] in st then
			if edges[2] in st then
				if not edges[3] in st then
				 Add(rels,gens[Position(egens,edges[3])]);
			  fi;
		   elif edges[3] in st then
			  Add(rels,gens[Position(egens,edges[2])]);
		   else
			  Add(rels,gens[Position(egens,edges[3])]/gens[Position(egens,edges[2])]);
		   fi;
		elif edges[2] in st then
		   if edges[3] in st then
			  Add(rels,gens[Position(egens,edges[1])]);
		   else
			  Add(rels,gens[Position(egens,edges[1])]*gens[Position(egens,edges[3])]);
		   fi;
		elif edges[3] in st then
		   Add(rels,gens[Position(egens,edges[1])]/gens[Position(egens,edges[2])]);
		else
		   Add(rels,gens[Position(egens,edges[1])]*gens[Position(egens,edges[3])]/gens[Position(egens,edges[2])]);
		fi;
	od;
	
	#factor out relations
	g:=gprime/rels;
	return g;
end);

SCIntFunc.inverseReduceFaceLattice:=function(faces)

	local i,idx,todel;
	
	for i in Reversed([2..Size(faces)]) do
		todel:=[];
		if faces[i-1] = [] then break; fi;
		
		for idx in [1..Length(faces[i])] do
			if ForAny(faces[i-1],x->IsSubset(faces[i][idx],x)) then
				Add(todel,idx);
			fi;
		od;
		SubtractSet(faces[i],faces[i]{todel});
	od;

	return faces;
	
end;

SCIntFunc.MissingFacesComplex:=
function(complex,dofacets)
	
	local nextFace,lattice,missing,dim,i,n,curface,face,range;
	
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
	lattice:=SCFaceLatticeEx(complex);
	
	if(dim=fail or lattice=fail) then
		return fail;
	fi;
	
	if(dim<=1 and not dofacets) then
		if(dim<1) then
			return [];
		else
			return [[]];
		fi;
	fi;
	
	n:=Length(lattice[1]);
	missing:=[[]];
	
	range:=[2..dim];
	
	if(dofacets) then
		Add(range,dim+1);
	fi;
	
	for i in range do
		missing[i]:=[];
		curface:=[1..i];
		
		
		for face in lattice[i] do
			
			while(curface<>[] and face<>curface) do
				Add(missing[i],ShallowCopy(curface));
				curface:=nextFace(curface,n);
			od;
			
			if(curface=[]) then
				break;
			fi;
			
			curface:=nextFace(curface,n);
		od;
	
		while(curface<>[]) do
			Add(missing[i],ShallowCopy(curface));
			curface:=nextFace(curface,n);
		od;
	od;
	
	if(not dofacets) then
		missing:=SCIntFunc.inverseReduceFaceLattice(missing);
	fi;

	return missing;
end;

################################################################################
##<#GAPDoc Label="SCMinimalNonFaces">
## <ManSection>
## <Meth Name="SCMinimalNonFaces" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all missing proper faces of a simplicial complex <Arg>complex</Arg> by calling <Ref Meth="SCMinimalNonFacesEx"/>. The simplices are returned in the original labeling of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SCFromFacets(["abc","abd"]);;
## gap> SCMinimalNonFaces(c);           
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCMinimalNonFaces,
"for DuplicateFreeList and DenseList",
[IsDuplicateFreeList and IsDenseList],
function(complex)

		#fallback to homology package
		if(IsBound(SCIntFunc.SCMinimalNonFacesOld)) then
			return SCIntFunc.SCMinimalNonFacesOld(complex);
		else
			return SCMinimalNonFaces(SC(complex));
		fi;
end);

InstallMethod(SCMinimalNonFaces,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local missing, labels,min;

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCMinimalNonFaces: complex lacks vertex labels.");
		return fail; 
	fi;

	missing:=SCMinimalNonFacesEx(complex);
	if(missing=fail) then
		return fail;
	fi;

	min:=List(missing,f->SCIntFunc.RelabelSimplexList(f,labels));
	return min;
end);

################################################################################
##<#GAPDoc Label="SCMinimalNonFacesEx">
## <ManSection>
## <Meth Name="SCMinimalNonFacesEx" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all missing proper faces of a simplicial complex <Arg>complex</Arg>, i.e. the missing <M>(i+1)</M>-tuples in the <M>i</M>-dimensional skeleton of a <Arg>complex</Arg>. A missing <M>i+1</M>-tuple is not listed if it only consists of missing <M>i</M>-tuples. Note that whenever <Arg>complex</Arg> is <M>k</M>-neighborly the first <M>k+1</M> entries are empty. The simplices are returned in the standard labeling <M>1,\dots,n</M>, where <M>n</M> is the number of vertices of <Arg>complex</Arg>. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..10]}; 
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> SCFVector(torus);
## gap> SCMinimalNonFacesEx(torus);
## gap> SCMinimalNonFacesEx(SCBdCrossPolytope(4));
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCMinimalNonFacesEx,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	return SCIntFunc.MissingFacesComplex(complex,false);
end);
################################################################################
##<#GAPDoc Label="SCIsEmpty">
## <ManSection>
## <Meth Name="SCIsEmpty" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is the empty complex, i. e. a <C>SCSimplicialComplex</C> object with empty facet list.
## <Example><![CDATA[
## gap> c:=SC([[1]]);;
## gap> SCIsEmpty(c);
## gap> c:=SC([]);;
## gap> SCIsEmpty(c);
## gap> c:=SC([[]]);;
## gap> SCIsEmpty(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsEmpty,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
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
##<#GAPDoc Label="SCFacetsEx">
## <ManSection>
## <Meth Name="SCFacetsEx" Arg="complex"/>
## <Returns> a facet list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the facets of a simplicial complex as they are stored, i. e. with standard vertex labeling from 1 to n.
## <Example><![CDATA[
## gap> c:=SC([[2,3],[3,4],[4,2]]);;
## gap> SCFacetsEx(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFacetsEx,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)
	local  facets;

	if not HasSCFacetsEx(complex) then
		Info(InfoSimpcomp,1,"SCFacetsEx: complex has no or invalid facets.");
		return fail;
	fi;
end);

################################################################################
##<#GAPDoc Label="SCFacets">
## <ManSection>
## <Meth Name="SCFacets" Arg="complex"/>
## <Returns> a facet list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the facets of a simplicial complex in the original vertex labeling.
## <Example><![CDATA[
## gap> c:=SC([[2,3],[3,4],[4,2]]);;
## gap> SCFacets(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFacets,
"for SCPolyhedralComplex and IsEmpty",
[SCIsPolyhedralComplex and IsEmpty],
function(complex)
	return [];
end);

InstallMethod(SCFacets,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)

	local facets,vertices;
	
	facets:=SCFacetsEx(complex);
	if facets=[] then
		SetFilterObj(complex,IsEmpty);
		return [];
	else
		vertices:=SCVertices(complex);
		if vertices = fail then
			return fail;
		fi;
		facets:=SCIntFunc.RelabelSimplexList(facets,vertices);
		return facets;
	fi;
end);

################################################################################
##<#GAPDoc Label="SCFaces">
## <ManSection>
## <Meth Name="SCFaces" Arg="complex,k"/>
## <Returns> a face list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This is a synonym of the function <Ref Meth="SCSkel" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################

################################################################################
##<#GAPDoc Label="SCFacesEx">
## <ManSection>
## <Meth Name="SCFacesEx" Arg="complex,k"/>
## <Returns> a face list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This is a synonym of the function <Ref Meth="SCSkelEx" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################

################################################################################
##<#GAPDoc Label="SCDim">
## <ManSection>
## <Meth Name="SCDim" Arg="complex"/>
## <Returns> an integer <M>\geq -1</M> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dimension of a simplicial complex. If the complex is not pure, the dimension of the highest dimensional simplex is returned.
## <Example><![CDATA[
## gap> complex:=SC([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCDim(complex);                                    
## gap> c:=SC([[1], [2,4], [3,4], [5,6,7,8]]);;
## gap> SCDim(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDim,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return -1;
end);

InstallMethod(SCDim,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  dim, facets;


	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;
	if(facets=[]) then
		SetFilterObj(complex,IsEmpty);
		dim:=-1;
	else
		dim:=MaximumList(List(facets,x -> Size(x)))-1;
	fi;
	return dim;
end);

################################################################################
##<#GAPDoc Label="SCOrientation">
## <ManSection>
## <Meth Name="SCOrientation" Arg="complex"/>
## <Returns> a list of the type <M>\{ \pm 1 \}^{f_d}</M> or <C>[ ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function tries to compute an orientation of a pure simplicial complex <Arg>complex</Arg> that fulfills the weak pseudomanifold property. If <Arg>complex</Arg> is orientable, an orientation in form of a list of orientations for the facets of <Arg>complex</Arg> is returned, otherwise an empty set.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCOrientation(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCOrientation,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
		Info(InfoSimpcomp,1,"SCOrientation: complex is empty.");
		SetSCIsOrientable(complex,true);
		return [];
end);

InstallMethod(SCOrientation,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  iso,facets,sfaces,orient,sorient,sorientn,orientSFaces,cur,p, failed,proc,l,old,i,o,check,conncomps,sc,allorient,labels,dim,f;

	
	orientSFaces:=function(f,fo,sfaces)
	
		local bd,s,p,arr;
		
		bd:=SCBoundarySimplex(f,true);
		
		arr:=ListWithIdenticalEntries(Length(sfaces),0);

		for s in bd do
			p:=Position(sfaces,s[2]);
			arr[p]:=fo*s[1];
		od;

		return arr;
	end;
		
	dim :=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	
	if dim = 0 then
		f:=SCFVector(complex);
		if f = fail then
			return fail;
		fi;
		orient:=ListWithIdenticalEntries(f[1],1);
		SetSCIsOrientable(complex,true);
		return orient;
	fi;
	
	if(not SCIsPure(complex) or not SCIsPseudoManifold(complex)) then
		SetSCIsOrientable(complex,false);
			return [];
	fi;

	labels:=SCLabels(complex);
	if labels = fail then
		return fail;
	fi;
		
	conncomps:=SCConnectedComponents(complex);
	if conncomps = fail then
		return fail;
	fi;
	
	allorient:=[];
	for sc in conncomps do
	
		if(SCIsEmpty(sc)) then
			continue;
		fi;
		
		facets:=SCFacets(sc);
		sfaces:=SCFaces(sc,SCDim(sc)-1);
		if facets=fail or sfaces=fail then
			return fail;
		fi;
		
		#try to orient
		orient:=ListWithIdenticalEntries(Length(facets),0);
		orient[1]:=1;
		old:=1;
		l:=Length(facets[1]);

		proc:=SCNeighbors(complex,facets[1]);
		failed:=false;
		while(not failed and Size(proc)>0) do
			cur:=Remove(proc,1);
			
			if(orient[Position(facets,cur)]<>0) then
				continue;
			fi;
			
			for o in [-1,1] do 
				sorientn:=orientSFaces(cur,o,sfaces);
				
				failed:=false;
				for i in [1..Length(orient)] do
					if(orient[i]=0 or Length(Intersection(cur,facets[i]))<l-1) then continue; fi;
					
					sorient:=orientSFaces(facets[i],orient[i],sfaces);
				
					check:=sorient+sorientn;
				
					if(2 in check or -2 in check) then
						failed:=true;
						break;
					fi;
				od;
	
				if(not failed) then
					p:=Position(facets,cur);
					orient[p]:=o;
						
					Append(proc,SCNeighbors(complex,cur));
					break;
				fi;
			od;
			
			if(not 0 in orient) then
				break;
			fi;
		od;
		
		if(failed) then
			allorient:=[];
			break;
		else
			Append(allorient,orient);
		fi;
		
	od; # for sc in conncomps
	
	SetSCIsOrientable(complex,allorient<>[]);
	return allorient;
end);



################################################################################
##<#GAPDoc Label="SCIsPure">
## <ManSection>
## <Meth Name="SCIsPure" Arg="complex"/>
## <Returns> a boolean upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is pure.
## <Example><![CDATA[
## gap> c:=SC([[1,2], [1,4], [2,4], [2,3,4]]);;
## gap> SCIsPure(c);
## gap> c:=SC([[1,2], [1,4], [2,4]]);;
## gap> SCIsPure(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsPure,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
		return true;
end);

InstallMethod(SCIsPure,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  s,len,ispure,facets;

	
	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;
	if(facets=[]) then
		SetFilterObj(complex,IsEmpty);
			return true;
	fi;
	ispure:=true;
	len:=Length(facets[1]);
	for s in facets do
		if(Length(s)<>len) then ispure:=false; fi;
		if(len<Length(s)) then len:=Length(s); fi;
	od;
	SetSCDim(complex,len-1);
	return ispure;
end);


################################################################################
##<#GAPDoc Label="SCIsKNeighborly">
## <ManSection>
## <Meth Name="SCIsKNeighborly" Arg="complex,k"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");   
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCFVector(rp2_6);
## gap> SCIsKNeighborly(rp2_6,2);
## gap> SCIsKNeighborly(rp2_6,3);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsKNeighborlyOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)

	local f;
	
	
	f:=SCFVector(complex);
	if f=fail then
		return fail;
	fi;
	
	if(k<1 or k>Length(f)) then
			return false;
	else
			return f[k]=Binomial(f[1],k);
	fi;
end);




################################################################################
##<#GAPDoc Label="SCIsFlag">
## <ManSection>
## <Meth Name="SCIsFlag" Arg="complex,k"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if <Arg>complex</Arg> is flag. A connected simplicial complex of dimension at least one is a flag complex if all cliques in its 1-skeleton span a face of the complex (cf. <Cite Key="Frohmader08FaceVecFlagCompl" />). 
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");   
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCIsFlag(rp2_6);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsFlag,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
  local dim,isconn,i,lowskel,skel,face,vFace,comb;
	
  dim:=SCDim(complex);
  isconn:=SCIsConnected(complex);
  if dim = fail or isconn = fail then
    return fail;
  fi;
  
  if dim < 1 then
    Info(InfoSimpcomp,1,"SCIsFlag: complex must be at least 1-dimensional.");
    return fail;
  fi;

  if not isconn then
    Info(InfoSimpcomp,1,"SCIsFlag: complex must be connected.");
    return fail;
  fi;  

  # check for every dimension 
  #
  #           1 <= i <= DIM(complex) + 1 
  #
  # if there exist a clique in the one-skeleton of the complex
  # which in not a face of the complex
  for i in [2..dim+1] do
    lowskel:=SCSkelEx(complex,i-1);
    if i > dim then
      skel := [];
    else
      skel := SCSkelEx(complex,i);
    fi;
    for comb in Combinations(lowskel,i+1) do
      vFace:=Union(comb);
      if Size(vFace) = i+1 and not vFace in skel then
        Info(InfoSimpcomp,2,"SCIsFlag: found missing clique ",vFace,": complex is not flag.");
        return false;
      fi;
    od;
  od;

  return true;    
end);

	
################################################################################
##<#GAPDoc Label="SCFVector">
## <ManSection>
## <Meth Name="SCFVector" Arg="complex"/>
## <Returns> a list of non-negative integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the simplicial complex <Arg>complex</Arg>, i. e. the number of <M>i</M>-dimensional faces for <M> 0 \leq i \leq d </M>, where <M>d</M> is the dimension of <Arg>complex</Arg>. A memory-saving implicit algorithm is used that avoids calculating the face lattice of the complex. Internally calls <Ref Meth="SCNumFaces"/>.
## <Example><![CDATA[
## gap> complex:=SC([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCFVector(complex);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFVector,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return [0];
end);

InstallMethod(SCFVector,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local i, f, dim;
	
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	
	f:=[];
	for i in Reversed([0..dim]) do
		f[i+1]:=SCNumFaces(complex,i);
	od;
	if fail in f then
		return fail;
	fi;

	return f;
end);

###############################################################################
##<#GAPDoc Label="SCNumFaces">
## <ManSection>
## <Meth Name="SCNumFaces" Arg="complex [, i]"/>
## <Returns> an integer or a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <Arg>i</Arg> is not specified the function computes the <M>f</M>-vector of the simplicial complex <Arg>complex</Arg> (cf. <Ref Meth="SCFVector"/>). If the optional integer parameter <Arg>i</Arg> is passed, only the <Arg>i</Arg>-th position of the <M>f</M>-vector of <Arg>complex</Arg> is calculated. In any case a memory-saving implicit algorithm is used that avoids calculating the face lattice of the complex. 
## <Example><![CDATA[
## gap> complex:=SC([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCNumFaces(complex,1);
## 4
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCNumFacesOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex, pos)
	local f,nextFace,dim,n,face,index,k,c,cf,facets,fl,maxexpected;
	
#	nextFace:=function(face,n)
#	
#		local l,i,dim;
#		
#		l:=Length(face);
#		dim:=l-1;
#		face[l]:=face[l]+1;
#		
#		while(face[l]>n-(dim+1-l) and l>1) do
#			l:=l-1;
#			face[l]:=face[l]+1;
#			for i in [l+1..dim+1] do
#				face[i]:=face[i-1]+1;
#			od;
#		od;
#		
#		if(l=1 and face[1]>n-dim) then
#			return [];
#		fi;
#		
#		return face;
#	end;
#
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	
	if pos < 0 or pos>dim+1 then
			return 0;
	fi;
	
	fl:=SCFacesEx(complex,pos);

	return Size(fl);
	
#	facets:=SCFacetsEx(complex);
#	n:=Length(SCVertices(complex));
#
#	if(pos=0) then
#	 	return n;
#	fi;
#
#	
#
#	# only true for (bounded) manifolds
#	#if(dim=n-1 and dim > 0) then
#	#	#simplex
#	#	f:=Concatenation(SCFVectorBdSimplex(dim),[1]);
#	#		return f[pos+1];
#	#elif(dim=n-2 and n=Length(facets) and dim > 0) then
#	#	#bd simplex
#	#	f:=SCFVectorBdSimplex(dim+1);
#	#		return f[pos+1];
#	#fi;
#	
#	
#
#	maxexpected:=Sum(List([1..dim],x->x*Binomial(n,x)));
#	if (pos in ComputedSCSkelExs(complex) and Position(ComputedSCSkelExs(complex),pos) mod 2 = 1) or maxexpected<2*10^8 then
#		fl:=SCSkelEx(complex,pos);
#		if(fl=fail) then
#			return fail;
#		fi;
#			return Length(fl);
#	fi;
#	
#	face:=[1..pos+1];
#	c:=0;
#	repeat
#		for cf in facets do
#			if(IsSubset(cf,face)) then
#				c:=c+1;
#				break;
#			elif(face[pos]<cf[1]) then
#				#MaximumList(face))<MinimumList(cf)
#				break;
#			fi;
#		od;
#		face:=nextFace(face,n);
#	until face=[];
#	
#	return c;
end);

################################################################################
##<#GAPDoc Label="SCHVector">
## <ManSection>
## <Meth Name="SCHVector" Arg="complex"/>
## <Returns> a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>h</M>-vector of a simplicial complex. The <M>h</M>-vector is defined as <Math> h_{k}:= \sum \limits_{i=-1}^{k-1} (-1)^{k-i-1}{d-i-1 \choose k-i-1} f_i</Math> for <M>0 \leq k \leq d</M>, where <M>f_{-1} := 1</M>. For all simplicial complexes we have <M>h_0 = 1</M>, hence the returned list starts with the second entry of the <M>h</M>-vector.
##
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCFVector(rp2_6);
## gap> SCHVector(rp2_6);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHVector,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  k, i, h, f, dim;

	
	f:=SCFVector(complex);
	if f=fail then
		return fail;
	fi;
	dim:=SCDim(complex);
	if dim=fail then
		return fail;
	fi;
	h:=[];
	for k in [1..dim+1] do
		h[k]:=(-1)^k*Binomial(dim+1,k);
		for i in [1..dim+1] do
			h[k]:=h[k]+(-1)^(k-i)*Binomial(dim+1-i,dim+1-k)*f[i];
		od;
	od;

	return h;

end);


################################################################################
##<#GAPDoc Label="SCGVector">
## <ManSection>
## <Meth Name="SCGVector" Arg="complex"/>
## <Returns> a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the g-vector of a simplicial complex. The <M>g</M>-vector is defined as follows:<P/>
## 
## Let <M>h</M> be the <M>h</M>-vector of a <M>d</M>-dimensional simplicial complex C, then <Math>g_i:=h_{i+1} - h_{i} ; \quad \frac{d}{2} 
## \geq i \geq 0 </Math> is called the <M>g</M>-vector of <M>C</M>. For the definition of the <M>h</M>-vector see <Ref Meth="SCHVector" />. The information contained in <M>g</M> suffices to determine the <M>f</M>-vector of <M>C</M>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");
## gap> rp2_6:=SCLib.Load(last[1][1]);;
## gap> SCFVector(rp2_6);
## gap> SCHVector(rp2_6);
## gap> SCGVector(rp2_6);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCGVector,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  k, i, h, g, dim;


	h:=SCHVector(complex);
	if h=fail then
		return fail;
	fi;
	dim:=SCDim(complex);
	if dim=fail then
		return fail;
	fi;
	g:=[];

	if QuoInt(dim+1,2)>=1 then
		g[1]:=h[1]-1;
	fi;
	for k in [2..QuoInt(dim+2,2)] do
		g[k]:=h[k]-h[k-1];
	od;

	return g;

end);



################################################################################
##<#GAPDoc Label="SCEulerCharacteristic">
## <ManSection>
## <Meth Name="SCEulerCharacteristic" Arg="complex"/>
## <Returns> integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Euler characteristic <Math> \chi(C)=\sum \limits_{i=0}^{d} (-1)^{i} f_i </Math> of a simplicial complex <M>C</M>, where <M>f_i</M> denotes the <M>i</M>-th component of the <M>f</M>-vector.
## <Example><![CDATA[
## gap> complex:=SCFromFacets([[1,2,3], [1,2,4], [1,3,4], [2,3,4]]);;
## gap> SCEulerCharacteristic(complex);
## gap> s2:=SCBdSimplex(3);;
## gap> s2.EulerCharacteristic;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCEulerCharacteristic,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  f, chi, i;


	f:=SCFVector(complex);
	if f=fail then
		return fail;
	fi;
	chi:=0;

	for i in [1..Size(f)] do
			chi:=chi + ((-1)^(i+1))*f[i];
	od;

	return chi;
end);


################################################################################
##<#GAPDoc Label="SCIsPseudoManifold">
## <ManSection>
## <Meth Name="SCIsPseudoManifold" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> fulfills the weak pseudomanifold property, i. e. if every <M>d-1</M>-face of <Arg>complex</Arg> is contained in at most <M>2</M> facets.
## <Example><![CDATA[
## # Two 2-spheres glued together at [1]
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4],[2,3,4],[1,5,6],[1,5,7],[1,6,7],[5,6,7]]);;
## gap> SCIsPseudoManifold(c);
## # Two circles glued together a 1
## gap> c:=SC([[1,2],[2,3],[3,1],[1,4],[4,5],[5,1]]);;
## gap> SCIsPseudoManifold(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsPseudoManifold,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return false;
end);

InstallMethod(SCIsPseudoManifold,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  i, j, dfaces, dim, incidence, facets, boundary, sc, name, labels, pos, idx, base, ispure;

		
	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCIsPseudoManifold: complex lacks vertex labels.");
		return fail;
	fi;

	ispure:=SCIsPure(complex);
	if ispure = fail then
		return fail;
	fi;

	if ispure = false then
		Info(InfoSimpcomp,3,"SCIsPseudoManifold: complex not pure.");
		return false;
	fi;
	
	dim:=SCDim(complex);
	facets:=SCFacetsEx(complex);
	dfaces:=SCSkelEx(complex,dim-1);
	if dim=fail or facets=fail or dfaces=fail then
		return fail;
	fi;
	incidence:=ListWithIdenticalEntries(Size(dfaces),0);
	
	if dim = 0 then
		SetSCBoundaryEx(complex,SCEmpty());
		SetSCHasBoundary(complex,false);
		return Size(facets) = 2;
	fi;

	idx:=[];	
	for i in [1..dim+1] do
		idx[i]:=[1..dim+1];
		Remove(idx[i],i);
	od;
	for i in [1..Size(facets)] do
		for j in [1..dim+1] do
			base:=facets[i]{idx[j]};
			pos:=PositionSorted(dfaces,base);
			incidence[pos]:=incidence[pos]+1;
			if incidence[pos] > 2 then 
				return false;
			fi;
		od;
	od;

	boundary:=[];
	for i in [1..Size(dfaces)] do
		if incidence[i]=1 then
			Add(boundary,dfaces[i]);
		fi;
	od;

	if(boundary=[]) then
		SetSCHasBoundary(complex,false);
		sc:=SCEmpty();
	else
		SetSCHasBoundary(complex,true);
		sc:=SCFromFacets(boundary);
	fi;

	name:=SCName(complex);
	if(name<>fail) then
		SCRename(sc,Concatenation(["Bd(",name,")"]));
	fi;

	SetSCBoundaryEx(complex,sc);
	return true;
end);


################################################################################
##<#GAPDoc Label="SCIsConnected">
## <ManSection>
## <Meth Name="SCIsConnected" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is connected.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(1);;
## gap> SCIsConnected(c);
## gap> c:=SCBdSimplex(2);;
## gap> SCIsConnected(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsConnected,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
		return false;
end);

InstallMethod(SCIsConnected,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
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
##<#GAPDoc Label="SCIsStronglyConnected">
## <ManSection>
## <Meth Name="SCIsStronglyConnected" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is strongly connected, i. e. if for any pair of facets <M>(\hat{\Delta},\tilde{\Delta})</M> there exists a sequence of facets <M>( \Delta_1 , \ldots , \Delta_k )</M> with <M>\Delta_1 = \hat{\Delta}</M> and <M>\Delta_k = \tilde{\Delta}</M> and dim<M>(\Delta_i , \Delta_{i+1} ) = d - 1</M> for all <M>1 \leq i \leq k - 1</M>.  
## <Example><![CDATA[
## # Two 2-spheres, glued along [1]
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4],[2,3,4], [1,5,6],[1,5,7],[1,6,7],[5,6,7]]);
## gap> SCIsConnected(c);        
## gap> SCIsStronglyConnected(c);                                                
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsStronglyConnected,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return false;
end);

InstallMethod(SCIsStronglyConnected,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  ispure,seen,curfacet,stack,neighbors,n,getFacetNeighborsIdx,sc,facets,f;


	
	
	getFacetNeighborsIdx:=function(complex,sidx)
	
		local side,sides,t,neighbors,s;

		s:=complex[sidx];

		sides:=Combinations(s,Length(s)-1);
		neighbors:=[];

		for t in complex do
			if(t=s) then continue; fi;
			for side in sides do
				if(IsSubset(t,side)) then
					AddSet(neighbors,Position(complex,t));
				fi;
			od;
		od;

		return neighbors;
	end;

	ispure:=SCIsPure(complex);
	if ispure = fail then
		return fail;
	fi;

	if not ispure then
		Info(InfoSimpcomp,1,"SCIsStronglyConnected: argument must be a pure simplicial complex.");
		return fail;
	fi;

	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;
	
	f:=SCFVector(complex);
	if f = fail then
		return fail;
	fi;
	
	if f = [0] then
		SetFilterObj(complex,IsEmpty);
			return false;
	fi;
	
	if Size(f) < 2 and f[1] <> 1 then
			return false;
	elif Size(f) < 2 and f[1] = 1 then
			return true;
	fi;
	
	seen:=ListWithIdenticalEntries(Length(facets),0);
	curfacet:=1;
	seen[1]:=1;
	stack:=[];

	while(curfacet<>0) do
		neighbors:=getFacetNeighborsIdx(facets,curfacet);
		for n in neighbors do
			if(seen[n]=0) then
				seen[n]:=1;
				UniteSet(stack,Filtered(getFacetNeighborsIdx(facets,n),x->seen[x]=0));
			fi;
		od;
		if(stack<>[]) then
			curfacet:=stack[1];
			RemoveSet(stack,stack[1]);
			seen[curfacet]:=1;
		else
			curfacet:=0;
		fi;
	od;
	sc:=not 0 in seen;
	return sc;
end);


################################################################################
##<#GAPDoc Label="SCAltshulerSteinberg">
## <ManSection>
## <Meth Name="SCAltshulerSteinberg" Arg="complex"/>
## <Returns> a non-negative integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Altshuler-Steinberg determinant.<P/>
## Definition: Let <M>v_i</M>, <M>1 \leq i \leq n</M> be the vertices and let  <M>F_j</M>, <M>1 \leq j \leq m</M> be the facets of a pure simplicial complex <M>C</M>, then the determinant of <M>AS \in \mathbb{Z}^{n \times m}</M>, <M>AS_{ij}=1</M> if <M>v_i \in F_j</M>, <M>AS_{ij}=0</M> otherwise, is called the Altshuler-Steinberg matrix. The Altshuler-Steinberg determinant is the determinant of the quadratic matrix <M>AS \cdot AS^T</M>.<P/>
## The Altshuler-Steinberg determinant is a combinatorial invariant of <M>C</M> and can be checked before searching for an isomorphism between two simplicial complexes. 
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("T^2");; 
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> SCAltshulerSteinberg(torus);
## gap> c:=SCBdSimplex(3);;
## gap> SCAltshulerSteinberg(c);
## gap> c:=SCBdSimplex(4);;
## gap> SCAltshulerSteinberg(c);
## gap> c:=SCBdSimplex(5);;
## gap> SCAltshulerSteinberg(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAltshulerSteinberg,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return 0;
end);

InstallMethod(SCAltshulerSteinberg,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  faces, i, matrix, det, j;

	
	faces:=[];
	faces[1]:=SCSkelEx(complex,0);
	faces[2]:=SCFacetsEx(complex);
	
	if fail in faces then
		return fail;
	fi;

	matrix:=[];
	for i in [1..Length(faces[1])] do
		matrix[i]:=[];
		for j in [1..Length(faces[2])] do
			if faces[1][i][1] in faces[2][j] then
				matrix[i][j]:=1;
			else
				matrix[i][j]:=0;
			fi;
		od;
	od;

	det:=DeterminantMat(matrix*TransposedMat(matrix));
	return det;
end);

################################################################################
##<#GAPDoc Label="SCHomologyClassic">
## <ManSection>
## <Func Name="SCHomologyClassic" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ integer, list ]</C>.</Returns>
## <Description>
## Computes the integral simplicial homology groups of a simplicial complex <Arg>complex</Arg> 
## (internally calls the function <C>SimplicialHomology(complex.FacetsEx)</C> from the 
## <Package>homology</Package> package, see <Cite Key="Dumas04Homology" />).<P/>
##
## If the <Package>homology</Package> package is not available, this function call 
## falls back to <Ref Func="SCHomologyInternal" />.
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, where 
## <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the homology groups 
## <M>H_i</M> is given in terms of their maximal cyclic subgroups, i.e. a homology group 
## <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> 
## is returned in form of a list <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> is the (integer) 
## free part of <M>H_i</M> and <M>t_i</M> denotes the torsion parts of <M>H_i</M> ordered in 
## weakly increasing size.<P/>
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2");
## gap> kleinBottle:=SCLib.Load(last[1][1]);;
## gap> kleinBottle.Homology;          
## gap> SCLib.SearchByName("L_"){[1..10]};
## gap> c:=SCConnectedSum(SCLib.Load(last[9][1]),
##                        SCConnectedProduct(SCLib.Load(last[10][1]),2));
## gap> SCHomology(c);
## gap> SCFpBettiNumbers(c,2);
## gap> SCFpBettiNumbers(c,3);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################

# for the source code see the files lib/pkghom.gi and lib/pkgnohom.gi

################################################################################
##<#GAPDoc Label="SCFpBettiNumbers">
## <ManSection>
## <Meth Name="SCFpBettiNumbers" Arg="complex,p"/>
## <Returns> a list of non-negative integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the Betti numbers of a simplicial complex with respect to the field <M>\mathbb{F}_p</M> for any prime number <C>p</C>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2");    
## gap> kleinBottle:=SCLib.Load(last[1][1]);; 
## gap> SCHomology(kleinBottle);      
## gap> SCFpBettiNumbers(kleinBottle,2);
## gap> SCFpBettiNumbers(kleinBottle,3);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFpBettiNumbersOp,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty,IsInt],
function(complex,p)
	if not IsPrime(p) then
		Info(InfoSimpcomp,1,"SCFpBettiNumbersOp: second argument must be a prime.");
		return fail;
	fi;
	
	return [];
end);

InstallMethod(SCFpBettiNumbersOp,
"for SCSimplicialComplex and Prime",
[SCIsSimplicialComplex,IsInt],
function(complex,p)

	local i, j, pbetti, hom, facets, all;
	
	
	if not IsPrime(p) then
		Info(InfoSimpcomp,1,"SCFpBettiNumbersOp: second argument must be a prime.");
		return fail;
	fi;
	
	hom:=SCHomology(complex);
	pbetti:=[];
	pbetti[1]:=hom[1][1]+1;
	for i in [2..Size(hom)] do
		# free part
		pbetti[i]:=hom[i][1];
		# torsion
		for j in [1..Size(hom[i][2])] do
			if IsInt(hom[i][2][j]/p) then
				pbetti[i]:=pbetti[i] + 1;
			fi;
		od;
		# tor-functor
		for j in [1..Size(hom[i-1][2])] do
			if IsInt(hom[i-1][2][j]/p) then
				pbetti[i]:=pbetti[i] + 1;
			fi;
		od;
	od;

	return pbetti;
end);



################################################################################
##<#GAPDoc Label="SCDualGraph">
## <ManSection>
## <Meth Name="SCDualGraph" Arg="complex"/>
## <Returns>1-dimensional simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dual graph of the pure simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> sphere:=SCBdSimplex(5);;
## gap> graph:=SCFaces(sphere,1);       
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 4 ], 
##   [ 2, 5 ], [ 2, 6 ], [ 3, 4 ], [ 3, 5 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], 
##   [ 5, 6 ] ]
## gap> graph:=SC(graph);;              
## gap> dualGraph:=SCDualGraph(sphere); 
## gap> graph.Facets = dualGraph.Facets;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDualGraph,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  i, dg, dim, ispure, sc, name, newname, edge, facets, faces;


	dim := SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	
	if dim < 1 then
		Info(InfoSimpcomp,1,"SCDualGraph: complex dimension is smaller than 1.");
		return fail;
	fi;

	ispure := SCIsPure(complex);
	if ispure = fail then
		return fail;
	fi;

	if not ispure then
		Info(InfoSimpcomp,1,"SCDualGraph: complex must be pure.");
		return fail;
	fi;


	facets:=SCFacetsEx(complex);
	if facets = fail then
		return fail;
	fi;
	faces:=SCFacesEx(complex,dim-1);
	if faces = fail then
		return fail;
	fi;
	
	dg:=[];
	for i in [1..Size(faces)] do
		edge:=Filtered(facets,x->IsSubset(x,faces[i]));
		if Size(edge) > 2 then
			Info(InfoSimpcomp,1,"SCDualGraph: complex must be a pseudomanifold.");
			return fail;
		elif Size(edge) = 1 then 
			continue;
		elif Size(edge) = 2 then
			edge:=[Position(facets,edge[1]),Position(facets,edge[2])];
			if fail in edge then
				Info(InfoSimpcomp,1,"SCDualGraph: invalid facet list.");
				return fail;
			fi;
			Add(dg,edge);
		else
			Info(InfoSimpcomp,1,"SCDualGraph: invalid facet list.");
			return fail;
		fi;
	od;
	
	sc:=SCFromFacets(dg);
	name:=SCName(complex);
	if name = fail then
		SCRename(sc,"dual graph of unnamed complex");
	else
		newname:=Concatenation(["dual graph of ",name]);
		SCRename(sc,newname);
	fi;
	return sc;
end);

################################################################################
##<#GAPDoc Label="SCAutomorphismGroup">
## <ManSection>
## <Meth Name="SCAutomorphismGroup" Arg="complex"/>
## <Returns>a &GAP; permutation group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, i. e. the group of all automorphisms on the set of vertices of <Arg>complex</Arg> that do not change the complex as a whole. Necessarily the group is a subgroup of the symmetric group <M>S_n</M> where <M>n</M> is the number of vertices of the simplicial complex.<P/>
## The function uses an efficient algorithm provided by the package <Package>GRAPE</Package> (see <Cite Key="Soicher06GRAPE"/>, which is based on the program <C>nauty</C> by Brendan McKay <Cite Key="McKay84Nauty"/>).
## If the package <Package>GRAPE</Package> is not available, this function call falls back to <Ref Meth="SCAutomorphismGroupInternal"/>.<P/>
## The position of the group in the &GAP; libraries of small groups, transitive groups or primitive groups is given. If the group is not listed, its structure description, provided by the &GAP; function <C>StructureDescription()</C>, is returned as the name of the group. Note that the latter form is not always unique, since every non trivial semi-direct product is denoted by ''<C>:</C>''.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");            
## gap> k3surf:=SCLib.Load(last[1][1]);; 
## gap> SCAutomorphismGroup(k3surf);               
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################

# for code see lib/pkggrape.gi and lib/pkgnogrape.gi




################################################################################
##<#GAPDoc Label="SCAutomorphismGroupSize">
## <ManSection>
## <Meth Name="SCAutomorphismGroupSize" Arg="complex"/>
## <Returns>a positive integer group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the size of the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, see <Ref Meth="SCAutomorphismGroup"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");            
## gap> k3surf:=SCLib.Load(last[1][1]);;           
## gap> SCAutomorphismGroupSize(k3surf);               
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAutomorphismGroupSize,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local g;
	g:=SCAutomorphismGroup(complex);
	if(g=fail) then
		return fail;
	fi;
	
	return Size(g);
end);

################################################################################
##<#GAPDoc Label="SCAutomorphismGroupStructure">
## <ManSection>
## <Meth Name="SCAutomorphismGroupStructure" Arg="complex"/>
## <Returns>the &GAP; structure description upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the &GAP; structure description of the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, see <Ref Meth="SCAutomorphismGroup"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");     
## gap> k3surf:=SCLib.Load(last[1][1]);;      
## gap> SCAutomorphismGroupStructure(k3surf);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAutomorphismGroupStructure,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local g;
	g:=SCAutomorphismGroup(complex);
	if(g=fail) then
		return fail;
	fi;
	
	return StructureDescription(g);
end);

################################################################################
##<#GAPDoc Label="SCAutomorphismGroupTransitivity">
## <ManSection>
## <Meth Name="SCAutomorphismGroupTransitivity" Arg="complex"/>
## <Returns>a positive integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the transitivity of the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, i. e. the maximal integer <M>t</M> such that for any two ordered <M>t</M>-tuples <M>T_1</M> and <M>T_2</M> of vertices of <Arg>complex</Arg>, there exists an element <M>g</M> in the automorphism group of <Arg>complex</Arg> for which <M>gT_1=T_2</M>, see <Cite Key="Huppert67EndlGruppen" />. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");            
## gap> k3surf:=SCLib.Load(last[1][1]);;           
## gap> SCAutomorphismGroupTransitivity(k3surf);               
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAutomorphismGroupTransitivity,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local g;
	g:=SCAutomorphismGroup(complex);
	if(g=fail) then
		return fail;
	fi;
	
	return Transitivity(g);
end);


SCIntFunc.GapGroupIndex:=function(g)

	local t,deg,order,i,G;
	
	if not IsPermGroup(g) then
		Info(InfoSimpcomp,1,"SCGapGroupIndex: argument is not a permutation group.");
		return fail;
	fi;

	t:=Transitivity(g);
	deg:=DegreeOperation(g);
	order:=Size(g);
	
	# t = 0
	if t = 0 then
		if NrSmallGroups(order) = fail then
			return false;
		fi;
		for i in [1..NrSmallGroups(order)] do
			G:=SmallGroup(order,i);
			if IsomorphismGroups(G,g) <> fail then
				return ["SmallGroup",order,i];
			fi;
		od;
		return false;
	fi;
	
	# t > 0
	if not IsPrimitive(g) then
		if NrTransitiveGroups(deg) <> fail then
			for i in [1..NrTransitiveGroups(deg)] do
				G:=TransitiveGroup(deg,i);
				if Size(G) > order then
					break;
				elif Size(G) < order then
					continue;
				fi;
				if IsomorphismGroups(G,g) <> fail then
					return ["TransitiveGroup",deg,i];
				fi;
			od;
		fi;
	else
		if NrPrimitiveGroups(deg) <> fail then
			for i in [1..NrPrimitiveGroups(deg)] do
				G:=PrimitiveGroup(deg,i);
				if Size(G) > order then
					break;
				elif Size(G) < order then
					continue;
				fi;
				if Transitivity(G) <> t then
					continue;
				fi;
				if IsomorphismGroups(G,g) <> fail then
					return ["PrimitiveGroup",deg,i];
				fi;
			od;
		fi;
	fi;
	Info(InfoSimpcomp,1,"group not listed");
	return false;
end;


SCIntFunc.SCComputeIsomorphismsEx:=function(complexA,complexB,isomorphism)
	
	local dim, AFaces, BFaces, element, i, j, k, matrix, AStar, BStar, BVertex, H, stop, st, s, u, v, ACopy, BCopy, AMatched, BMatched, AUnmatched, pairs, pair, ALinkElement, BLinkElement, ACoFaces, ACoElement, BCoElement, IntersectionACoFaces, mismatch, AVertexNew, BVertexNew, APerm, perm, allisos;



	dim:=SCDim(complexA);
	AFaces:=SCIntFunc.DeepCopy(SCFaceLatticeEx(complexA));
	BFaces:=SCIntFunc.DeepCopy(SCFaceLatticeEx(complexB));

	if(dim=fail or SCDim(complexB)<>dim or AFaces=fail or BFaces=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCComputeIsomorphismsEx: complex dimensions do not match or computing dimension or face lattice failed."); 
		return fail;
	fi;


	allisos:=[];

	AStar:=[];
	for element in AFaces[dim+1] do
		if AFaces[1][Length(AFaces[1])][1] in element then
			AddSet(AStar,element);
		fi;
	od;

	H:=SymmetricGroup(dim);

	for BVertex in BFaces[1] do
		BStar:=[];
		for element in BFaces[dim+1] do
			if BVertex[1] in element then
				AddSet(BStar,element);
			fi;
		od;

		if Length(AStar)<>Length(BStar) then
			continue;
		fi;

		stop:=false;
		st:=0;

		while st<Length(BStar) and not stop do
			st:=st+1;
			s:=0;

			while s<Factorial(dim) and not stop do
				s:=s+1;

				ACopy:=[];
				BCopy:=[];
				UniteSet(ACopy,AFaces[dim+1]);
				UniteSet(BCopy,BFaces[dim+1]);
				RemoveSet(ACopy,AStar[1]);
				RemoveSet(BCopy,BStar[st]);

				AMatched:=[];
				BMatched:=[];
				UniteSet(AMatched,AStar[1]);
				UniteSet(BMatched,BStar[st]);
				AUnmatched:=[];
				for element in AFaces[1] do
					UniteSet(AUnmatched,element);
				od;
				SubtractSet(AUnmatched,AStar[1]);

				pairs:=[];
				ALinkElement:=[];
				BLinkElement:=[];
				UniteSet(ALinkElement,AStar[1]);
				UniteSet(BLinkElement,BStar[st]);
				RemoveSet(ALinkElement,AFaces[1][Length(AFaces[1])][1]);
				RemoveSet(BLinkElement,BVertex[1]);
				AddSet(pairs,[AFaces[1][Length(AFaces[1])][1],BVertex[1]]);

				for k in [1..(dim)] do
					AddSet(pairs,[ALinkElement[k],BLinkElement[k^Elements(H)[s]]]);
				od;

				ACoFaces:=[];
				UniteSet(ACoFaces,Combinations(AStar[1],dim));

				mismatch:=false;

				while Length(AUnmatched)>0  and mismatch=false and not stop do
					ACoElement:=[];
					UniteSet(ACoElement,ACoFaces[1]);

					u:=0;
					while u<Length(ACopy) do
						u:=u+1;

						if not IsSubset(ACopy[u],ACoElement) then
							continue;
						fi;

						BCoElement:=[];
						for pair in pairs do
							if pair[1] in ACoElement then
								AddSet(BCoElement,pair[2]);
							fi;
						od;

						AVertexNew:=[];
						UniteSet(AVertexNew,ACopy[u]);
						SubtractSet(AVertexNew,ACoElement);

						if AVertexNew[1] in AUnmatched then
							v:=0;
							while v<Length(BCopy) do
								v:=v+1;

								if not IsSubset(BCopy[v],BCoElement) then
									continue;
								fi;

								BVertexNew:=[];
								UniteSet(BVertexNew,BCopy[v]);
								SubtractSet(BVertexNew,BCoElement);

								if BVertexNew[1] in BMatched then
									v:=Length(BCopy);
									u:=Length(ACopy);
									mismatch:=true;
								else
									AddSet(pairs,[AVertexNew[1],BVertexNew[1]]);
									AddSet(AMatched,AVertexNew[1]);
									AddSet(BMatched,BVertexNew[1]);
									RemoveSet(AUnmatched,AVertexNew[1]);
									UniteSet(ACoFaces,Combinations(ACopy[u],dim));
									RemoveSet(ACoFaces,ACoElement);
									RemoveSet(ACopy,ACopy[u]);
									RemoveSet(BCopy,BCopy[v]);
									v:=Length(BCopy);
									u:=Length(ACopy);
								fi;
							od;
						else
							for pair in pairs do
								if pair[1]=AVertexNew[1] then
									BVertexNew:=[pair[2]];
								fi;
							od;

							AddSet(BCoElement,BVertexNew[1]);

							if BCoElement in BCopy then
								IntersectionACoFaces:=[];
								UniteSet(IntersectionACoFaces,ACoFaces);
								IntersectSet(IntersectionACoFaces,Combinations(ACopy[u],dim));
								UniteSet(ACoFaces,Combinations(ACopy[u],dim));
								SubtractSet(ACoFaces,IntersectionACoFaces);
								RemoveSet(ACopy,ACopy[u]);
								RemoveSet(BCopy,BCoElement);
								u:=Length(ACopy);
							else
								u:=Length(ACopy);
								mismatch:=true;
							fi;
						fi;
					od;
				od;

				if AUnmatched<>[] then
					continue;
				fi;

				APerm:=[];
				for element in AFaces[dim+1] do
					perm:=[];

					for k in element do
						for pair in pairs do
							if k=pair[1] then
								AddSet(perm,pair[2]);
							fi;
						od;
					od;
					AddSet(APerm,perm);
				od;

				if APerm=BFaces[dim+1] then
					AddSet(allisos,List(pairs,x->ShallowCopy(x)));
					if(isomorphism) then
						stop:=true;
					fi;
				fi;
			od;
		od;

		if stop then
			break;
		fi;
	od;

	return allisos;
end;



SCIntFunc.PairToList:=
function(pairs)

	local p,l;

	l:=[];
	for p in pairs do
		l[p[1]]:=p[2];
	od;

	return l;
end;

################################################################################
##<#GAPDoc Label="SCAutomorphismGroupInternal">
## <ManSection>
## <Meth Name="SCAutomorphismGroupInternal" Arg="complex"/>
## <Returns>a &GAP; permutation group upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the automorphism group of a strongly connected pseudomanifold <Arg>complex</Arg>, i. e. the group of all automorphisms on the set of vertices of <Arg>complex</Arg> that do not change the complex as a whole. Necessarily the group is a subgroup of the symmetric group <M>S_n</M> where <M>n</M> is the number of vertices of the simplicial complex.<P/>
## The position of the group in the &GAP; libraries of small groups, transitive groups or primitive groups is given. If the group is not listed, its structure description, provided by the &GAP; function <C>StructureDescription()</C>, is returned as the name of the group. Note that the latter form is not always unique, since every non trivial semi-direct product is denoted by ''<C>:</C>''.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCAutomorphismGroupInternal(c);
## S6
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[1,3]]);;
## gap> g:=SCAutomorphismGroupInternal(c);
## PrimitiveGroup(3,2) = S(3)
## gap> List(g);
## [ (), (1,2,3), (1,3,2), (2,3), (1,2), (1,3) ]
## gap> StructureDescription(g);
## "S3"
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAutomorphismGroupInternal,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local G,start,sc,isos,structure,pm,bd,gapidx,g;
	
		
	pm:=SCIsPseudoManifold(complex);
	if(pm=fail) then
		return fail;
	elif(pm=false) then
		Info(InfoSimpcomp,1,"SCAutomorphismGroupInternal: can only compute automorphism group for pseudomanifolds.");
		return fail;
	fi;

	sc:=SCIsStronglyConnected(complex);
	if(sc=fail) then
		return fail;
	elif(sc=false) then
		Info(InfoSimpcomp,1,"SCAutomorphismGroupInternal: can only compute automorphism group for strongly connected complexes.");
		return fail;
	fi;

	bd:=SCHasBoundary(complex);
	if(bd=fail) then
		return fail;
	elif(bd=true) then
		Info(InfoSimpcomp,1,"SCAutomorphismGroupInternal: can only compute automorphism group for closed complexes.");
		return fail;
	fi;

	if(HasSCAutomorphismGroup(complex)) then
		G:=SCAutomorphismGroup(complex);
		if G<>fail and IsGroup(G) then
			return G;
		fi;
	fi;

	if SCMailIsEnabled() then
		start:=SCIntFunc.GetCurrentTimeInt();
	fi;
				
	isos:=SCIntFunc.SCComputeIsomorphismsEx(complex,complex,false);

	if(isos=fail) then
		if SCMailIsEnabled() then
			SCMailSend(Concatenation(["Failed computing the automorphism group of the simplicial complex\n\n",String(complex),".\n\nI'm sorry"]));
		fi;
		Info(InfoSimpcomp,1,"SCAutomorphismGroupInternal: failed to compute automorphism group.");
		return fail;
	fi;
	
        if List(List(isos,SCIntFunc.PairToList),PermList) = [] then
          G:=Group(());
        else
	  G:=Group(SmallGeneratingSet(Group(List(List(isos,SCIntFunc.PairToList),PermList))));
        fi;

	SetSCAutomorphismGroup(complex,G);
	SetSCAutomorphismGroupSize(complex,Size(G));
	SetSCAutomorphismGroupTransitivity(complex,Transitivity(G));
	if Size(G) = 1 then
		structure:="1";
	else
		gapidx:=SCIntFunc.GapGroupIndex(G);
		if gapidx = fail or gapidx = false then
			structure:=StructureDescription(G);
		else
			if gapidx[1] = "SmallGroup" then
				g:=SmallGroup(gapidx[2],gapidx[3]);
				if HasName(g) then
					structure:=Concatenation(gapidx[1],"(",String(gapidx[2]),",",String(gapidx[3]),") = ",Name(g));
				else
					structure:=StructureDescription(G);
				fi;
			elif gapidx[1] = "TransitiveGroup" then
				g:=TransitiveGroup(gapidx[2],gapidx[3]);
				if HasName(g) then
					structure:=Concatenation(gapidx[1],"(",String(gapidx[2]),",",String(gapidx[3]),") = ",Name(g));
				else
					structure:=StructureDescription(G);
				fi;
			elif gapidx[1] = "PrimitiveGroup" then
				g:=PrimitiveGroup(gapidx[2],gapidx[3]);
				if HasName(g) then
					structure:=Concatenation(gapidx[1],"(",String(gapidx[2]),",",String(gapidx[3]),") = ",Name(g));
				else
					structure:=StructureDescription(G);
				fi;
			else
				structure:=StructureDescription(G);
			fi;
		fi;
	fi;
	SetSCAutomorphismGroupStructure(complex,structure);
	#SetName(G,structure);
		
	if SCMailIsEnabled() then
		SCMailSend(Concatenation(["Computed the automorphism group of the simplicial complex\n\n",String(complex),".\n\nElements of automorphism group [Element, Order]:\n",SCIntFunc.ArrayLineString(List(Elements(G),x->[x,Order(x)])),"\n"]),start);
	fi;

	return G;
end);

################################################################################
##<#GAPDoc Label="SCGeneratorsEx">
## <ManSection>
## <Meth Name="SCGeneratorsEx" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ list, integer ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the generators of a simplicial complex in the standard vertex labeling.<P/>
## The generating set of a simplicial complex is a list of simplices that will generate the complex by uniting their <M>G</M>-orbits if <M>G</M> is the automorphism group of <Arg>complex</Arg>.<P/>
## The function returns the simplices together with the length of their orbits.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("T^2");;
## gap> torus:=SCLib.Load(list[1][1]);;
## gap> SCGeneratorsEx(torus); 
## [ [ [ 1, 2, 4 ], 14 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> SCLib.Load(last[1][1]);
## gap> SCGeneratorsEx(last);
## [ [ [ 1, 2, 3, 8, 12 ], 240 ], [ [ 1, 2, 5, 8, 14 ], 48 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCGeneratorsEx,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  gen,f,g,orbits,o,gens;

	
	f:=SCFacetsEx(complex);
	g:=SCAutomorphismGroup(complex);
	
	if f=fail or g=fail then
		return fail;
	fi;

	orbits:=OrbitsDomain(g,f,OnSets);

	gens:=[];
	for o in orbits do
		AddSet(gens,[Representative(o),Length(o)]);
	od;

	return gens;
end);


################################################################################
##<#GAPDoc Label="SCGenerators">
## <ManSection>
## <Meth Name="SCGenerators" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ list, integer ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the generators of a simplicial complex in the original vertex labeling.<P/>
## The generating set of a simplicial complex is a list of simplices that  will generate the complex by uniting their <M>G</M>-orbits if <M>G</M> is the automorphism group of <Arg>complex</Arg>.<P/>
## The function returns the simplices together with the length of their orbits.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("T^2");;
## gap> torus:=SCLib.Load(list[1][1]);;
## gap> SCGenerators(torus); 
## [ [ [ 1, 2, 4 ], 14 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> SCLib.Load(last[1][1]);
## gap> SCGenerators(last);
## [ [ [ 1, 2, 3, 8, 12 ], 240 ], [ [ 1, 2, 5, 8, 14 ], 48 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCGenerators,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local gens, vertices;
	
	gens:=SCGeneratorsEx(complex);
	
	if(gens=fail) then
		return fail;
	else
		vertices:=SCVertices(complex);
		if vertices = fail then
			return fail;
		fi;
		gens:=List(gens,x->[SCIntFunc.RelabelSimplexList([x[1]],vertices)[1],x[2]]);
		return gens;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCDifferenceCycles">
## <ManSection>
## <Meth Name="SCDifferenceCycles" Arg="complex"/>
## <Returns> a list of lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the difference cycles of <Arg>complex</Arg> in standard labeling
## if <Arg>complex</Arg> is invariant under a shift of the vertices of type
## <M>v \mapsto v+1 \mod n</M>.
##
## The function returns the difference cycles as lists where the sum of the entries
## equals the number of vertices <M>n</M> of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> torus:=SCFromDifferenceCycles([[1,2,4],[1,4,2]]);
## gap> torus.Homology;
## gap> torus.DifferenceCycles;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDifferenceCycles,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  facets,tmp,n,i,j,dc;

	facets:=SCFacetsEx(complex);
	n:=SCNumFaces(complex,0);
	if facets=fail or n=fail then
		return fail;
	fi;

	tmp:=SCIntFunc.DeepCopy(facets)+1;
	for i in [1..Size(tmp)] do
		for j in [1..Size(tmp[i])] do
			if tmp[i][j]=n+1 then
				tmp[i][j]:=1;
			fi;
		od;
		Sort(tmp[i]);
	od;
	Sort(tmp);

	if facets <> tmp then
		Info(InfoSimpcomp,1,"SCDifferenceCycles: argument has no cyclic symmetry (v |-> v+1) in standard labeling.");
		return fail;		
	fi;

	dc:=[];
	for i in [1..Size(facets)] do
		AddSet(dc,SCDifferenceCycleCompress(facets[i],n));
	od;

	if not fail in dc and Set(List(dc,x->Sum(x))) = [n] then
		return dc;
	else
		Info(InfoSimpcomp,1,"SCDifferenceCycles: found invalid difference cycle.");
		return fail;	
	fi;	
end);



################################################################################
##<#GAPDoc Label="SCIsCentrallySymmetric">
## <ManSection>
## <Meth Name="SCIsCentrallySymmetric" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> is centrally symmetric, i. e. if its automorphism group contains a fixed point free involution.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCIsCentrallySymmetric(c);
## true
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> SCIsCentrallySymmetric(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsCentrallySymmetric,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  cs,G,FL,e,i;

		
	G:=SCAutomorphismGroup(complex);
	FL:=SCFaceLatticeEx(complex);
	if G=fail or FL=fail then
		return fail;
	fi;

	cs:=false;
	for e in G do
		if(Order(e)<>2) then continue; fi;
		cs:=true;
		for i in [1..Length(FL)] do
			if(not ForAll(OrbitsDomain(Group(e),FL[i],OnSets),x->Length(x)=2)) then
				cs:=false;
				break;
			fi;
		od;

		if(cs=true) then
			SetSCCentrallySymmetricElement(complex,e);
			break;
		fi;
	od;

	return cs;
end);




################################################################################
##<#GAPDoc Label="SCCentrallySymmetricElement">
## <ManSection>
## <Meth Name="SCCentrallySymmetricElement" Arg="complex"/>
## <Returns>an automorphism of <Arg>complex</Arg> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the centrally symmetric element of the automorphism group of  <Arg>complex</Arg> if the simplicial complex <Arg>complex</Arg> is centrally symmetric.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCCentrallySymmetricElement(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCentrallySymmetricElement,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  cs,G,FL,e,i;

	
	if(not SCIsCentrallySymmetric(complex)) then
		return fail;
	fi;
	
	G:=SCAutomorphismGroup(complex);
	FL:=SCFaceLatticeEx(complex);
	if G=fail or FL=fail then
		return fail;
	fi;

	cs:=false;
	for e in G do
		if(Order(e)<>2) then continue; fi;
		cs:=true;
		for i in [1..Length(FL)] do
			if(not ForAll(OrbitsDomain(Group(e),FL[i],OnSets),x->Length(x)=2)) then
				cs:=false;
				break;
			fi;
		od;

		if(cs=true) then
			return e;
		fi;
	od;

	return fail;
end);


################################################################################
##<#GAPDoc Label="SCNeighborliness">
## <ManSection>
## <Meth Name="SCNeighborliness" Arg="complex"/>
## <Returns> a positive integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <M>k</M> if a simplicial complex <Arg>complex</Arg> is <M>k</M>-neighborly but not  <M>(k+1)</M>-neighborly. See also <Ref Meth="SCIsKNeighborly" />.<P/>
## Note that every complex is at least <M>1</M>-neighborly.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> SCNeighborliness(c);
## 4
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCNeighborliness(c);
## 1
## gap> SCLib.SearchByAttribute("F[3]=Binomial(F[1],3) and Dim=4");
## [ [ 16, "CP^2 (VT)" ], [ 520, "K3_16" ] ]
## gap> cp2:=SCLib.Load(last[1][1]);;
## gap> SCNeighborliness(cp2);
## 3
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCNeighborliness,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return 0;
end);

InstallMethod(SCNeighborliness,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  f,kn,i;


	f:=SCFVector(complex);
	if f=fail then
		return fail;
	fi;

	kn:=1;
	while(kn<=Length(f) and f[kn]=Binomial(f[1],kn)) do
		kn:=kn+1;
	od;
	
	return kn-1;
end);


################################################################################
##<#GAPDoc Label="SCIsShellable">
## <ManSection>
## <Meth Name="SCIsShellable" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary (cf. <Ref Meth="SCBoundary"/>).<P/>
## The function checks whether <Arg>complex</Arg> is shellable or not. An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is called a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>. A simplicial complex is called shellable, if at least one shelling exists.<P/>
## See <Cite Key="Ziegler95LectPolytopes" />, <Cite Key="Pachner87KonstrMethKombHomeo" /> to learn more about shellings.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;       
## gap> c:=Difference(c,SC([[1,3,5,7]]));; # bounded version
## gap> SCIsShellable(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsShellable,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  shable,facets,sc,s;

		
	s:=SCShellingExt(complex,false,[]);
	if(s=fail) then
		return fail;
	fi;

	if(s<>[]) then
		shable:=true;
		SetSCShelling(complex,s[1]);
	else
		shable:=false;
	fi;

	return shable;
end);



################################################################################
##<#GAPDoc Label="SCIsOrientable">
## <ManSection>
## <Meth Name="SCIsOrientable" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg>, satisfying the weak pseudomanifold property, is orientable.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCIsOrientable(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsOrientable,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return true;
end);

InstallMethod(SCIsOrientable,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  oable,o,isPM;

	
	isPM:=SCIsPseudoManifold(complex);
	if isPM = fail then
		return fail;
	fi;
	if(not isPM) then
		Info(InfoSimpcomp,1,"SCIsOrientable: first argument must fulfill the weak pseudomanifold property.");
		return fail;
	fi;
	
	o:=SCOrientation(complex);
	if(o=fail) then
		return fail;
	fi;

	return o<>[];
end);





################################################################################
##<#GAPDoc Label="SCBoundary">
## <ManSection>
## <Meth Name="SCBoundary" Arg="complex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The function computes the boundary of a simplicial complex <Arg>complex</Arg> satisfying the weak pseudomanifold property and returns it as a simplicial complex. In addition, it is stored as a property of <Arg>complex</Arg>.<P/>
## The boundary of a simplicial complex is defined as the simplicial complex consisting of all <M>d-1</M>-faces that are contained in exactly one facet. <P/>
## If <Arg>complex</Arg> does not fulfill the weak pseudomanifold property (i. e. if the valence of any <M>d-1</M>-face exceeds <M>2</M>) the function returns <K>fail</K>.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);
## gap> SCBoundary(c);
## gap> c;  
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCBoundary,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local bd,vertices,idx,bdVerts;
	
	bd:=SCCopy(SCBoundaryEx(complex));
	vertices:=SCVertices(complex);
	idx:=SCVertices(bd);
	if bd = fail or vertices = fail or idx = fail then
		return fail;
	fi;
	bdVerts:=vertices{idx};
	SCRelabel(bd,bdVerts);
	
	return bd;
end);

InstallMethod(SCBoundaryEx,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return SCEmpty();
end);

InstallMethod(SCBoundaryEx,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  dim, labels, ispm;


	labels:=SCVertices(complex);
	if(labels=fail) then
		return fail;
	fi;
		
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	if dim = 0 then
		SetSCHasBoundary(complex,false);
		return SCEmpty();
	fi;
	
	ispm:=SCIsPseudoManifold(complex);
	if ispm = fail then
		return fail;
	fi;

	return SCBoundaryEx(complex);
end);


################################################################################
##<#GAPDoc Label="SCHasBoundary">
## <ManSection>
## <Meth Name="SCHasBoundary" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> that fulfills the weak pseudo manifold property has a boundary, i. e. <M>d-1</M>-faces of valence <M>1</M>. If <Arg>complex</Arg> is closed <K>false</K> is returned, if <Arg>complex</Arg> does not fulfill the weak pseudomanifold property, <K>fail</K> is returned, otherwise <K>true</K> is returned.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K^2"); 
## [ [ 18, "K^2 (VT)" ], [ 221, "K^2 (VT)" ] ]
## gap> kleinBottle:=SCLib.Load(last[1][1]);;
## gap> SCHasBoundary(kleinBottle);
## false
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);;
## gap> SCHasBoundary(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHasBoundary,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return false;
end);

InstallMethod(SCHasBoundary,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  bd,isPM;


	isPM:=SCIsPseudoManifold(complex);
	if isPM = fail then
		return fail;
	fi;
	if(not isPM) then
		Info(InfoSimpcomp,1,"SCHasBoundary: first argument must fulfill the weak pseudomanifold property.");
		return fail;
	fi;

	bd:=SCBoundaryEx(complex);
	if(bd=fail) then
		return fail;
	fi;
	
	return not SCIsEmpty(bd);
end);


################################################################################
##<#GAPDoc Label="SCInterior">
## <ManSection>
## <Meth Name="SCInterior" Arg="complex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all <M>d-1</M>-faces of valence <M>2</M> of a simplicial complex <Arg>complex</Arg> that fulfills the weak pseudomanifold property, i. e. the function returns the part of the <M>d-1</M>-skeleton of <M>C</M> that is not part of the boundary. 
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);;
## gap> SCInterior(c).Facets;
## [[1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 3, 4], [1, 3, 5],
##   [1, 4, 5]]
## gap> c:=SC([[1,2,3,4]]);;
## gap> SCInterior(c).Facets;
## []
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCInterior,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  dim, I, i, incidence, facets, faces, elements, int, intc, sc, labels, empty, name;


	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	if dim < 1 then
		empty:=SCEmpty();
		SetSCHasInterior(complex,"HasInterior",false);
		Info(InfoSimpcomp,1,"SCInterior: complex is empty or 0-dimensional.");
			return empty;
	fi;
	
	labels:=SCVertices(complex);
	if(labels=fail) then
		return fail;
	fi;
	
	facets:=SCFacetsEx(complex);
	faces:=SCSkelEx(complex,dim-1);
	if facets=fail or faces=fail then
		return fail;
	fi;

	incidence:=ListWithIdenticalEntries(Size(faces), 0);
	for elements in facets do
		for i in [1..Size(faces)] do
			if IsSubset(elements,faces[i]) then
				incidence[i]:=incidence[i] + 1;
				if incidence[i]>2 then
					Info(InfoSimpcomp,1,"SCInterior: wrong incidence (",incidence[i],") -- complex is not a pseudomanifold.");
					return fail;
				fi;
			fi;
		od;
	od;
	I:=[];
	for i in [1..Size(incidence)] do
		if incidence[i]=2 then
			Add(I,faces[i]);
		fi;
	od;

	if I=[] then
		SetSCHasInterior(complex,false);
		sc:=SCEmpty();
	else
		SetSCHasInterior(complex,true);
		sc:=SCFromFacets(SCIntFunc.RelabelSimplexList(I,labels));
		name:=SCName(complex);
		if(name<>fail) then
			SCRename(sc,Concatenation(["Int(",name,")"]));
		fi;
	fi;
	return sc;
end);


################################################################################
##<#GAPDoc Label="SCHasInterior">
## <ManSection>
## <Meth Name="SCHasInterior" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> if a simplicial complex <Arg>complex</Arg> that fulfills the weak pseudomanifold property has at least one <M>d-1</M>-face of valence <M>2</M>, i. e. if there exist at least one <M>d-1</M>-face that is not in the boundary of <Arg>complex</Arg>, if no such face can be found <K>false</K> is returned. It <Arg>complex</Arg> does not fulfill the weak pseudomanifold property <K>fail</K> is returned.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3,4],[1,2,3,5],[1,2,4,5],[1,3,4,5]]);;
## gap> SCHasInterior(c)
## true
## gap> c:=SC([[1,2,3,4]]);;
## gap> SCHasInterior(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCInterior,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return false;
end);

InstallMethod(SCHasInterior,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  int,hi,isPM;

	
	isPM:=SCIsPseudoManifold(complex);
	if isPM = fail then
		return fail;
	fi;
	if(not isPM) then
		Info(InfoSimpcomp,1,"SCHasInterior: first argument must fulfill the weak pseudomanifold property.");
		return fail;
	fi;

	int:=SCInterior(complex);

	if(int=fail) then
		return fail;
	fi;
	
	hi:=SCIsEmpty(int);
	if hi = fail then
		return fail;
	fi;
	return not hi;
end);

################################################################################
##<#GAPDoc Label="SCIsEulerianManifold">
## <ManSection>
## <Meth Name="SCIsEulerianManifold" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether a given simplicial complex <Arg>complex</Arg> is a Eulerian manifold or not, i. e. checks if all vertex links of <Arg>complex</Arg> have the Euler characteristic of a sphere. In particular the function returns <K>false</K> in case <Arg>complex</Arg> has a non-empty boundary.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> SCIsEulerianManifold(c);
## true
## gap> SCLib.SearchByName("Moebius");
## gap> moebius:=SCLib.Load(last[1][1]); # a moebius strip
## gap> SCIsEulerianManifold(moebius);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsEulerianManifold,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	return false;
end);

InstallMethod(SCIsEulerianManifold,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  euler,dim,chi,links,lk,tmp,f;


	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	
	if dim = 0 then
		f:=SCFVector(complex);
		if f = fail then
			return fail;
		fi;
		SetSCIsEulerianManifold(complex,f[1] = 2);
			return f[1] = 2;
	fi;
	
	chi:= (dim mod 2)*2;

	links:=SCLinks(complex,0);
	if links = fail then
		Info(InfoSimpcomp,1,"SCIsEulerianManifold: an error occurred while computing links of complex.");
		return fail;
	fi;
	
	for lk in links do
		tmp:=SCEulerCharacteristic(lk);
		if tmp = fail then
			Info(InfoSimpcomp,1,"SCIsEulerianManifold: link is not valid.");
			return fail;
		fi;
		if tmp <> chi then
					return false;
		fi;
	od;
	
	return true;
end);


################################################################################
##<#GAPDoc Label="SCSkelEx">
## <ManSection>
## <Meth Name="SCSkelEx" Arg="complex,k"/>
## <Returns> a face list or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <Arg>k</Arg> is an integer, the <Arg>k</Arg>-skeleton of a simplicial complex <Arg>complex</Arg>, i. e. all <Arg>k</Arg>-faces of <Arg>complex</Arg>, is computed. If <Arg>k</Arg> is a list, a list of all <Arg>k</Arg><C>[i]</C>-faces of <Arg>complex</Arg> for each entry <Arg>k</Arg><C>[i]</C> (which has to be an integer) is returned. The faces are returned in the standard labeling.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2"); 
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;      
## gap> rp2_6:=SC(rp2_6.Facets+10);;
## gap> SCSkelEx(rp2_6,1);
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 4 ], 
##   [ 2, 5 ], [ 2, 6 ], [ 3, 4 ], [ 3, 5 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], 
##   [ 5, 6 ] ]
## gap> SCSkel(rp2_6,1);  
## [ [ 11, 12 ], [ 11, 13 ], [ 11, 14 ], [ 11, 15 ], [ 11, 16 ], [ 12, 13 ], 
##   [ 12, 14 ], [ 12, 15 ], [ 12, 16 ], [ 13, 14 ], [ 13, 15 ], [ 13, 16 ], 
##   [ 14, 15 ], [ 14, 16 ], [ 15, 16 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSkelExOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex, k)

	local cdim,i,facets,face,idx,computed,dict,isPure;
	
	
	cdim:=SCDim(complex);

	if(cdim=fail) then
		return fail;
	fi;

	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;
	
	if(k<0 or k>cdim) then
			return [];
	fi;

	isPure:=SCIsPure(complex);
	if isPure = fail then
		return fail;
	fi;

	dict:=NewDictionary([1..k],false);
	computed:=ComputedSCSkelExs(complex);
	idx:=-1;
	for i in [k+1..cdim+1] do
		if i in computed then
			idx:=Position(computed,i)+1;
			break;
		fi;
	od;
	if idx > -1 then
		for i in computed[idx] do
			for face in Combinations(i,k+1) do
				if not KnowsDictionary(dict,face) then
					AddDictionary(dict,face);
				fi;
			od;
		od;
		# in case complex is not pure
		if not isPure then
			for face in facets do
				if Size(face) = k+1 then
					if not KnowsDictionary(dict,face) then
						AddDictionary(dict,face);
					fi;
				fi;
			od;
		fi;
	else
		for i in facets do
			for face in Combinations(i,k+1) do
				if not KnowsDictionary(dict,face) then
					AddDictionary(dict,face);
				fi;
			od;
		od;
	fi;
	return dict!.list;
end);

################################################################################
##<#GAPDoc Label="SCSkel">
## <ManSection>
## <Meth Name="SCSkel" Arg="complex,k"/>
## <Returns> a face list or a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <Arg>k</Arg> is an integer, the <Arg>k</Arg>-skeleton of a simplicial complex <Arg>complex</Arg>, i. e. all <Arg>k</Arg>-faces of <Arg>complex</Arg>, is computed. If <Arg>k</Arg> is a list, a list of all <Arg>k</Arg><C>[i]</C>-faces of <Arg>complex</Arg> for each entry <Arg>k</Arg><C>[i]</C> (which has to be an integer) is returned. The faces are returned in the original labeling.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2"); 
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2_6:=SCLib.Load(last[1][1]);;      
## gap> rp2_6:=SC(rp2_6.Facets+10);;
## gap> SCSkelEx(rp2_6,1);
## [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 1, 6 ], [ 2, 3 ], [ 2, 4 ], 
##   [ 2, 5 ], [ 2, 6 ], [ 3, 4 ], [ 3, 5 ], [ 3, 6 ], [ 4, 5 ], [ 4, 6 ], 
##   [ 5, 6 ] ]
## gap> SCSkel(rp2_6,1);  
## [ [ 11, 12 ], [ 11, 13 ], [ 11, 14 ], [ 11, 15 ], [ 11, 16 ], [ 12, 13 ], 
##   [ 12, 14 ], [ 12, 15 ], [ 12, 16 ], [ 13, 14 ], [ 13, 15 ], [ 13, 16 ], 
##   [ 14, 15 ], [ 14, 16 ], [ 15, 16 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSkel,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex, k)

	local labels,skel;

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCSkel: complex lacks vertex labels.");
		return fail; 
	fi;
	skel:=SCIntFunc.RelabelSimplexList(SCSkelEx(complex,k),labels);
	
	return skel;
end);


################################################################################
##<#GAPDoc Label="SCFaceLatticeEx">
## <ManSection>
## <Meth Name="SCFaceLatticeEx" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the entire face lattice of a <M>d</M>-dimensional simplicial complex, i. e. all of its <M>i</M>-skeletons for <M>0 \leq i \leq d</M>. The faces are returned in the standard labeling.
## <Example><![CDATA[
## gap> c:=SC([["a","b","c"],["a","b","d"], ["a","c","d"], ["b","c","d"]]);;
## gap> SCFaceLatticeEx(c);
## [ [ [1], [2], [3], [4] ],
##   [ [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4] ],
##   [ [1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFaceLatticeEx,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local faces,dim,i,f,chi,flag;
	
	dim :=SCDim(complex);
	if(dim=fail) then
		return fail;
	fi;
	faces:=[];
	for i in Reversed([0..dim]) do
		faces[i+1]:=SCSkelEx(complex,i);
	od;
	if fail in faces then
		return fail;
	fi;
	return faces;
end);



################################################################################
##<#GAPDoc Label="SCFaceLattice">
## <ManSection>
## <Meth Name="SCFaceLattice" Arg="complex"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the entire face lattice of a <M>d</M>-dimensional simplicial complex, i. e. all of its <M>i</M>-skeletons for <M>0 \leq i \leq d</M>. The faces are returned in the original labeling.
## <Example><![CDATA[
## gap> c:=SC([["a","b","c"],["a","b","d"], ["a","c","d"], ["b","c","d"]]);;
## gap> SCFaceLattice(c);
## [ [ ["a"], ["b"], ["c"], ["d"] ],
##   [ ["a", "b"], ["a", "c"], ["a", "d"], 
## 	   ["b", "c"], ["b", "d"], ["c", "d"] ],
##   [ ["a", "b", "c"], ["a", "b", "d"], 
##     ["a", "c", "d"], ["b", "c", "d"] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFaceLattice,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local labels,fl;

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCFaceLattice: complex lacks vertex labels.");
		return fail; 
	fi;
	
	fl:=List(SCFaceLatticeEx(complex),x->SCIntFunc.RelabelSimplexList(x,labels));
	return fl;
end);


################################################################################
##<#GAPDoc Label="SCIncidencesEx">
## <ManSection>
## <Meth Name="SCIncidencesEx" Arg="complex,k"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all <Arg>k</Arg>-faces of the simplicial complex <Arg>complex</Arg>. The list is sorted by the valence of the faces in the <Arg>k</Arg>+1-skeleton of the complex, i. e. the <M>i</M>-th entry of the list contains all <Arg>k</Arg>-faces of valence <M>i</M>. The faces are returned in the standard labeling.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[2,3,4],[3,4,5],[4,5,6],[1,5,6],[1,4,6],[2,3,6]]);;
## gap> SCIncidences(c,1);
## [ [ [1, 2], [1, 3], [1, 4], [1, 5], 
##     [2, 4], [2, 6], [3, 5], [3, 6] ], 
##   [ [1, 6], [3, 4], [4, 5], [4, 6], [5, 6] ],
##   [ [2, 3] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIncidencesExOp,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty,IsInt],
function(complex,k)
	if k < 0 then 
		Info(InfoSimpcomp,1,"SCIncidencesEx: second argument must be an integers >=0.");
		return fail;
	fi;
	
	return [];
end);


InstallMethod(SCIncidencesExOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)

	local B, i, j, incidence, incidences, facets, faces, elements, cdim;
	
	if k < 0 then 
		Info(InfoSimpcomp,1,"SCIncidencesEx: second argument must be an integer >=0.");
		return fail;
	fi;	
	
	cdim:=SCDim(complex);
	if cdim = fail then
		return fail;
	fi;
	
	if k >= cdim then
			return [];
	fi;
	
	B:=[];
	faces:=[];

	facets:=SCSkelEx(complex,(k+1));
	faces:=SCSkelEx(complex,k);
	if facets=fail or faces=fail then
		return fail;
	fi;
		
	incidence:=ListWithIdenticalEntries(Size(faces), 0);
	if incidence = fail or Length(incidence) = 0 then
		return fail;
	fi;
		
	for elements in facets do
		for i in [1..Size(faces)] do
			if IsSubset(elements,faces[i]) then
				 incidence[i]:=incidence[i] + 1;
			fi;
		od;
	od;
		
	for i in [1..Maximum(incidence)] do
		B[i]:=[];
		for j in [1..Size(incidence)] do
			if incidence[j]=i then
				AddSet(B[i],faces[j]);
			fi;
		od;
	od;

	
	return B;

end);


################################################################################
##<#GAPDoc Label="SCIncidences">
## <ManSection>
## <Meth Name="SCIncidences" Arg="complex,k"/>
## <Returns> a list of face lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all <Arg>k</Arg>-faces of the simplicial complex <Arg>complex</Arg>. The list is sorted by the valence of the faces in the <Arg>k</Arg>+1-skeleton of the complex, i. e. the <M>i</M>-th entry of the list contains all <Arg>k</Arg>-faces of valence <M>i</M>. The faces are returned in the original labeling.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[2,3,4],[3,4,5],[4,5,6],[1,5,6],[1,4,6],[2,3,6]]);;
## gap> SCIncidences(c,1);
## [ [ [1, 2], [1, 3], [1, 4], [1, 5], 
##     [2, 4], [2, 6], [3, 5], [3, 6] ], 
##   [ [1, 6], [3, 4], [4, 5], [4, 6], [5, 6] ],
##   [ [2, 3] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIncidences,
"for (SCSimplicialComplex and IsEmpty) and Int",
[SCIsSimplicialComplex and IsEmpty,IsInt],
function(complex,k)
	return [];
end);

InstallMethod(SCIncidences,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)

	local labels,ind;

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCIncidences: complex lacks vertex labels.");
		return fail; 
	fi;
	
	ind:=List(SCIncidencesEx(complex,k),x->SCIntFunc.RelabelSimplexList(x,labels));
	return ind;
end);



################################################################################
##<#GAPDoc Label="SCVerticesEx">
## <ManSection>
## <Meth Name="SCVerticesEx" Arg="complex"/>
## <Returns> <M>[ 1, \ldots , n ]</M> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <M>\left[1, \ldots , n \right]</M>, where <M>n</M> is the number of vertices of a simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SC([[1,4,5],[4,9,8],[12,13,14,15,16,17]]);;
## gap> SCVerticesEx(c);
## [1 .. 11]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCVerticesEx,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)

	local vertices,facets;
	
	vertices:=SCVertices(complex);
	return [1..Size(vertices)];
end);

################################################################################
##<#GAPDoc Label="SCVertices">
## <ManSection>
## <Meth Name="SCVertices" Arg="complex"/>
## <Returns> a list of vertex labels of <Arg>complex</Arg> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the vertex labels of a simplicial complex <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> sphere:=SC([["x",45,[1,1]],["x",45,["b",3]],["x",[1,1],
##   ["b",3]],[45,[1,1],["b",3]]]);;
## gap> SCVerticesEx(sphere);
## [1, 2, 3, 4]
## gap> SCVertices(sphere);
## [ 45, [ 1, 1 ], "x", [ "b", 3 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCVertices,
"for SCPolyhedralComplex",
[SCIsPolyhedralComplex],
function(complex)

	local facets;

	
	facets:=SCFacetsEx(complex);
	if facets = fail then
		return fail;
	fi;

	return Union(facets);	
end);


################################################################################
##<#GAPDoc Label="SCIsHomologySphere">
## <ManSection>
## <Meth Name="SCIsHomologySphere" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether a simplicial complex <Arg>complex</Arg> is a homology sphere, i. e. has the homology of a sphere, or not.
## <Example><![CDATA[
## gap> c:=SC([[2,3],[3,4],[4,2]]);;
## gap> SCIsHomologySphere(c);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsHomologySphere,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local  d,h;


	
		
	d:=SCDim(complex);
	h:=SCHomology(complex);
	
	if(d=fail or h=fail) then
		return fail;
	fi;
	
	
	if(d=-1) then
			return true;
	else
			return h=Concatenation(ListWithIdenticalEntries(d,[0,[]]),[[1,[]]]);
	fi;
end);




################################################################################
##<#GAPDoc Label="SCIsInKd">
## <ManSection>
## <Meth Name="SCIsInKd" Arg="complex, k"/>
## <Returns> <K>true</K> / <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether the simplicial complex <Arg>complex</Arg> that must be a combinatorial <M>d</M>-manifold is in the class <M>\mathcal{K}^k(d)</M>, <M>1\leq k\leq \lfloor\frac{d+1}{2}\rfloor</M>, of simplicial complexes that only have <M>k</M>-stacked spheres as vertex links, see <Cite Key="Effenberger09StackPolyTightTrigMnf" />. Note that it is not checked whether <Arg>complex</Arg> is a combinatorial manifold -- if not, the algorithm will not succeed.
## Returns <K>true</K> / <K>false</K> upon success. If <K>true</K> is returned this means that <Arg>complex</Arg> is at least <Arg>k</Arg>-stacked and thus that the complex is in the class <M>\mathcal{K}^k(d)</M>, i.e. all vertex links are <C>i</C>-stacked spheres. If <K>false</K> is returnd the complex cannot be <Arg>k</Arg>-stacked. In some cases the question can not be decided. In this case <K>fail</K> is returned.<P/>
## Internally calls <Ref Meth="SCIsKStackedSphere"/> for all links. Please note that this is a radomized algorithm that may give an indefinite answer to the membership problem.
## <Example><![CDATA[
## gap> list:=SCLib.SearchByName("S^2~S^1"){[1..3]};;
## gap> c:=SCLib.Load(list[1][1]);;
## gap> c.AutomorphismGroup;
## D18
## gap> SCIsInKd(c,1);
## #I  SCIsInKd: checking link 1/9
## #I  SCIsKStackedSphere: try 1/50
## round 0: [ 7, 15, 10 ]
## round 1: [ 6, 12, 8 ]
## round 2: [ 5, 9, 6 ]
## round 3: [ 4, 6, 4 ]
## Computed locally minimal complex after 4 rounds.
## #I  SCIsInKd: complex has transitive automorphism group, all links are 
## 1-stacked.
## 1
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsInKdOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)

	local dim, inkd,links,l,i,trans,result;

	
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;

	
	if(k <= 0 or k > Int((SCDim(complex)+1)/2)) then
		Info(InfoSimpcomp,1,"SCIsInKd: second argument must be a positive integer k with 1 <= k <= \\lfloor (SCDim(complex)+1)/2 \\rfloor.");
		return fail;
	fi;
	
	if(SCIsPseudoManifold(complex)<>true or SCHasBoundary(complex)<>false) then
		Info(InfoSimpcomp,2,"SCIsInKd: complex must be a pseudomanifold without boundary.");
		return fail;
	fi;
	
	if HasComputedSCIsInKds(complex) then
		l:=ComputedSCIsInKds(complex);
		for i in [1..Size(l)] do
			if not IsBound(l[i]) then
				continue;
			fi;
			if l[i] = true then
				if IsBound(l[i-1]) and l[i-1] <= k then
					Info(InfoSimpcomp,1,"SCIsInKd: complex is even (at least) in K^",l[i-1],".");
						return true;
				fi;
				break;
			fi;
		od;
	fi;
	
		
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;

	if HasSCAutomorphismGroupTransitivity(complex) then
		trans:=SCAutomorphismGroupTransitivity(complex);
	else
		trans:=fail;
	fi;
	links:=SCLinks(complex,0);
	
	if(links=fail or links=[]) then
		return fail;
	fi;
	
	if(trans<>fail and trans>=1) then
		Info(InfoSimpcomp,2,"SCIsInKd: complex has transitive automorphism group, only checking one link.");
		links:=[links[1]];
	fi;
	
	for l in [1..Length(links)] do
		Info(InfoSimpcomp,2,"SCIsInKd: checking link ",l,"/",Length(links));
		
		result:=SCIsKStackedSphere(links[l],k);
		
		if(result=fail) then
			return fail;
		elif(result[1]=false) then
			Info(InfoSimpcomp,2,"SCIsInKd: link ",l," is not ",k,"-stacked.");
					return false;
		elif(result[1]=true) then
			if(trans<>fail and trans>=1) then
				Info(InfoSimpcomp,2,"SCIsInKd: complex has transitive automorphism group, all links are ",k,"-stacked.");
				#transitive automorphism group, check only one link
							return true;
			fi;
		elif(result[1]=-1) then
			Info(InfoSimpcomp,2,"SCIsInKd: could not determine whether it is ",k,"-stacked for one vertex link.");
			return fail;
		fi;
	od;

	Info(InfoSimpcomp,2,"SCIsInKd: all links are ",k,"-stacked.");
	return true;
end);


################################################################################
##<#GAPDoc Label="SCDehnSommervilleMatrix">
## <ManSection>
## <Meth Name="SCDehnSommervilleMatrix" Arg="d"/>
## <Returns> a <C>(d+1)</C><M>\times</M><C>Int(d+1/2)</C> matrix with integer entries upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the coefficients of the Dehn Sommerville equations for dimension <C>d</C>: <M>h_j - h_{d+1-j} = (-1)^{d+1-j} { d+1 \choose j } (\chi (M) - 2)</M> for <M>0 \leq j \leq \frac{d}{2}</M> and <M>d</M> even, and <M>h_j - h_{d+1-j} = 0</M> for <M>0 \leq j \leq \frac{d-1}{2}</M> and <M>d</M> odd. Where <M>h_j</M> is the <M>j</M>th component of the <M>h</M>-vector, see <Ref Func="SCHVector"/>.
## <Example><![CDATA[
## gap> m:=SCDehnSommervilleMatrix(6);;
## gap> PrintArray(m);
## [ [    1,   -1,    1,   -1,    1,   -1,    1 ],
##   [    0,   -2,    3,   -4,    5,   -6,    7 ],
##   [    0,    0,    0,   -4,   10,  -20,   35 ],
##   [    0,    0,    0,    0,    0,   -6,   21 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDehnSommervilleMatrix,
"for Int",
[IsPosInt],
function(d)

	local matrix, numeq, i, j;
	
	if not IsPosInt(d) then
		Info(InfoSimpcomp,1,"SCDehnSommervilleMatrix: argument must be a positive integer.");
		return fail;
	fi;
	
	numeq:=Int((d+2)/2);
	matrix:=[];
	matrix[1]:=[];
	for i in [0..d] do
		matrix[1][i+1]:=(-1)^i;
	od;
	
	if numeq = 1 then
		return matrix;
	fi;
	
	if (d mod 2) = 0 then
		for j in [1..d/2] do
			matrix[j+1]:=[];
			for i in [0..d] do
				if i < (2*j-1) then
					matrix[j+1][i+1]:=0;
				else
					matrix[j+1][i+1]:=(-1)^i*Binomial(i+1,2*j-1);
				fi;
			od;
		od;
	else
		for j in [1..(d-1)/2] do
			matrix[j+1]:=[];
			for i in [0..d] do
				if i < (2*j) then
					matrix[j+1][i+1]:=0;
				else
					matrix[j+1][i+1]:=(-1)^i*Binomial(i+1,2*j);
				fi;
			od;	
		od;
	fi;
	
	return matrix;

end);
	
################################################################################
##<#GAPDoc Label="SCDehnSommervilleCheck">
## <ManSection>
## <Meth Name="SCDehnSommervilleCheck" Arg="c"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks if the simplicial complex <Arg>c</Arg> fulfills the Dehn Sommerville equations: <M>h_j - h_{d+1-j} = (-1)^{d+1-j} { d+1 \choose j } (\chi (M) - 2)</M> for <M>0 \leq j \leq \frac{d}{2}</M> and <M>d</M> even, and <M>h_j - h_{d+1-j} = 0</M> for <M>0 \leq j \leq \frac{d-1}{2}</M> and <M>d</M> odd. Where <M>h_j</M> is the <M>j</M>th component of the <M>h</M>-vector, see <Ref Func="SCHVector"/>.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(6);;
## gap> SCDehnSommervilleCheck(c);
## true
## gap> c:=SC([[1,2,3],[1,4,5]]);;
## gap> SCDehnSommervilleCheck(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDehnSommervilleCheck,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)

	local f,m,d,chi,resvec,i;
	
	
	f:=SCFVector(c);
	if f = fail then
		return fail;
	fi;
	
	d:=SCDim(c);
	if d = fail then
		return fail;
	fi;
	
	m:=SCDehnSommervilleMatrix(d);
	if m = fail then
		return fail;
	fi;
	
	chi:=SCEulerCharacteristic(c);
	if chi = fail then
		return fail;
	fi;
	
	if Size(m[1]) <> Size(f) then
		Info(InfoSimpcomp,1,"SCDehnSommervilleCheck: invalid matrix or f-vector computed.");
		return fail;
	fi;
	
	resvec:=m*f;
	if chi <> resvec[1] then 
			return false;
	fi;
	for i in [2..Size(resvec)] do
		if i = 0 then
			if chi <> resvec[1] then
							return false;
			fi;
		else
			if resvec[i] <> 0 then	
							return false;
			fi;
		fi;
	od;
	
	return true;
end);

SCIntFunc.heegaardSplitting:=function(arg)

	local M,start,vertices,n,comb,sl,sz,ctr,m1,m2,d1,d2,idx,dim,manifold,j,i,hom,coll,lowerBound,maxGenus,genus,transitivity;
	
	M:=arg[1];
	if Size(arg) = 2 then
		start:=arg[2];
	elif Size(arg) > 2 then
		Info(InfoSimpcomp,1,"SCIntFunc.heegaardSplitting: number of arguments must be 1 or 2.");
		return fail;
	fi;

	dim:=SCDim(M);
	if dim = fail then
		return fail;
	fi;

	if dim <> 3 then
		Info(InfoSimpcomp,1,"SCIntFunc.heegaardSplitting: argument must be a combinatorial manifold of dimension 3.");
		return fail;
	fi;

	manifold:=SCIsManifold(M);
	if manifold <> true then
		Info(InfoSimpcomp,1,"SCIntFunc.heegaardSplitting: argument must be a combinatorial manifold of dimension 3.");
		return fail;
	fi;

	vertices:=SCVertices(M);
	n:=Size(vertices);
	if IsBound(start) then
		if not IsSubset(vertices,start) or Size(start) > Int(n/2) then
			Info(InfoSimpcomp,1,"SCIntFunc.heegaardSplitting: second argument must be a subset of vertices of M of size at most n/2.");
			return fail;
		fi;
	fi;

	if n < 9 then
		return [0,[[vertices[1]],vertices{[2..n]}],"minimal"];
	fi;

	hom:=SCHomology(M);
	coll:=[];
	for i in hom[2][2] do
		Append(coll,FactorsInt(i));
	od;
	lowerBound:=hom[2][1];
	for i in coll do
		if SCFpBettiNumbers(M,i) > lowerBound then
			lowerBound:=SCFpBettiNumbers(M,i)[2];
		fi;
	od;

	idx:=3;
	maxGenus:=1;
	while maxGenus < lowerBound do
		idx:=idx+1;
		maxGenus:=(idx-1)*(idx-2)/2;
	od;

	if IsBound(start) then
		if Size(start) > idx then
			idx:=Size(start);
		elif Size(start) < idx then
			Unbind(start);
		fi;
	fi;

	transitivity:=Transitivity(SCAutomorphismGroup(M));


	for j in [idx..Int(n/2)] do
	  comb:=Combinations(vertices{[transitivity+1..Size(vertices)]},j-transitivity);
	  sz:=Int(Minimum(1000,Size(comb)/10)); 
	  ctr:=0; 
	  if IsBound(start) and Size(start) < j then Unbind(start); fi;
	  if not IsBound(start) then Info(InfoSimpcomp,2,"SCIntFunc.heegaardSplitting: trying to find Heegaard splitting between ",j," and ",n-j," vertices."); fi;
	  for m1 in comb do
		m1:=Union(m1,vertices{[1..transitivity]}); 
		ctr:=ctr+1;		
		if IsBound(start) and m1 < start then continue; fi;
		if ctr mod 25 = 0 then 
			Info(InfoSimpcomp,2,ctr," / ",sz,""); 
		fi;
		if ctr > sz then break; fi;
		m2:=Difference(vertices,m1); 
		d1:=SCDim(SCCollapseGreedy(SCSpan(M,m1))); 
		d2:=SCDim(SCCollapseGreedy(SCSpan(M,m2)));
		if d1 = fail or d2 = fail then
			return fail;
		fi;
		if d1 <= 1 and d2 <= 1 then
			sl:=SCSlicing(M,[List(m1,x->Position(vertices,x)),List(m2,x->Position(vertices,x))]);
			genus:=SCGenus(sl);
			if genus = fail then
				return fail;
			else
				return [genus,[m1,m2],"arbitrary"];
			fi;
		fi;
	  od;
	od;

	Info(InfoSimpcomp,2,"SCIntFunc.heegaardSplitting: did not find any Heegaard splittings.");
	return [fail,[],"none"];

end;

################################################################################
##<#GAPDoc Label="SCHeegaardSplitting">
## <ManSection>
## <Meth Name="SCHeegaardSplitting" Arg="M"/>
##  <Returns> a list of an integer, a list of two sublists and a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a Heegaard splitting of the combinatorial <M>3</M>-manifold  <Arg>M</Arg>. The function returns the genus of the Heegaard splitting, the vertex partition of the Heegaard splitting and a note, that splitting is arbitrary and in particular possibly not minimal.
## 
## See also <Ref Func="SCHeegaardSplittingSmallGenus"/> for the calculation of a Heegaard splitting of small genus and <Ref Func="SCIsHeegaardSplitting"/> for a test whether or not a given splitting defines a Heegaard splitting.
## <Example><![CDATA[
## gap> M:=SCSeriesBdHandleBody(3,12);;
## gap> list:=SCHeegaardSplitting(M);
## gap> sl:=SCSlicing(M,list[2]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHeegaardSplitting,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(M)
	return SCIntFunc.heegaardSplitting(M);
end);

################################################################################
##<#GAPDoc Label="SCHeegaardSplittingSmallGenus">
## <ManSection>
## <Meth Name="SCHeegaardSplittingSmallGenus" Arg="M"/>
## <Returns> a list of an integer, a list of two sublists and a string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a Heegaard splitting of the combinatorial <M>3</M>-manifold  <Arg>M</Arg> of small genus. The function returns the genus of the Heegaard splitting, the vertex partition of the Heegaard splitting and information whether the splitting is minimal or just small (i. e. the Heegaard genus could not be determined).
## 
## See also <Ref Func="SCHeegaardSplitting"/> for a faster computation of a Heegaard splitting of arbitrary genus and <Ref Func="SCIsHeegaardSplitting"/> for a test whether or not a given splitting defines a Heegaard splitting.
## <Example><![CDATA[ NOEXECUTE
## gap> c:=SCSeriesBdHandleBody(3,10);;
## gap> M:=SCConnectedProduct(c,3);;
## gap> list:=SCHeegaardSplittingSmallGenus(M);
## This creates an error
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHeegaardSplittingSmallGenus,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(M)
	local vertices,n,hs,j,comb,m1,tmpHs,sl,hom,coll,lowerBound,transitivity,sz,i,ctr;

	vertices:=SCVertices(M);
	if vertices = fail then
		return fail;
	fi;
	n:=Size(vertices);
	if n = fail then
		return fail;
	fi;

	if n < 9 then
		Info(InfoSimpcomp,2,"SCHeegaardSplittingSmallGenus: found minimal Heegaard splitting between 1 and ",n-1," vertices, genus is 0");
		return [0,[[vertices[1]],vertices{[2..n]}],"minimal"];
	fi;	

	hom:=SCHomology(M);
	coll:=[];
	for i in hom[2][2] do
		Append(coll,FactorsInt(i));
	od;
	lowerBound:=hom[2][1];
	for i in coll do
		if SCFpBettiNumbers(M,i) > lowerBound then
			lowerBound:=SCFpBettiNumbers(M,i)[2];
		fi;
	od;

	hs:=SCIntFunc.heegaardSplitting(M);
	if hs = fail then
		return fail;
	fi;
	if hs[2] = [] then
		return hs;
	fi;

	if lowerBound = hs[1] then
		Info(InfoSimpcomp,2,"SCHeegaardSplittingSmallGenus: found minimal Heegaard splitting between ",Size(hs[2][1])," and ",Size(hs[2][2])," vertices, genus is ",hs[1]);
		return [hs[1],hs[2],"minimal"];
	fi;

	transitivity:=Transitivity(SCAutomorphismGroup(M));

	for j in [Size(hs[2][1])..Int(n/2)] do
	  comb:=Combinations(vertices{[transitivity+1..Size(vertices)]},j-transitivity);
	  sz:=Int(Minimum(1000,Size(comb)/10)); 
	  ctr:=0; 
	  Info(InfoSimpcomp,2,"SCHeegaardSplittingSmallGenus: trying to find Heegaard splitting between ",j," and ",n-j," vertices.");
	  for m1 in comb do 
		m1:=Union(vertices{[1..transitivity]},m1);
		ctr:=ctr+1;
		if IsBound(tmpHs) and Size(m1) < Size(tmpHs[2][1]) then break; fi;
		if not IsBound(tmpHs) and Size(m1) < Size(hs[2][1]) then break; fi;		
		if IsBound(tmpHs) and m1 <= tmpHs[2][1] and not j > Size(tmpHs[2][1]) then continue; fi;
		if not IsBound(tmpHs) and m1 <= hs[2][1] and not j > Size(hs[2][1]) then continue; fi;
		if ctr > sz then break; fi;
		tmpHs:=SCIntFunc.heegaardSplitting(M,m1);
		if tmpHs[2] = [] then
			return hs;
		fi;
		if tmpHs = fail then
			return fail;
		fi;
		sl:=SCSlicing(M,[List(tmpHs[2][1],x->Position(vertices,x)),List(tmpHs[2][2],x->Position(vertices,x))]);
		if not SCIsConnected(sl) then continue; fi;
		if tmpHs[1] = lowerBound then
			Info(InfoSimpcomp,2,"SCHeegaardSplittingSmallGenus: found minimal Heegaard splitting between ",Size(tmpHs[2][1])," and ",Size(tmpHs[2][2])," vertices, genus is ",tmpHs[1]);
			return [tmpHs[1],tmpHs[2],"minimal"];
		fi;
		if tmpHs[1] < hs[1] then
			hs:=tmpHs;
		fi;
	  od;
	od;	
	
	return [hs[1],hs[2],"small"];
end);

################################################################################
##<#GAPDoc Label="SCIsHeegaardSplitting">
## <ManSection>
## <Meth Name="SCIsHeegaardSplitting" Arg="c,list"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Checks whether <Arg>list</Arg> defines a Heegaard splitting of <Arg>c</Arg> or not.
## 
## See also <Ref Func="SCHeegaardSplitting"/> and <Ref Func="SCHeegaardSplittingSmallGenus"/> for functions to compute Heegaard splittings.
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(3,9);;
## gap> list:=[[1..3],[4..9]];
## gap> SCIsHeegaardSplitting(c,list);
## gap> splitting:=SCHeegaardSplitting(c);
## gap> SCIsHeegaardSplitting(c,splitting[2]);                                         
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsHeegaardSplitting,
"for SCSimplicialComplex and List",
[SCIsSimplicialComplex,IsList],
function(M,m)
	local vertices,n,d1,d2;
	
	vertices:=SCVertices(M);
	if vertices = fail then
		return fail;
	fi;
	n:=Size(vertices);
	if n = fail then
		return fail;
	fi;
	if not Union(m) = vertices or Size(m) <> 2 then
		Info(InfoSimpcomp,1,"SCIsHeegaardSplitting: second argument must be a partition of the set of vertices of size 2.");
		return fail;
	fi; 
	d1:=SCDim(SCCollapseGreedy(SCSpan(M,m[1]))); 
	d2:=SCDim(SCCollapseGreedy(SCSpan(M,m[2])));
	if d1 = fail or d2 = fail then
		return fail;
		fi;
	if d1 <= 1 and d2 <= 1 then
		return true;
	else
		return false;
	fi;

end);
