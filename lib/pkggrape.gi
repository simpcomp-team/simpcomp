################################################################################
##
##  simpcomp / pkggrape.gi
##
##  Loaded when `GRAPE' package is available
##
##  $Id$
##
################################################################################
InstallMethod(SCAutomorphismGroup,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
	function(complex)

	local i, j, k, idx, dg, edges, gamma, Gprime, G, pm, sc, structure, g, bd, dim, v,
		stars, imstars, facets, pfacets, iso, allisos, verts, gens, gapidx;
	
	if not IsBoundGlobal("AutGroupGraph") or not IsBoundGlobal("EdgeOrbitsGraph") then
		G:=SCAutomorphismGroupInternal(complex);
		if G = fail then
			return fail;
		else
			return G;
		fi;
	fi;

	pm:=SCIsPseudoManifold(complex);
	if(pm=fail) then
		return fail;
	elif(pm=false) then
		Info(InfoSimpcomp,1,"SCAutomorphismGroup: can only compute automorphism group for pseudomanifolds.");
		return fail;
	fi;

	facets:=SCFacetsEx(complex);
	if facets = fail then
		return fail;
	fi;

	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;

	v:=SCNumFaces(complex,0);
	if v = fail then
		return fail;
	fi;

	#identify simplices
	if v = Size(facets) and pm = true and dim = v-2 then
		G:=SymmetricGroup(v);
		structure:=StructureDescription(G);
		#SetName(G,structure);
		SetSCAutomorphismGroup(complex,G);
		SetSCAutomorphismGroupSize(complex,G);
		SetSCAutomorphismGroupTransitivity(complex,Transitivity(G));
		SetSCAutomorphismGroupStructure(complex,structure);
		return G;
	fi;

	Info(InfoSimpcomp,3,"SCAutomorphismGroup: compute dual graph.");
	dg:=SCDualGraph(complex);
	if dg = fail then
		return fail;
	fi;

	edges:=ShallowCopy(SCFacets(dg));
	if edges = fail then
		return fail;
	fi;

	verts:=SCVertices(dg);
	if verts = fail then
		return fail;
	fi;
	
	for i in [1..Size(edges)] do
		Add(edges,Reversed(edges[i]));
	od;
	
	Info(InfoSimpcomp,3,"SCAutomorphismGroup: compute automorphism group of dual graph.");
	gamma:=EdgeOrbitsGraph(Group(()),edges,Size(verts));
	Gprime:=AutGroupGraph(gamma);
	Info(InfoSimpcomp,3,"SCAutomorphismGroup: found ",Order(Gprime)," automorphisms of dual graph.");
	if(Gprime=fail) then
		Info(InfoSimpcomp,1,"SCAutomorphismGroup: error calculating automorphism group via GRAPE.");
		return fail;
	fi;
	
	SetSCAutomorphismGroup(dg,Gprime);
	SetSCAutomorphismGroupSize(dg,Size(Gprime));
	SetSCAutomorphismGroupTransitivity(dg,Transitivity(Gprime));
	SetSCAutomorphismGroupStructure(dg,StructureDescription(Gprime));
	SetSCDualGraph(complex,dg);
	
	stars:=[];
	for i in [1..v] do
		stars[i]:=[];
	od;
	for j in [1..Size(facets)] do
			for k in facets[j] do
				#idx[k][j]:=1;
				Add(stars[k],j);
			od;
	od;
	
	Info(InfoSimpcomp,3,"SCAutomorphismGroup: determine automorphism group of complex.");

	# for all automorphisms of dual graph
	G:=Group(());
	allisos:=[];
	gens:=[];
	for g in Gprime do
		if(g in G) then
			continue;
		fi;
		
		imstars:=List(stars,x->Set(List(x,y->y^g)));
		
		iso:=[];
		for j in [1..Size(stars)] do
			i:=Position(stars,imstars[j]);
			if i <> fail then
				iso[j]:=[j,i];
			else
				iso:=fail;
				break;
			fi;
		od;
		
		if iso <> fail then
			Add(gens,g);
                        if gens = [] then
                          G:=Group(());
                        else
			  G:=Group(gens);
                        fi;
			Add(allisos,iso);
		fi;
	od;

	if(allisos<>[] and allisos<>[[]]) then	
		allisos:=Set(allisos);
		G:=Group(List(List(allisos,SCIntFunc.PairToList),PermList));
	else
		G:=Group(());
	fi;

	Info(InfoSimpcomp,3,"SCAutomorphismGroup: found ",Order(G)," automorphisms of complex, determine structure of group.");

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
	#SetName(G,structure);
	SetSCAutomorphismGroupStructure(complex,structure);
	
	return G;
end);

