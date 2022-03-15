################################################################################
##
##  simpcomp / operations.gi
##
##  Operations on simplicial complexes.
##
##  $Id$
##
################################################################################


SCIntFunc.RelabelSimplexList:=
function(simplices,maptable)
	local facets;
	if(simplices=fail or maptable=fail) then
		return fail;
	else
		if IsSortedList(maptable) then
			return List(simplices,s->List(s,x->maptable[x]));
		else
			facets:= List(simplices,s->List(s,x->maptable[x]));
			Perform(facets,Sort);
			Sort(facets);
			return facets;
		fi;
	fi;
end;

SCIntFunc.RelabelSimplexListInv:=
function(simplices,maptable)
	local facets;
	if(simplices=fail or maptable=fail) then
		return fail;
	else
		if IsSortedList(maptable) then
			return List(simplices,s->List(s,x->Position(maptable,x)));
		else
			facets:=List(simplices,s->List(s,x->Position(maptable,x)));
			Perform(facets,Sort);
			Sort(facets);
			return facets;
		fi;
	fi;
end;

SCIntFunc.RelabelPermutation:=
function(perm,maptable)
	local l1,l2,i;
	if(perm=fail or maptable=fail) then
		return fail;
	else
		l1:=ListPerm(perm);
		l1:=List(l1,x->[Position(l1,x),x]);
		l1:=Filtered(l1,x->x[1]<>x[2]); #kill fixed points
		l1:=Filtered(l1,x->IsSubset(maptable,x)); # kill points that are not part of the complex
		l1:=SCIntFunc.RelabelSimplexListInv(l1,maptable); #relabel
		l2:=[];
		for i in [1..Size(l1)] do # build relabeled permutation in list representation
			l2[l1[i][1]]:=l1[i][2];
		od;
		for i in [1..Size(l2)] do # fill up fixed points
			if not IsBound(l2[i]) then
				l2[i]:=i;
			fi;
		od;
		l2:=PermList(l2); # transform to cycle representation
		
		return l2;
	fi;
end;


SCIntFunc.SCCompactify:=
function(facets)
  return Filtered(DuplicateFreeList(facets), f1->Number(facets,f2->IsSubset(f2,f1))=1);
end;

################################################################################
##<#GAPDoc Label="SCJoin">
## <ManSection>
## <Meth Name="SCJoin" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the simplicial join of the simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg>. If facet lists instead of <C>SCSimplicialComplex</C> objects are passed as arguments, the function internally falls back to the homology package <Cite Key="Dumas04Homology" />, if available. Note that the vertex labelings of the complexes passed as arguments are not propagated to the new complex.
## <Example><![CDATA[
## gap> sphere:=SCJoin(SCBdSimplex(2),SCBdSimplex(2));
## gap> SCHasBoundary(sphere);
## false
## gap> sphere.Facets;
## [ [ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 2 ] ],
##   [ [ 1, 1 ], [ 1, 2 ], [ 2, 1 ], [ 2, 3 ] ],
##   [ [ 1, 1 ], [ 1, 2 ], [ 2, 2 ], [ 2, 3 ] ],
##   [ [ 1, 1 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ] ],
##   [ [ 1, 1 ], [ 1, 3 ], [ 2, 1 ], [ 2, 3 ] ],
##   [ [ 1, 1 ], [ 1, 3 ], [ 2, 2 ], [ 2, 3 ] ],
##   [ [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ] ],
##   [ [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 3 ] ],
##   [ [ 1, 2 ], [ 1, 3 ], [ 2, 2 ], [ 2, 3 ] ] ]
## gap> sphere.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> ball:=SCJoin(SC([[1]]),SCBdSimplex(2));
## gap> ball.Homology;
## [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ] ]
## gap> ball.Facets;
## [ [ [ 1, 1 ], [ 2, 1 ], [ 2, 2 ] ], [ [ 1, 1 ], [ 2, 1 ], [ 2, 3 ] ],
##   [ [ 1, 1 ], [ 2, 2 ], [ 2, 3 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCJoin,
"for List and List",
[IsList,IsList],
function(complex1,complex2)
	local join;
	if(IsBound(SCIntFunc.SCJoinOld)) then
			return SCIntFunc.SCJoinOld(complex1,complex2);
	fi;
			
	Info (InfoSimpcomp, 1, "SCJoin: invalid argument list, expecting a simplicial complex. Fallback to homology package failed.");
	return fail;
end);

InstallMethod(SCJoin,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1,complex2)
	
	local join;
	
	join:=SCFromFacets(Concatenation (List (SCFacetsEx(complex1), s1 -> List (SCFacetsEx(complex2),
	s2 -> Concatenation(List (s1, i -> [1, i]), List (s2, i -> [2, i]))))));
	
	if(join=fail) then
		return fail;
	fi;
	
	if(SCName(complex1)<>fail and SCName(complex2)<>fail) then
		SCRename(join,Concatenation(SCName(complex1)," join ",SCName(complex2)));
	fi;
	return join;
end);


################################################################################
##<#GAPDoc Label="SCSuspension">
## <ManSection>
## <Meth Name="SCSuspension" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the simplicial suspension of the simplicial complex <Arg>complex</Arg>. Internally falls back to the homology package <Cite Key="Dumas04Homology" /> (if available) if a facet list is passed as argument. Note that the vertex labelings of the complexes passed as arguments are not propagated to the new complex.
## <Example><![CDATA[
## gap> SCLib.SearchByName("Poincare");
## gap> phs:=SCLib.Load(last[1][1]);
## gap> susp:=SCSuspension(phs);;
## gap> edwardsSphere:=SCSuspension(susp);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSuspension,
"for List",
[IsList],
function(complex)
	if(IsBound(SCIntFunc.SCSuspensionOld)) then
		return SCIntFunc.SCSuspensionOld(complex);
	fi;

	Info (InfoSimpcomp, 1, "SCSuspension: invalid argument list, expecting a simplicial complex. Fallback to homology package failed.");
	return fail;
end);

InstallMethod(SCSuspension,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	
	local susp;
	
	if SCIsEmpty(complex) then
		return SCFromFacets([[1],[2]]);
	fi;
	
	susp:=SCJoin(complex, SCFromFacets([[1], [2]]));
	
	if(susp=fail) then
		return fail;
	fi;
	
	if(SCName(complex)<>fail) then
		SCRename(susp,Concatenation("susp of ",SCName(complex)));
	fi;
	
	return susp;
end);


################################################################################
##<#GAPDoc Label="SCDeletedJoin">
## <ManSection>
## <Meth Name="SCDeletedJoin" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the simplicial deleted join of the simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg>. If called with a facet list instead of a <C>SCSimplicialComplex</C> object, the function internally falls back to the <Package>homology</Package> package <Cite Key="Dumas04Homology" />, if available.
## <Example><![CDATA[
## gap> deljoin:=SCDeletedJoin(SCBdSimplex(3),SCBdSimplex(3));
## gap> bddeljoin:=SCBoundary(deljoin);;
## gap> bddeljoin.Homology;
## [ [ 1, [  ] ], [ 0, [  ] ], [ 2, [  ] ] ]
## gap> deljoin.Facets;
## [ [ [ 1, 1 ], [ 2, 1 ], [ 3, 1 ], [ 4, 2 ] ],
##   [ [ 1, 1 ], [ 2, 1 ], [ 3, 2 ], [ 4, 1 ] ],
##   [ [ 1, 1 ], [ 2, 1 ], [ 3, 2 ], [ 4, 2 ] ],
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 1 ], [ 4, 1 ] ],
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 1 ], [ 4, 2 ] ],
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 2 ], [ 4, 1 ] ],
##   [ [ 1, 1 ], [ 2, 2 ], [ 3, 2 ], [ 4, 2 ] ],
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 1 ], [ 4, 1 ] ],
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 1 ], [ 4, 2 ] ],
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 2 ], [ 4, 1 ] ],
##   [ [ 1, 2 ], [ 2, 1 ], [ 3, 2 ], [ 4, 2 ] ],
##   [ [ 1, 2 ], [ 2, 2 ], [ 3, 1 ], [ 4, 1 ] ],
##   [ [ 1, 2 ], [ 2, 2 ], [ 3, 1 ], [ 4, 2 ] ],
##   [ [ 1, 2 ], [ 2, 2 ], [ 3, 2 ], [ 4, 1 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDeletedJoin,
"for List and List",
[IsList,IsList],
function(complex1,complex2)
	if(IsBound(SCIntFunc.SCDeletedJoinOld)) then
		return SCIntFunc.SCDeletedJoinOld(complex1,complex2);
	fi;
	
	Info(InfoSimpcomp, 1, "SCDeletedJoin: invalid argument list, expecting two simplicial complexes. Fallback to homology package failed.");
	return fail;
end);

InstallMethod(SCDeletedJoin,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1,complex2)
	local c1,c2,dj,i,j,k,e,l,l1,l2,f1,f2;

	l1:=SCVertices(complex1);
	l2:=SCVertices(complex2);
	
	if(l1=fail or l2=fail or not ForAll(l1,IsInt) or not ForAll(l2,IsInt)) then
		Info(InfoSimpcomp,1,"SCDeletedJoin: complexes must be labeled with integer numbers.");
		return fail;
	fi;
	
	f1:=Union(SCFaceLattice(complex1));
	f2:=Union(SCFaceLattice(complex2));

	if(f1=fail or f2=fail) then
		return fail;
	fi;
	
	dj:=[];
	
	for i in [1..Length(f1)] do
		for j in [1..Length(f2)] do
			if(Intersection(f1[i],f2[j])<>[]) then
				continue;
			fi;
			
			e:=Union(List(f1[i],x->[x,1]),List(f2[j],x->[x,2]));
			l:=Length(e);
			if(not IsBound(dj[l])) then dj[l]:=[]; fi;
			Add(dj[l],e);
		od;
	od;


	for i in [1..Length(dj)] do
		if not IsBound(dj[i]) then
			dj[i]:=[];
		fi;
	od;

	dj:=SCFromFacets(Union(SCIntFunc.reduceFaceLattice(dj)));
	if(dj=fail) then
		return fail;
	fi;
	
	if(SCName(complex1)<>fail and SCName(complex2)<>fail) then
		SCRename(dj,Concatenation(SCName(complex1)," deljoin ",SCName(complex2)));
	fi;
	return dj;	
end);

################################################################################
##<#GAPDoc Label="SCWedge">
## <ManSection>
## <Meth Name="SCWedge" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the wedge product of the complexes supplied as arguments. Note that the vertex labelings of the complexes passed as arguments are not propagated to the new complex.
## <Example><![CDATA[
## gap> wedge:=SCWedge(SCBdSimplex(2),SCBdSimplex(2));
## gap> wedge.Facets;
## [ [ [ 1, 2 ], [ 1, 3 ] ], [ [ 2, 2 ], [ 2, 3 ] ], [ [ 1, 2 ], "a" ], 
##   [ [ 1, 3 ], "a" ], [ [ 2, 2 ], "a" ], [ [ 2, 3 ], "a" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCWedge,
"for List and List",
[IsList,IsList],
function(complex1,complex2)
	if(IsBound(SCIntFunc.SCWedgeOld)) then
		#fallback to homology package
		return SCIntFunc.SCWedgeOld(complex1,complex2);
	fi;
	Info (InfoSimpcomp, 1, "SCWedge: the arguments should be two simplicial complexes, each of at least dimension 1. Fallback to homology package failed.");
	return fail;
end);

InstallMethod(SCWedge,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1,complex2)
	local points,complexes,names,n,wedge,scwedge;

	if SCDim(complex1) < 1 or SCDim(complex2) < 1 then
			Info (InfoSimpcomp, 1, "SCWedge: the argument should be a list of simplicial complexes, each of at least dimension 1.");
		return fail;
	fi;

	complexes:=[SCFacetsEx(complex1),SCFacetsEx(complex2)];	
	points:=List(complexes,c->Union(c));
		
	#code taken from homology package
	wedge:=Concatenation(List (Filtered ([1 .. Length (complexes)], i -> points [i] <> []),
	i -> List (complexes [i], s -> List (s,
	function (n)
		if n = points [i] [1] then
			return 1;
		else
			return [i, n];
		fi;
	end))));

	if HasSCName(complex1) and HasSCName(complex2) then
		names:=[SCName(complex1),SCName(complex2)];
	fi;
	
	scwedge:=SCFromFacets(wedge);
	if(scwedge=fail) then
		return fail;
	fi;
	
	if HasSCName(complex1) and HasName(complex2) then
	  SCRename(scwedge,Concatenation(names[1]," wedge ",names[2]));
  fi;
	return scwedge;
end);

# check which faces already exist (by dimension)
SCIntFunc.FacesExist:=
function(complex,dim)
	local faces;

	faces:=SCFaceLattice(complex);
	if faces<>fail then
		if dim+1<=Size(faces) and IsBound(faces[dim+1]) and faces[dim+1]<>[] then
			if(not IsList(faces[dim+1]) or not IsDuplicateFreeList(faces[dim+1]) or not ForAll(faces[dim+1],x->IsList(x) and IsDuplicateFree(x))) then
				Info(InfoSimpcomp,1,"SCIntFunc.FacesExist: invalid face lattice.");
				return fail;
			else
				return true;
			fi;
		else
			return false;
		fi;
	else
		return false;
	fi;
end;

#performs an operation on the face lattice of a complex
SCIntFunc.OperationOnFL:=
function(fl1,fl2,op)
	local fl,i;
	
	if(fl1=fail or fl2=fail) then
		return fail;
	fi;
	
	fl:=[];
	for i in [1..MaximumList([Length(fl1),Length(fl2)])] do
		if(IsBound(fl1[i]) and IsBound(fl2[i])) then
			fl[i]:=CallFuncList(op,[fl1[i],fl2[i]]);
		elif(IsBound(fl1[i])) then
			fl[i]:=CallFuncList(op,[fl1[i],[]]);
		elif(IsBound(fl2[i])) then
			fl[i]:=CallFuncList(op,[[],fl2[i]]);
		fi;
	od;
	return fl;
end;


################################################################################
##<#GAPDoc Label="SCDifference">
## <ManSection>
## <Meth Name="SCDifference" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the ``difference'' of two simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> as the simplicial complex formed by the difference of the face lattices of <Arg>complex1</Arg> minus <Arg>complex2</Arg>. The two arguments are not altered. Note: for the difference process the vertex labelings of the complexes are taken into account, see also <Ref Meth="Operation Difference (SCSimplicialComplex, SCSimplicialComplex)"/>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> d:=SC([[1,2,3]]);;
## gap> disc:=SCDifference(c,d);;
## gap> disc.Facets;
## [ [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
## gap> empty:=SCDifference(d,c);;
## gap> empty.Dim;
## -1
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCDifference,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local fl1,fl2,fl,i,s,diff;

	fl1:=SCFaceLattice(complex1);
	fl2:=SCFaceLattice(complex2);
	if(fl1=fail or fl2=fail) then
		return fail;
	fi;
	
	fl:=SCIntFunc.OperationOnFL(fl1,fl2,Difference);
	diff:=SCFromFacets(Union(SCIntFunc.reduceFaceLattice(fl)));
	if diff = fail then
		return fail;
	fi;
	
	if(SCName(complex1)<>fail and SCName(complex2)<>fail) then
		SCRename(diff,Concatenation(SCName(complex1)," \\ ",SCName(complex2)));
	fi;
	
	return diff;
	
end);


################################################################################
##<#GAPDoc Label="SCNeighborsEx">
## <ManSection>
## <Meth Name="SCNeighborsEx" Arg="complex, face"/>
## <Returns>a list of faces upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a simplicial complex <Arg>complex</Arg> all neighbors of the <C>k</C>-face  <Arg>face</Arg>, i. e. all <C>k</C>-faces distinct from <Arg>face</Arg> intersecting with <Arg>face</Arg> in a common <M>(k-1)</M>-face, are returned in the standard labeling.
## <Example><![CDATA[
## gap> c:=SCFromFacets(Combinations(["a","b","c"],2));
## gap> SCLabels(c);
## [ "a", "b", "c" ]
## gap> SCNeighborsEx(c,[1,2]);
## [ [ 1, 3 ], [ 2, 3 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
InstallMethod(SCNeighborsEx,
"for SCSimplicialComplex and List",
[SCIsSimplicialComplex,IsList],
function(complex, face)
	local d,f,skel,l,neigh;
	
	if(not IsDuplicateFreeList(face)) then
		Info(InfoSimpcomp,1,"SCNeighborsEx: second argument must be a proper face, i. e. a duplicate free list.");
		return fail;
	fi;
	
	d:=SCDim(complex);
	if(d=fail) then
		return fail;
	fi;
	
	
	if(Length(face)<2 or Length(face)>d+1) then
		return [];
	fi;
	
	l:=Length(face)-1;
	skel:=SCSkelEx(complex,l);
	
	if(skel=fail) then
		return fail;
	fi;
	
	neigh:=[];
	for f in skel do
		if(face<>f and Length(Intersection(face,f))=l) then
			Add(neigh,f);
		fi;
	od;
	
	return neigh;
end);



################################################################################
##<#GAPDoc Label="SCNeighbors">
## <ManSection>
## <Meth Name="SCNeighbors" Arg="complex, face"/>
## <Returns>a list of faces upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a simplicial complex <Arg>complex</Arg> all neighbors of the <C>k</C>-face  <Arg>face</Arg>, i. e. all <C>k</C>-faces distinct from <Arg>face</Arg> intersecting with <Arg>face</Arg> in a common <M>(k-1)</M>-face, are returned in the original labeling.
## <Example><![CDATA[
## gap> c:=SCFromFacets(Combinations(["a","b","c"],2));
## gap> SCNeighbors(c,["a","d"]);
## [ [ "a", "b" ], [ "a", "c" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
InstallMethod(SCNeighbors,
"for SCSimplicialComplex and List",
[SCIsSimplicialComplex,IsList],
function(complex, face)
	local d,f,skel,l,neigh;
	
	if(not IsDuplicateFreeList(face)) then
		Info(InfoSimpcomp,1,"SCNeighbors: second argument must be a proper face, i. e. a duplicate free list.");
		return fail;
	fi;
	
	d:=SCDim(complex);
	
	if(d=fail) then
		return fail;
	fi;
	
	
	if(Length(face)<2 or Length(face)>d+1) then
		return [];
	fi;
	
	l:=Length(face)-1;
	skel:=SCSkel(complex,l);
	
	if(skel=fail) then
		return fail;
	fi;
	
	neigh:=[];
	for f in skel do
		if(face<>f and Length(Intersection(face,f))=l) then
			Add(neigh,f);
		fi;
	od;
	
	return neigh;
end);



################################################################################
##<#GAPDoc Label="SCIntersection">
## <ManSection>
## <Meth Name="SCIntersection" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the ``intersection'' of two simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> as the simplicial complex formed by the intersection of the face lattices of <Arg>complex1</Arg> and <Arg>complex2</Arg>. The two arguments are not altered. Note: for the intersection process the vertex labelings of the complexes are taken into account. See also <Ref Meth="Operation Intersection (SCSimplicialComplex, SCSimplicialComplex)"/>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;        
## gap> d:=SCBdSimplex(3)+1;;      
## gap> d.Facets;
## [ [ 2, 3, 4 ], [ 2, 3, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ] ]
## gap> c:=SCBdSimplex(3);;  
## gap> d:=SCBdSimplex(3);;  
## gap> d:=SCMove(d,[[1,2,3],[]])+1;;
## gap> s1:=SCIntersection(c,d);;
## gap> s1.Facets;               
## [ [ 2, 3 ], [ 2, 4 ], [ 3, 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
InstallMethod(SCIntersection,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)
	local sec,fl1,fl2;
	
	fl1:=SCFaceLattice(complex1);
	fl2:=SCFaceLattice(complex2);
	if fl1 = fail or fl2 = fail then
		return fail;
	fi;
	
	sec:=SCFromFacets(Union(SCIntFunc.reduceFaceLattice(SCIntFunc.OperationOnFL(fl1,fl2,Intersection))));
	if sec = fail then
		return fail;
	fi;
	
	if(SCName(complex1)<>fail and SCName(complex2)<>fail) then
		SCRename(sec,Concatenation(SCName(complex1)," cap ",SCName(complex2)));
	fi;
	
	return sec;
end);






################################################################################
##<#GAPDoc Label="SCUnion">
## <ManSection>
## <Meth Name="SCUnion" Arg="complex1, complex2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Forms the union of two simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> as the simplicial complex formed by the union of their facets sets. The two arguments are not altered. Note: for the union process the vertex labelings of the complexes are taken into account, see also <Ref Meth="Operation Union (SCSimplicialComplex, SCSimplicialComplex)" />. Facets occurring in both arguments are treated as one facet in the new complex.
## <Example><![CDATA[
## gap> c:=SCUnion(SCBdSimplex(3),SCBdSimplex(3)+3); #a wedge of two 2-spheres
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCUnion,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
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

	un:=SCFromFacets(facets);

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
##<#GAPDoc Label="SCIsSubcomplex">
## <ManSection>
## <Meth Name="SCIsSubcomplex" Arg="sc1,sc2"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> if the simplicial complex <Arg>sc2</Arg> is a sub-complex of simplicial complex <Arg>sc1</Arg>, <K>false</K> otherwise. If dim(<Arg>sc2</Arg>) <M>\leq</M> dim(<Arg>sc1</Arg>) the facets of <Arg>sc2</Arg> are compared with the dim(<Arg>sc2</Arg>)-skeleton of <Arg>sc1</Arg>. Only works for pure simplicial complexes. Note: for the intersection process the vertex labelings of the complexes are taken into account. 
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("F[1]=10"){[1..10]};
## [ [ 17, "T^2 (VT)" ], [ 18, "K^2 (VT)" ], 
##   [ 19, "S^3 (VT)" ], [ 20, "(T^2)#2" ], [ 21, "S^3 (VT)" ],
##   [ 22, "S^3 (VT)" ], [ 23, "S^2xS^1 (VT)" ], 
##   [ 24, "(T^2)#3" ], [ 25, "(P^2)#7 (VT)" ], 
##   [ 26, "S^2~S^1 (VT)" ] ]
## gap> k:=SCLib.Load(last[1][1]);;
## gap> c:=SCBdSimplex(9);;
## gap> k.F;
## [10, 30, 20]
## gap> c.F;
## [10, 45, 120, 210, 252, 210, 120, 45, 10]
## gap> SCIsSubcomplex(c,k);
## true
## gap> SCIsSubcomplex(k,c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsSubcomplex,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(sc1,sc2)
	local d,facets,skel;
	
	d:=[SCDim(sc1),SCDim(sc2)];
	facets:=[SCFacets(sc1),SCFacets(sc2)];
	
	if(fail in d or fail in facets) then
		return fail;
	fi;
	
	if(d[2]>d[1]) then
		return false;
	elif(d[2]=d[1]) then
		return IsSubset(facets[1],facets[2]);
	else
		#here d[2]<d[1]
		skel:=SCSkel(sc1,d[2]);
		if(skel=fail) then
			return fail;
		fi;
		return IsSubset(skel,facets[2]); 
	fi;
end);

################################################################################
##<#GAPDoc Label="SCAlexanderDual">
## <ManSection>
## <Meth Name="SCAlexanderDual" Arg="complex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The Alexander dual of a simplicial complex <Arg>complex</Arg> with set of vertices <M>V</M> is the simplicial complex where any subset of <M>V</M> spans a face if and only if its complement in <M>V</M> is a non-face of <Arg>complex</Arg>.
## <Example><![CDATA[
## # a square
## gap> c:=SC([[1,2],[2,3],[3,4],[4,1]]);;
## gap> dual:=SCAlexanderDual(c);;
## gap> dual.F;
## [4, 2]
## gap> dual.IsConnected;
## false
## gap> dual.Facets;
## [[1, 3], [2, 4]]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAlexanderDual,
"for List",
[IsList],
function(complex)
	if(IsBound(SCIntFunc.SCAlexanderDualOld)) then
		return SCIntFunc.SCAlexanderDualOld(complex);
	fi;

	Info(InfoSimpcomp,1,"SCAlexanderDual: first argument must be of type SCSimplicialComplex. Fallback to homology package failed.");
	return fail;
end);

InstallMethod(SCAlexanderDual,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
#code taken from homology package
function(complex)
	local facets,verts,dual,dim,i,missing;

	facets:=SCFacets(complex);
	if facets=fail then
		return fail;
	fi;
	
	dim:=SCDim(complex);
	if dim=fail then
		return fail;
	fi;
	
	if(dim=-1) then
		return SCEmpty();
	fi;
	
	verts:=SCVertices(complex);
	dual:=[];
	missing:=SCIntFunc.MissingFacesComplex(complex,true);
	if missing=fail then
		return fail;
	fi;
	for i in [1..dim] do
	  dual[i+1]:=List(missing[i+1],x->Difference(verts,x));
	od;
		
	dual:=SCFromFacets(Union(dual));
	
	if(SCName(complex)<>fail) then
		SCRename(dual,Concatenation("Alexander dual of ",SCName(complex)));
	fi;
	
	return dual;	
end);

SCIntFunc.SCVertexIdentificationEx:=
function(facets,verts,v1,v2)

	local maptable,i,facetsnew,f,fnew,v;

	maptable:=ShallowCopy(verts);
	
	if(not IsSubset(verts,v1) or not IsSubset(verts,v2) or Length(v1)<>Length(v2)) then
		Info(InfoSimpcomp,1,"SCVertexIdentificationEx: must provide valid vertex subsets of same cardinality.");
		return fail;
	fi;
	
	
	for i in [1..Length(v2)] do
		maptable[Position(maptable,v2[i])]:=v1[i];
	od;
	
	facetsnew:=[];
	
	for f in facets do
		fnew:=[];
		for v in f do
			AddSet(fnew,maptable[Position(verts,v)]);
		od;
		
		Add(facetsnew,fnew);
	od;
	
	return Set(facetsnew);
end;



################################################################################
##<#GAPDoc Label="SCHandleAddition">
## <ManSection>
## <Meth Name="SCHandleAddition" Arg="complex,f1,f2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C>, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a simplicial complex obtained by identifying the vertices of facet <Arg>f1</Arg> with the ones from facet <Arg>f2</Arg> in <Arg>complex</Arg>. A combinatorial handle addition is possible, whenever we have d<M>(v,w) \geq 3</M> for any two vertices <M>v \in </M><Arg>f1</Arg> and <M>w \in </M><Arg>f2</Arg>, where d<M>(\cdot,\cdot)</M> is the length of the shortest path from <M>v</M> to <M>w</M>. This condition is not checked by this algorithm. See <Cite Key="Bagchi08OnWalkupKd"/> for further information.
## <Example><![CDATA[
## gap> c:=SC([[1,2,4],[2,4,5],[2,3,5],[3,5,6],[1,3,6],[1,4,6]]);;
## gap> c:=SCUnion(c,SCUnion(SCCopy(c)+3,SCCopy(c)+6));;
## gap> c:=SCUnion(c,SC([[1,2,3],[10,11,12]]));;
## gap> c.Facets;
## [[1, 2, 3], [1, 2, 4], [1, 3, 6], [1, 4, 6], [2, 3, 5],
##   [2, 4, 5], [3, 5, 6], [4, 5, 7], [4, 6, 9], [4, 7, 9],
##   [5, 6, 8], [5, 7, 8], [6, 8, 9], [7, 8, 10], [7, 9, 12],
##   [7, 10, 12], [8, 9, 11], [8, 10, 11], [9, 11, 12], [10, 11, 12]]
## gap> c.Homology;
## [[0, []], [0, []], [1, []]]
## gap> torus:=SCHandleAddition(c,[1,2,3],[10,11,12]);;
## gap> torus.Homology;
## [[0, []], [2, []], [1, []]]
## gap> ism:=SCIsManifold(torus);;
## gap> ism;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHandleAddition,
"for SCSimplicialComplex and List and List",
[SCIsSimplicialComplex,IsList,IsList],
function(complex,f1,f2)

	local facets,hb;

	facets:=SCFacets(complex);
	if facets=fail or facets=[] then
		return fail;
	fi;
	
	if(not Set(f1) in facets or not Set(f2) in facets) then
		Info(InfoSimpcomp,1,"SCHandleAddition: invalid facets specified.");
		return fail;
	fi;
		
	facets:=Difference(facets,[Set(f1),Set(f2)]);
	facets:=SCIntFunc.SCVertexIdentificationEx(facets,SCVertices(complex),f1,f2);
	
	if(facets=fail) then
		return fail;
	fi;
	
	hb:=SCFromFacets(facets);
	if(SCName(complex)<>fail) then
		SCRename(hb,Concatenation(SCName(complex)," handle (",String(f1),"=",String(f2),")"));
	fi;
	
	return hb;
end);


################################################################################
##<#GAPDoc Label="SCVertexIdentification">
## <ManSection>
## <Meth Name="SCVertexIdentification" Arg="complex,v1,v2"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Identifies vertex <Arg>v1</Arg> with vertex <Arg>v2</Arg> in a simplicial complex <Arg>complex</Arg> and returns the result as a new object. A vertex identification of <Arg>v1</Arg> and <Arg>v2</Arg> is possible whenever d(<Arg>v1</Arg>,<Arg>v2</Arg>) <M>\geq 3</M>. This is not checked by this algorithm. 
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[3,4]]);;
## gap> circle:=SCVertexIdentification(c,[1],[4]);;
## gap> circle.Facets;
## [[1, 2], [1, 3], [2, 3]]
## gap> circle.Homology;
## [[0, []], [1, []]]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCVertexIdentification,
"for SCSimplicialComplex and Object and Object",
[SCIsSimplicialComplex,IsObject,IsObject],
function(complex,v1,v2)

	local facets,id;

	facets:=SCFacets(complex);
	if facets=fail or facets=[] then
		return fail;
	fi;
	
	facets:=SCIntFunc.SCVertexIdentificationEx(facets,SCVertices(complex),v1,v2);
	
	if(facets=fail) then
		return fail;
	fi;
	
	id:=SCFromFacets(facets);
	if(SCName(complex)<>fail) then
		SCRename(id,Concatenation(SCName(complex)," vertex identified (",String(v1),"=",String(v2),")"));
	fi;
	
	return id;
end);




################################################################################
##<#GAPDoc Label="SCLinks">
## <ManSection>
## <Meth Name="SCLinks" Arg="complex,k"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the link of all <Arg>k</Arg>-faces of the polyhedral complex <Arg>complex</Arg> and returns them as a list of simplicial complexes. Internally calls <Ref Meth="SCLink"/> for every <Arg>k</Arg>-face of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## # all vertex links -> 2 spheres
## gap> SCLinks(c,0);
## # all edge links -> circles
## gap> SCLinks(c,1);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCLinks,
"for SCPolyhedralComplex and Int",
[SCIsPolyhedralComplex,IsInt],
function(complex, k)

	local i, j, links, facets, vertices, max, tmp, labels, simplices;

	if(SCDim(complex)<k or k<0) then
		Info(InfoSimpcomp,1,"SCLinks: second argument must be >=0 and less or equal to dimension of complex.");
		return fail;
	fi;

	simplices:=SCSkel(complex,k);
	if simplices=fail then
		Info(InfoSimpcomp,1,"SCLinks: complex lacks ",k,"-faces.");
		return fail;
	fi;

	links:=[];
	for i in [1..Size(simplices)] do
		links[i]:=SCLink(complex,simplices[i]);
	od;

	return links;
end);


################################################################################
##<#GAPDoc Label="SCStars">
## <ManSection>
## <Meth Name="SCStars" Arg="complex,k"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the star of all <Arg>k</Arg>-faces of the polyhedral complex <Arg>complex</Arg> and returns them as a list of simplicial complexes. Internally calls <Ref Meth="SCStar"/> for every <Arg>k</Arg>-face of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], 
##   [ 10, "T^2 (VT)" ], [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);; # the minimal 7-vertex torus
## gap> SCStars(torus,0); # 7 2-discs as vertex stars
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCStars,
"for SCPolyhedralComplex and Int",
[SCIsPolyhedralComplex,IsInt],
function(complex, k)

	local i, j, stars, faces, max, labels;

	if(SCDim(complex)<k or k<0) then
		Info(InfoSimpcomp,1,"SCLinks: second argument must be >=0 and less or equal to dimension of complex.");
		return fail;
	fi;

	faces:=SCFaces(complex,k);
	if faces=fail then
		Info(InfoSimpcomp,1,"SCStars: complex lacks ",k,"-faces.");
		return fail;
	fi;
	
	stars:=[];
	for i in [1..Size(faces)] do
		stars[i]:=SCStar(complex,faces[i]);
	od;
	
	return stars;
end);


################################################################################
##<#GAPDoc Label="SCLink">
## <ManSection>
## <Meth Name="SCLink" Arg="complex,face"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the link of <Arg>face</Arg> (a face given as a list of vertices or a scalar interpreted as vertex) in a polyhedral complex <Arg>complex</Arg>, i. e. all facets containing <Arg>face</Arg>, reduced by <Arg>face</Arg>. if <Arg>complex</Arg> is pure, the resulting complex is of dimension dim(<Arg>complex</Arg>) - dim(<Arg>face</Arg>) <M>-1</M>. If <Arg>face</Arg> is not a face of <Arg>complex</Arg> the empty complex is returned.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");     
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2:=SCLib.Load(last[1][1]);;
## gap> SCVertices(rp2);
## [1, 2, 3, 4, 5, 6]
## gap> SCLink(rp2,[1]);
## gap> last.Facets;
## [[2, 3], [2, 6], [3, 5], [4, 5], [4, 6]]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCLink,
"for List and Object",
[IsList,IsObject],
function(complex,face)

	local tmp;

	if(IsBound(SCIntFunc.SCLinkOld)) then
		#fallback to homology package
		tmp:=face;
		if(not IsList(tmp)) then
			tmp:=[tmp];
		fi;
		return SCIntFunc.SCLinkOld(complex,tmp);
	fi;
	
	Info(InfoSimpcomp,1,"SCLink: first argument must be of type SCPolyhedralComplex.");
	return fail;
end);

InstallMethod(SCLink,
"for SCPolyhedralComplex and Object",
[SCIsPolyhedralComplex,IsObject],
function(complex,face)
	return SCLink(complex,[face]);
end);

InstallMethod(SCLink,
"for SCPolyhedralComplex and List",
[SCIsPolyhedralComplex,IsList],
function(complex,face)

	local i, j, tmp, flag, link, ctr, facets, labels, lsubset;

	if SCIsEmpty(complex) then
		return SCEmpty();
	fi;
	
	labels:=SCLabels(complex);
		
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCLink: complex lacks vertex labels.");
		return fail;
	fi;

	if(not IsList(face)) then
		lsubset:=[face];
	else
		lsubset:=face;
	fi;
	
	if not IsSubset(labels,lsubset) then
		Info(InfoSimpcomp,1,"SCLink: face must be a face / non-face of complex.");
		return SCEmpty();
	fi;

	lsubset:=List(lsubset,x->Position(labels,x));
	
	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;

	link:=[];
	ctr:=0;
	for i in facets do
		if IsSubset(i,lsubset) then
			ctr:=ctr+1;
			tmp:=Difference(i,lsubset);
			flag:=0;
			link[ctr]:=tmp;
		fi;
	od;
	if link=[] then
		link:=SCEmpty();
	else
		link:=SCFromFacets(SCIntFunc.RelabelSimplexList(link,labels));
	fi;
	
	if(SCName(complex)<>fail) then
		SCRename(link,Concatenation("lk(",String(face),") in ",SCName(complex)));
	else
		SCRename(link,Concatenation("lk(",String(face),")"));
	fi;
	
	return link;
end);


################################################################################
##<#GAPDoc Label="SCStar">
## <ManSection>
## <Meth Name="SCStar" Arg="complex,face"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise .</Returns>
## <Description>
## Computes the star of <Arg>face</Arg> (a face given as a list of vertices or a scalar interpreted as vertex) in a polyhedral complex <Arg>complex</Arg>, i. e. the set of facets of <Arg>complex</Arg> that contain <Arg>face</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");     
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2:=SCLib.Load(last[1][1]);;
## gap> SCVertices(rp2);
## [1, 2, 3, 4, 5, 6]
## gap> SCStar(rp2,1);
## gap> last.Facets;
## [ [1, 2, 3], [1, 2, 6], [1, 3, 5], [1, 4, 5], [1, 4, 6] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCStar,
"for List and Object",
[IsList,IsObject],
function(complex,face)

	local tmp;

	if(IsBound(SCIntFunc.SCStarOld)) then
		#fallback to homology package
		tmp:=face;
		if(not IsList(tmp)) then
			tmp:=[tmp];
		fi;
		return SCIntFunc.SCStarOld(complex,tmp);
	fi;

	Info(InfoSimpcomp,1,"SCStar: first argument must be of type SCPolyhedralComplexx. Fallback to homology package failed");
	return fail;
end);

InstallMethod(SCStar,
"for SCPolyhedralComplex and Object",
[SCIsPolyhedralComplex,IsObject],
function(complex,face)
	return SCStar(complex,[face]);
end);

InstallMethod(SCStar,
"for SCPolyhedralComplex and Object",
[SCIsPolyhedralComplex,IsList],
function(complex,face)

	local tmp, elements, facets, labels, lface;
	
	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCStar: complex lacks vertex labels.");
		return fail;
	fi;
	
	if not IsSubset(labels,face) then
		Info(InfoSimpcomp,1,"SCStar: face must be a face / non-face of complex.");
		return SCEmpty();
	fi;
	
	lface:=List(face,x->Position(labels,x));
	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;

	tmp:=[];
	for elements in facets do
			if IsSubset(elements,lface) then
				AddSet(tmp,elements);
			fi;
	od;

	if tmp=[] then
		tmp:=SCEmpty();
	else
		tmp:=SCFromFacets(SCIntFunc.RelabelSimplexList(tmp,labels));
	fi;
	
	if(SCName(complex)<>fail) then
		SCRename(tmp,Concatenation("star(",String(face),") in ",SCName(complex)));
	else
		SCRename(tmp,Concatenation("star(",String(face),")"));
	fi;
	
	return tmp;
end);


################################################################################
##<#GAPDoc Label="SCAntiStar">
## <ManSection>
## <Meth Name="SCAntiStar" Arg="complex,face"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise .</Returns>
## <Description>
## Computes the anti star of <Arg>face</Arg> (a face given as a list of vertices or a scalar interpreted as vertex) in <Arg>complex</Arg>, i. e. the complement of <Arg>face</Arg> in <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^2");     
## [ [ 3, "RP^2 (VT)" ], [ 262, "RP^2xS^1" ] ]
## gap> rp2:=SCLib.Load(last[1][1]);;
## gap> SCVertices(rp2);
## [1, 2, 3, 4, 5, 6]
## gap> SCAntiStar(rp2,1);
## gap> last.Facets;
## [ [ 2, 3, 4 ], [ 2, 4, 5 ], [ 2, 5, 6 ], [ 3, 4, 6 ], [ 3, 5, 6 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCAntiStar,
"for SCPolyhedralComplex and List",
[SCIsPolyhedralComplex,IsObject],
function(complex,face)
	return SCAntiStar(complex,[face]);
end);

InstallMethod(SCAntiStar,
"for SCPolyhedralComplex and List",
[SCIsPolyhedralComplex,IsList],
function(complex,face)

	local tmp, elements, facets, labels, lface;
	
	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCAntiStar: complex lacks vertex labels.");
		return fail;
	fi;
	
	if not IsSubset(labels,face) then
		Info(InfoSimpcomp,1,"SCAntiStar: face must be a face of complex.");
		return SCEmpty();
	fi;
	
	lface:=List(face,x->Position(labels,x));
	
	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;

	tmp:=[];
	for elements in facets do
			if Intersection(elements,lface)=[] then
				AddSet(tmp,elements);
			fi;
	od;

	if tmp=[] then
		tmp:=SCEmpty();
	else
		tmp:=SCFromFacets(SCIntFunc.RelabelSimplexList(tmp,labels));
	fi;
	
	if(SCName(complex)<>fail) then
		SCRename(tmp,Concatenation("ast(",String(face),") in ",SCName(complex)));
	else
		SCRename(tmp,Concatenation("ast(",String(face),")"));
	fi;
	
	return tmp;
end);



################################################################################
##<#GAPDoc Label="SCFillSphere">
## <ManSection>
## <Func Name="SCFillSphere" Arg="complex[, vertex]"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise .</Returns>
## <Description>
## Fills the given simplicial sphere <Arg>complex</Arg> by forming the suspension of the anti star of <Arg>vertex</Arg> over <Arg>vertex</Arg>. This is a triangulated <M>(d+1)</M>-ball with the boundary <Arg>complex</Arg>, see <Cite Key="Bagchi08LBTNormPseudoMnf" />. If the optional argument <Arg>vertex</Arg> is not supplied, the first vertex of <Arg>complex</Arg> is chosen.<P/>
## Note that it is not checked whether <Arg>complex</Arg> really is a simplicial sphere -- this has to be done by the user!
## <Example><![CDATA[
## gap> SCLib.SearchByName("S^4");
## gap> s:=SCLib.Load(last[1][1]);;
## gap> filled:=SCFillSphere(s);
## gap> SCHomology(filled);
## gap> SCCollapseGreedy(filled);
## gap> bd:=SCBoundary(filled);;
## gap> bd=s;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCFillSphere,
function(arg)

	local complex, vertex, tmp, elements, facets, labels, lvertex;

	if(Length(arg)<1 or Length(arg)>2) then
		Info(InfoSimpcomp,1,"SCFillSphere: first argument must be of type SCSimplicialComplex, optional second argument a vertex of that complex.");
		return fail;
	fi;
	
	complex:=arg[1];
	
	if(not SCIsSimplicialComplex(complex) and not SCIsNormalSurface(complex)) then
		Info(InfoSimpcomp,1,"SCFillSphere: first argument must be of type SCSimplicialComplex.");
		return fail;
	fi;
	
	labels:=SCVertices(complex);
	if(labels=fail or Length(labels)<2) then
		Info(InfoSimpcomp,1,"SCFillSphere: complex lacks vertex labels or is too small (<2 vertices).");
		return fail;
	fi;
	
	if(Length(arg)=2) then
		vertex:=arg[2];
	else
		vertex:=[labels[1]];
	fi;

	if(not IsList(vertex)) then
		lvertex:=[vertex];
	else
		lvertex:=vertex;
	fi;
	
	if not IsSubset(labels,lvertex) then
		Info(InfoSimpcomp,1,"SCFillSphere: vertex must be a vertex of the complex.");
		return SCEmpty();
	fi;
	
	lvertex:=List(lvertex,x->Position(labels,x));
	
	facets:=SCFacetsEx(complex);
	if facets=fail then
		return fail;
	fi;

	#form ast(lvertex)*lvertex 
	tmp:=[];
	for elements in facets do
			if Intersection(elements,lvertex)=[] then
				AddSet(tmp,Union(elements,lvertex));
			fi;
	od;

	if tmp=[] then
		tmp:=SCEmpty();
	else
		tmp:=SCFromFacets(SCIntFunc.RelabelSimplexList(tmp,labels));
	fi;
	
	if(SCName(complex)<>fail) then
		SCRename(tmp,Concatenation("FilledSphere(",SCName(complex),") at vertex ", String(lvertex)));
	else
		SCRename(tmp,Concatenation("FilledSphere at vertex ",String(lvertex)));
	fi;
	
	return tmp;
end);


#reduce given face lattice
SCIntFunc.reduceFaceLattice:=function(faces)
	local i,reduced,maxf;
	
	if(faces=[]) then
		return [];
	fi;
	
	reduced:=[];
	reduced[Length(faces)]:=ShallowCopy(faces[Length(faces)]);
	
	for i in Reversed([1..Length(faces)-1]) do
		reduced[i]:=[];
		maxf:=Union(List(faces[i+1],x->Combinations(x,i)));
		reduced[i]:=ShallowCopy(Difference(faces[i],maxf));
	od;

	return reduced;
end;



################################################################################
##<#GAPDoc Label="SCSpan">
## <ManSection>
## <Meth Name="SCSpan" Arg="complex,subset"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the reduced face lattice of all faces of a simplicial complex <Arg>complex</Arg> that are spanned by <Arg>subset</Arg>, a subset of the set of vertices of <Arg>complex</Arg>. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCVertices(c);
## [1, 2, 3, 4, 5, 6, 7, 8]
## gap> span:=SCSpan(c,[1,2,3,4]);
## gap> span.Facets;
## [[1, 3], [1, 4], [2, 3], [2, 4]]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SC([[1,2],[1,4,5],[2,3,4]]);;
## gap> span:=SCSpan(c,[2,3,5]);
## gap> SCFacets(span);
## [[2, 3], [5]]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCSpan,
"for SCSimplicialComplex and List",
[SCIsSimplicialComplex,IsList],
function(complex,subset)

	local faces,span,k,labels;

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCSpan: complex lacks vertex labels.");
		return fail;
	fi;	
	
	faces:=SCFaceLattice(complex);
	if faces=fail then
		return fail;
	fi;

	span:=SCFromFacets(
		Union(
			SCIntFunc.reduceFaceLattice(
				List([1..Length(faces)],k->SCIntFunc.DeepCopy(
					Filtered(faces[k],x->IsSubset(subset,x))
				))
			)
		));
	
	if(SCName(complex)<>fail) then
		SCRename(span,Concatenation("span(",String(subset),") in ",SCName(complex)));
	else
		SCRename(span,Concatenation("span(",String(subset),")"));
	fi;
	
	return span;	
end);


################################################################################
##<#GAPDoc Label="SCIsomorphismEx">
## <ManSection>
## <Meth Name="SCIsomorphismEx" Arg="complex1,complex2"/>
## <Returns> a list of pairs of vertex labels or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns an isomorphism of simplicial complex <Arg>complex1</Arg> to simplicial complex <Arg>complex2</Arg> in the standard labeling if they are combinatorially isomorphic, <K>false</K> otherwise. If the <M>f</M>-vector and the Altshuler-Steinberg determinant of <Arg>complex1</Arg> and <Arg>complex2</Arg> are equal, the internal function <C>SCIntFunc.SCComputeIsomorphismsEx(complex1,complex2,true)</C> is called.
## <Example><![CDATA[
## gap> c1:=SC([[11,12,13],[11,12,14],[11,13,14],[12,13,14]]);;
## gap> c2:=SCBdSimplex(3);;
## gap> SCIsomorphism(c1,c2);
## [ [ 11, 1 ], [ 12, 2 ], [ 13, 3 ], [ 14, 4 ] ]
## gap> SCIsomorphismEx(c1,c2);
## [ [ [ 1, 1 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsomorphismEx,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local FA,FB,DA,DB,iso,i,facets1,facets2,sc1,sc2;

	sc1:=SCIsStronglyConnected(complex1);
	sc2:=SCIsStronglyConnected(complex2);
	if sc1 = fail or sc2 = fail then
		return fail;
	fi;
	
	if not sc1 or not sc2 then
		Info(InfoSimpcomp,1,"SCIsomoprhismEx: complexes must be strongly connected.");
		return fail;
	fi;
	
	#f vector test
	FA:=SCFVector(complex1);
	FB:=SCFVector(complex2);

	if(FA=fail or FB=fail) then
		Info(InfoSimpcomp,1,"SCIsomorphismEx: can't compute f-vector.");
		return fail;
	fi;

	if FA = [] then
		Info(InfoSimpcomp,1,"SCIsomoprhismEx: complex is empty.");
		return [];
	fi;
	
	if Size(FA) = 1 and FA[1] = FB[1] then
		iso:=[];
		facets1:=SCLabels(complex1);
		facets2:=SCLabels(complex2);
		if facets1 = fail or facets2 = fail then
			return fail;
		fi;
		
		for i in [1..FA[1]] do 
			Add(iso,[facets1[i],facets2[i]]);
		od;
		return [iso];
	fi;
	
	if(not FA=FB) then
		return false;
	fi;

	#as-det test
	DA:=SCAltshulerSteinberg(complex1);
	DB:=SCAltshulerSteinberg(complex2);

	if(DA=fail or DB=fail) then
		Info(InfoSimpcomp,1,"SCIsomorphismEx: can't compute AS-determinant.");
		return fail;
	fi;

	if(not DA=DB) then
		return false;
	fi;	
	
	#equality check
	facets1:=SCFacetsEx(complex1);
	facets2:=SCFacetsEx(complex2);
	if facets1 = fail or facets2 = fail then
		return fail;
	fi;
	
	if(facets1=facets2) then
		iso:=[];
		
		for i in [1..FA[1]] do
			Add(iso,[i,i]);
		od;
		
		return [iso];
	fi;
	
	if(not SCIsPseudoManifold(complex1) or not SCIsPseudoManifold(complex2)) then
		Info(InfoSimpcomp,1,"SCIsomorphismEx: both arguments must have the weak pseudomanifold property.");
		return fail;
	fi;

	iso:=SCIntFunc.SCComputeIsomorphismsEx(complex1,complex2,true);
	
	if iso=[] then
		return false;
	else
		return iso;
	fi;
	
end);



################################################################################
##<#GAPDoc Label="SCIsomorphism">
## <ManSection>
## <Meth Name="SCIsomorphism" Arg="complex1,complex2"/>
## <Returns> a list of pairs of vertex labels or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns an isomorphism of simplicial complex <Arg>complex1</Arg> to simplicial complex <Arg>complex2</Arg> in the standard labeling if they are combinatorially isomorphic, <K>false</K> otherwise. Internally calls <Ref Meth="SCIsomorphismEx"/>.
## <Example><![CDATA[
## gap> c1:=SC([[11,12,13],[11,12,14],[11,13,14],[12,13,14]]);;
## gap> c2:=SCBdSimplex(3);;
## gap> SCIsomorphism(c1,c2);
## [ [ 11, 1 ], [ 12, 2 ], [ 13, 3 ], [ 14, 4 ] ]
## gap> SCIsomorphismEx(c1,c2);
## [ [ [ 1, 1 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsomorphism,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local isos,empty1,empty2,sc1,sc2;
	
	empty1:=SCIsEmpty(complex1);
	empty2:=SCIsEmpty(complex2);
	if empty1 = fail or empty2 = fail then
		return fail;
	fi;
	
	if empty1 or empty2 then
		Info(InfoSimpcomp,1,"SCIsomoprhism: complex is empty.");
		return [];
	fi;
	
	sc1:=SCIsStronglyConnected(complex1);
	sc2:=SCIsStronglyConnected(complex2);
	if sc1 = fail or sc2 = fail then
		return fail;
	fi;
	
	if not sc1 or not sc2 then
		Info(InfoSimpcomp,1,"SCIsomoprhism: complexes must be strongly connected.");
		return fail;
	fi;
	
	isos:=SCIsomorphismEx(complex1,complex2);
	
	if(isos=fail) then
		return fail;
	elif(isos=false or isos=[]) then
		return [];
	else
		isos:=List(isos[1],x->[SCIntFunc.RelabelSimplexList([[x[1]]],SCVertices(complex1))[1][1],SCIntFunc.RelabelSimplexList([[x[2]]],SCVertices(complex2))[1][1]]);
		return isos;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCIsIsomorphic">
## <ManSection>
## <Meth Name="SCIsIsomorphic" Arg="complex1,complex2"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The function returns <K>true</K>, if the simplicial complexes <Arg>complex1</Arg> and <Arg>complex2</Arg> are combinatorially isomorphic, <K>false</K> if not.
## <Example><![CDATA[
## gap> c1:=SC([[11,12,13],[11,12,14],[11,13,14],[12,13,14]]);;
## gap> c2:=SCBdSimplex(3);;
## gap> SCIsIsomorphic(c1,c2);
## true
## gap> c3:=SCBdCrossPolytope(3);;
## gap> SCIsIsomorphic(c1,c3);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsIsomorphic,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local isomorphism,sc1,sc2;
	
	if SCIsEmpty(complex1) and SCIsEmpty(complex2) then
		return true;
	elif SCIsEmpty(complex1) or SCIsEmpty(complex2) then
		return false;
	fi;

	if HasSCExportIsoSig(complex1) and HasSCExportIsoSig(complex2) then
		return SCExportIsoSig(complex1) = SCExportIsoSig(complex2); 
	fi;
	
	sc1:=SCIsStronglyConnected(complex1);
	sc2:=SCIsStronglyConnected(complex2);
	if sc1 = fail or sc2 = fail then
		return fail;
	fi;
	
	if not sc1 or not sc2 then
		Info(InfoSimpcomp,1,"SCIsIsomoprhic: complexes must be strongly connected.");
		return fail;
	fi;
	
	isomorphism:=SCIsomorphismEx(complex1,complex2);
	
	if(isomorphism=fail) then
		return fail;
	else
		if isomorphism=false or isomorphism=[] then
			return false;
		else
			return true;
		fi;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCCone">
## <ManSection>
## <Func Name="SCCone" Arg="complex, apex"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If the second argument is passed every facet of the simplicial complex <Arg>complex</Arg> is united with <Arg>apex</Arg>. If not, an arbitrary vertex label <M>v</M> is used (which is not a vertex of <Arg>complex</Arg>). In the first case the vertex labeling remains unchanged. In the second case the function returns the new complex in the standard vertex labeling from <M>1</M> to <M>n+1</M> and the apex of the cone is <M>n+1</M>.<P/>
## If called with a facet list instead of a <C>SCSimplicialComplex</C> object and <Arg>apex</Arg> is not specified, internally falls back to the homology package <Cite Key="Dumas04Homology" />, if available. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("RP^3");
## [ [ 45, "RP^3" ], [ 114, "RP^3=L(2,1) (VT)" ], 
##   [ 237, "(S^2xS^1)#RP^3" ], [ 238, "(S^2~S^1)#RP^3" ], 
##   [ 263, "(S^2xS^1)#2#RP^3" ], [ 264, "(S^2~S^1)#2#RP^3" ], 
##   [ 366, "RP^3#RP^3" ], [ 382, "RP^3=L(2,1) (VT)" ], 
##   [ 399, "(S^2~S^1)#3#RP^3" ], [ 402, "(S^2xS^1)#3#RP^3" ], 
##   [ 417, "RP^3=L(2,1) (VT)" ], [ 502, "(S^2~S^1)#4#RP^3" ], 
##   [ 503, "(S^2xS^1)#4#RP^3" ], [ 531, "(S^2xS^1)#5#RP^3" ], 
##   [ 532, "(S^2~S^1)#5#RP^3" ] ]
## gap> rp3:=SCLib.Load(last[1][1]);;
## gap> rp3.F;
## [11, 51, 80, 40]
## gap> cone:=SCCone(rp3);;
## gap> cone.F;
## [12, 62, 131, 120, 40]
## ]]></Example>
## <Example><![CDATA[
## gap> s:=SCBdSimplex(4)+12;;
## gap> s.Facets;             
## [ [ 13, 14, 15, 16 ], [ 13, 14, 15, 17 ], [ 13, 14, 16, 17 ], 
##   [ 13, 15, 16, 17 ], [ 14, 15, 16, 17 ] ]
## gap> cc:=SCCone(s,13);;    
## #I  SCCone: second argument must not be a vertex label of first argument.
## gap> cc:=SCCone(s,12);;
## gap> cc.Facets;
## [ [ 12, 13, 14, 15, 16 ], [ 12, 13, 14, 15, 17 ], [ 12, 13, 14, 16, 17 ], 
##   [ 12, 13, 15, 16, 17 ], [ 12, 14, 15, 16, 17 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCCone,
function(arg)
	local maxv,facets,verts,cone,f,cc,complex,apex,labels;

	if Size(arg) = 1 then
		complex:=arg[1];
	elif Size(arg) = 2 then
		complex:=arg[1];
		apex:=arg[2];
	else
		Info(InfoSimpcomp,1,"SCCone: number of arguments must be one or two.");
		return fail;
	fi;
	
	if(not SCIsSimplicialComplex(complex)) then
		#fallback to homology package
		if(IsBound(SCIntFunc.SCConeOld)) then
			return SCIntFunc.SCConeOld(complex);
		fi;
		
		Info(InfoSimpcomp,1,"SCCone: first argument must be of type SCSimplicialComplex.");
		return fail;
	fi;
	
	labels:=SCVertices(complex);
	if labels = fail then
		return fail;
	fi;
	if IsBound(apex) and apex in labels then
		Info(InfoSimpcomp,1,"SCCone: second argument must not be a vertex label of first argument.");
		return fail;
	fi;
	
	if SCIsEmpty(complex) then
		if IsBound(apex) then
			cc:=SC([[apex]]);
		else
			cc:=SC([[1]]);
		fi;		
		SCRename(cc,"cone over empty complex");
		return cc;
	fi;
	
	if IsBound(apex) then
		facets:=SCFacets(complex);
		if facets = fail then
			return fail;
		fi;
		
		cone:=List(facets,x->Union(x,[apex]));
		cc:=SCFromFacets(cone);
		
		if(SCName(complex)<>fail) then
			SCRename(cc,Concatenation("cone over ",SCName(complex)," with apex ",String(apex)));
		fi;	
		
	else

		facets:=SCFacetsEx(complex);
		verts:=SCSkelEx(complex,0);
		if(facets=fail or verts=fail) then
			return fail;
		fi;
		
		maxv:=Length(verts);
		
		cone:=[];
		for f in facets do
			Add(cone,Union(f,[maxv+1]));
		od;
		
		cc:=SCFromFacets(cone);
		
		if(SCName(complex)<>fail) then
			SCRename(cc,Concatenation("cone over ",SCName(complex)));
		fi;	

	fi;
	return cc;
end);

################################################################################
##<#GAPDoc Label="SCClose">
## <ManSection>
## <Func Name="SCClose" Arg="complex [, apex]"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Closes a simplicial complex <Arg>complex</Arg> by building a cone over its boundary. If <Arg>apex</Arg> is specified it is assigned to the apex of the cone and the original vertex labeling of <Arg>complex</Arg> is preserved, otherwise an arbitrary vertex label is chosen and <Arg>complex</Arg> is returned in the standard labeling. 
## <Example><![CDATA[
## gap> s:=SCSimplex(5);;                                       
## gap> b:=SCSimplex(5);;
## gap> s:=SCClose(b,13);;
## gap> SCIsIsomorphic(s,SCBdSimplex(6));                       
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCClose,
function(arg)
	local facets,cone,c,apex,labels,bd,complex,relabel;

	if Size(arg) = 1 then
		complex:=arg[1];
	elif Size(arg) = 2 then
		complex:=arg[1];
		apex:=arg[2];
	else
		Info(InfoSimpcomp,1,"SCCone: number of arguments must be one or two.");
		return fail;
	fi;
	
	labels:=SCLabels(complex);
	if labels = fail then
		return fail;
	fi;
	
	if IsBound(apex) then
		if apex in labels then
			Info(InfoSimpcomp,1,"SCCone: second argument must not be a vertex label of first argument.");
			return fail;
		fi;
		bd:=SCBoundary(complex);
		if bd = fail then
			return fail;
		fi;
		if SCIsEmpty(bd) then
			return complex;
		fi;
		cone:=SCCone(bd,apex);
		return Union(cone,complex);		
	else
		c:=SCCopy(complex);
		relabel:=SCRelabelStandard(c);
		if relabel <> true then
			Info(InfoSimpcomp,1,"SCCone: relabeling vertices failed.");
			return fail;
		fi;
		bd:=SCBoundary(complex);
		if bd = fail then
			return fail;
		fi;
		if SCIsEmpty(bd) then
			return complex;
		fi;
		cone:=SCCone(bd,Size(labels)+1);
		return Union(cone,complex);		
	fi; 
end);

################################################################################
##<#GAPDoc Label="SCShellingExt">
## <ManSection>
## <Meth Name="SCShellingExt" Arg="complex, all,checkvector"/>
## <Returns> a list of facet lists (if <Arg>checkvector = []</Arg>) or <K>true</K> or <K>false</K> (if <Arg>checkvector</Arg> is not empty), <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure of dimension <M>d</M>, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary (cf. <Ref Meth="SCBoundary"/>).<P/>
## An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>.<P/>
## If <Arg>all</Arg> is set to <K>true</K> all possible shellings of <Arg>complex</Arg> are computed. If <Arg>all</Arg> is set to <K>false</K>, at most one shelling is computed.<P/>
## Every shelling is represented as a permuted version of the facet list of <Arg>complex</Arg>. The list <Arg>checkvector</Arg> encodes a shelling in a shorter form. It only contains the indices of the facets. If an order of indices is assigned to <Arg>checkvector</Arg> the function tests whether it is a valid shelling or not.<P/>
## See <Cite Key="Ziegler95LectPolytopes"/>, <Cite Key="Pachner87KonstrMethKombHomeo" /> to learn more about shellings.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(4);;
## gap> c:=SCDifference(c,SC([c.Facets[1]]));; # bounded version
## gap> all:=SCShellingExt(c,true,[]);;
## gap> Size(all);                                  
## gap> all[1];
## gap> all:=SCShellingExt(c,false,[]);
## gap> all:=SCShellingExt(c,true,[1..4]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCShellingExt,
"for SCSimplicialComplex and Bool and List",
[SCIsSimplicialComplex,IsBool,IsList],
function(complex,all,checkvector)
	local getFacetNeighborsIdx,complexStronglyConnectedShelling,
		computeBoundaryShelling,markBoundaryFactesShelling,isValidNextShellingFacet,
		computeShellingBt,shellings,killed,killedn,i,idx,sc,sconn,
		shellingVectorToFacetList,checkShellingValid,bd,pure;

	shellingVectorToFacetList:=function(sc,sv)
		local flist,idxlist,i;

		flist:=[];
		idxlist:=Permuted([1..Length(sv)],SortingPerm(sv));
		for i in [1..Length(idxlist)] do
			flist[i]:=sc[idxlist[i]];
		od;

		return flist;
	end;

	checkShellingValid:=function(sc,shellingvec)
		return SCShellingExt(sc,false,shellingvec);
	end;

	getFacetNeighborsIdx:=function(sc,sidx)
		local side,sides,t,neighbors,s;

		s:=sc[sidx];

		sides:=Combinations(s,Length(s)-1);
		neighbors:=[];

		for t in sc do
			if(t=s) then continue; fi;
			for side in sides do
				if(IsSubset(t,side)) then
					AddSet(neighbors,Position(sc,t));
				fi;
			od;
		od;

		return neighbors;
	end;

	complexStronglyConnectedShelling:=function(sc,killed)
		local seen,curfacet,stack,neighbors,n,i;

		seen:=ShallowCopy(killed);

		if(Position(seen,0)=fail) then
			return false;
		fi;

		curfacet:=Position(seen,0);
		seen[curfacet]:=1;
		stack:=[];

		repeat
			neighbors:=Filtered(getFacetNeighborsIdx(sc,curfacet),x->killed[x]=0);
			for n in neighbors do
				if(seen[n]=0) then
					seen[n]:=1;
					UniteSet(stack,Filtered(getFacetNeighborsIdx(sc,n),x->seen[x]=0 and killed[x]=0));
				fi;
			od;
			if(stack<>[]) then
				curfacet:=stack[1];
				RemoveSet(stack,stack[1]);
				seen[curfacet]:=1;
			else
				curfacet:=0;
			fi;
		until(curfacet=0);

		return not 0 in seen;
	end;


	computeBoundaryShelling:=function(sc,killed)
		local dim,faces,s,sf,countf,p,bd,i,sidx;

		if(Length(sc)=0) then
			return [];
		fi;

		dim:=Length(sc[1]);

		faces:=[];
		for s in [1..Length(sc)] do
			if(killed[s]<>0) then continue; fi;
			UniteSet(faces,Combinations(sc[s],dim-1));
		od;

		countf:=ListWithIdenticalEntries(Length(faces),0);
		for sidx in [1..Length(sc)] do
			if(killed[sidx]<>0) then continue; fi;
			s:=sc[sidx];
			for sf in Combinations(s,dim-1) do
				p:=Position(faces,sf);
				countf[p]:=countf[p]+1;
			od;
		od;

		bd:=[];
		for i in [1..Length(countf)] do
			if(countf[i]=1) then
				AddSet(bd,faces[i]);
			fi;
		od;

		return bd;
	end;

	markBoundaryFactesShelling:=function(sc,killed)
		local bd,bdfacets,s,t;

		bdfacets:=ListWithIdenticalEntries(Length(sc),0);
		bd:=computeBoundaryShelling(sc,killed);

		for s in bd do
			for t in [1..Length(sc)] do
				if(killed[t]<>0) then continue; fi;
				if(IsSubset(sc[t],s)) then
					bdfacets[t]:=1;
				fi;
			od;
		od;

		return bdfacets;
	end;

	isValidNextShellingFacet:=function(sc,killed,cur)
		local i,j,intersection,alllen,prev,span,failed,dim,done;

		failed:=0;
		intersection:=[];
		for i in [1..Length(killed)] do
			if(killed[i]=0) then continue; fi;
			if(Intersection(sc[i],sc[cur])<>[]) then
				AddSet(intersection,Intersection(sc[cur],sc[i]));
			fi;
		od;

		#consolidate simplices
		done:=0;
		while(done=0) do
			done:=1;
			for i in [1..Length(intersection)] do
				for j in [1..Length(intersection)] do
					if(j=i) then continue; fi;
					if(IsSubset(intersection[i], intersection[j])) then
						RemoveSet(intersection,intersection[j]);
						done:=0;
						break;
					fi;
				od;

				if(done=0) then break; fi;
			od;
		od;

		dim:=List(intersection,Length)-1;
		
		if(Size(Set(dim))<>1) then
			#intersection not pure
			return false;
		else
			dim:=dim[1];
		fi;
		
		if(dim=Length(sc[1])-2) then
			#always valid here since any ordering of facets of simplex is a shelling
			return true;
		else
			return false;
		fi;
	end;

	computeShellingBt:=function(sc,killedn,killed,shellings,all)
		local i,bd,lkilled;

		if(not 0 in killed) then
			AddSet(shellings,ShallowCopy(killed));
			return true;
		fi;

		if(not complexStronglyConnectedShelling(sc,killed)) then

			return false;
		fi;

		bd:=markBoundaryFactesShelling(sc,killed);

		lkilled:=ShallowCopy(killed);
		for i in [1..Length(bd)] do
			if(bd[i]=1) then
				if(killedn=1 or isValidNextShellingFacet(sc,killed,i)) then
					#backtrack
					lkilled[i]:=killedn;
					if(computeShellingBt(sc,killedn+1,lkilled,shellings,all) and not all) then
						return true;
					fi;
					lkilled[i]:=0;
				fi;
			fi;
		od;

		return false;
	end;

	sc:=SCFacetsEx(complex);
	sconn:=SCIsStronglyConnected(complex);
	pure:=SCIsPure(complex);
	bd:=SCHasBoundary(complex);
	if sc = fail or sconn = fail or pure = fail or bd = fail then
		Info(InfoSimpcomp,1,"SCShellingExt: invalid arguments. complex must be a pure strongly connected simplicial complex with boundary.");
		return fail;
	fi;

	if(bd=false or sconn=false or pure=false) then
		Info(InfoSimpcomp,1,"SCShellingExt: invalid arguments. complex must be a pure strongly connected simplicial complex with boundary.");
		return fail;
	fi;

	if(checkvector=[]) then
		#compute shelling(s)
		shellings:=[];
		computeShellingBt(sc,1,ListWithIdenticalEntries(Length(sc),0),shellings,all);

		if(shellings<>[] and not ForAll(shellings,x->checkShellingValid(complex,x)=true)) then
			Info(InfoSimpcomp,1,"SCShellingExt: internal error, invalid shelling.");
			return fail;
		fi;

		return List(shellings,x->shellingVectorToFacetList(sc,x));
	else
		#check shelling vector for validity
		killed:=ListWithIdenticalEntries(Length(sc),0);
		killedn:=1;

		if(not complexStronglyConnectedShelling(sc,killed)) then
			return false;
		fi;

		for idx in [1..Length(checkvector)] do
			i:=Position(checkvector,idx);
			if(idx>1 and not isValidNextShellingFacet(sc,killed,i)) then
				Info(InfoSimpcomp,1,"SCShellingExt: ",i," is not a valid shelling facet.");
				return false; #no valid shelling
			else
				killed[i]:=killedn;
				killedn:=killedn+1;
			fi;
			if(not idx=Length(checkvector) and not complexStronglyConnectedShelling(sc,killed)) then
				Info(InfoSimpcomp,1,"SCShellingExt: complex not strongly connected.");
				return false;
			fi;
		od;
		return true;
	fi;
end);

################################################################################
##<#GAPDoc Label="SCShelling">
## <ManSection>
## <Meth Name="SCShelling" Arg="complex"/>
## <Returns> a facet list or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary (cf. <Ref Meth="SCBoundary"/>).<P/>
## An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>.<P/>
## The function checks whether <Arg>complex</Arg> is shellable or not. In the first case a permuted version of the facet list of <Arg>complex</Arg> is returned encoding a shelling of <Arg>complex</Arg>, otherwise <K>false</K> is returned.<P/>
## Internally calls <Ref Meth="SCShellingExt"/><C>(complex,false,[]);</C>. To learn more about shellings see <Cite Key="Ziegler95LectPolytopes"/>, <Cite Key="Pachner87KonstrMethKombHomeo"/>.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4]]);;
## gap> SCShelling(c);
## [[1, 2, 3], [1, 2, 4], [1, 3, 4]]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCShelling,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local shable;
	
	shable:=SCIsShellable(complex);
	if(shable=true) then
		return SCShellingExt(complex,false,[]);
	else
		return shable;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCShellings">
## <ManSection>
## <Meth Name="SCShellings" Arg="complex"/>
## <Returns> a list of facet lists upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The simplicial complex <Arg>complex</Arg> must be pure, strongly connected and must fulfill the weak pseudomanifold property with non-empty boundary  (cf. <Ref Meth="SCBoundary"/>).<P/>
## An ordering <M>(F_1, F_2, \ldots , F_r)</M> on the facet list of a simplicial complex is a shelling if and only if <M>F_i \cap (F_1 \cup \ldots \cup F_{i-1})</M> is a pure simplicial complex of dimension <M>d-1</M> for all <M>i = 1, \ldots , r</M>.<P/>
## The function checks whether <Arg>complex</Arg> is shellable or not. In the first case a list of permuted facet lists of <Arg>complex</Arg> is returned containing all possible shellings of <Arg>complex</Arg>, otherwise <K>false</K> is returned.<P/>
## Internally calls <Ref Meth="SCShellingExt"/><C>(complex,true,[]);</C>. To learn more about shellings see <Cite Key="Ziegler95LectPolytopes"/>, <Cite Key="Pachner87KonstrMethKombHomeo"/>.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[1,2,4],[1,3,4]]);;
## gap> SCShellings(c);
## [[[1, 2, 3], [1, 2, 4], [1, 3, 4]],
##   [[1, 2, 3], [1, 3, 4], [1, 2, 4]],
##   [[1, 2, 4], [1, 2, 3], [1, 3, 4]],
##   [[1, 3, 4], [1, 2, 3], [1, 2, 4]],
##   [[1, 2, 4], [1, 3, 4], [1, 2, 3]],
##   [[1, 3, 4], [1, 2, 4], [1, 2, 3]] 
##]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCShellings,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	return SCShellingExt(complex,true,[]);
end);

