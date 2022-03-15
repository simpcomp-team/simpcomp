###############################################################################
##
##  simpcomp / isosig.gi
##
##  Functions to compute the isomorphism signature of a complex
##
##  $Id$
##
################################################################################

################################################################################
##<#GAPDoc Label="SCExportIsoSig">
## <ManSection>
## <Meth Name="SCExportIsoSig" Arg="c"/>
## <Returns>string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the isomorphism signature of a closed, strongly connected weak 
## pseudomanifold. The isomorphism signature is stored as an attribute of the
## complex.
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(3,9);;
## gap> s:=SCExportIsoSig(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCExportIsoSig,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)
	local minl, i, j, k, n, nn, d, neighbors, facets, perm, l, queue, ctr, 
		ctr2, ctr3, labeling, current, face, s, isosig, done, next, 
		addNextValue;

	if SCIsEmpty(c) then
		return ".";
	fi;

	if SCHasBoundary(c) or not SCIsStronglyConnected(c) or not SCIsPseudoManifold(c) then
		Info(InfoSimpcomp,1,"SCExportIsoSig: argument must be a strongly connected closed pseudomanifold.");
		return fail;
	fi;

	addNextValue:=function(val)
		local lut,str,ctr,prefix;
		lut := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ)!@#$%^&*(+.";
		str:="";
		if val = 0 then
			Add(str,lut[64]);
			return str;
		elif val > 0 and val < 64 then
			Add(str,lut[val]);
			return str;
		else
			ctr:=0;
			while val > 0 do
				ctr:=ctr+1;
				Add(str,lut[((val-1) mod 64)+1]);
				val := Int(val/64);
			od;
			prefix := ShallowCopy(String(ctr));
			str := Reversed(str);
			Append(prefix,str);
			return prefix;
		fi;
	end;

	facets := SCFacetsEx(c);
	if facets = fail then
		return fail;
	fi;
	n := Size(facets);
	s := Size(facets[1]);
	# build list of neighbors
	neighbors := [];
	for i in [1..n] do
		neighbors[i]:=[];
		for j in [1..n] do
			if i = j then continue; fi;
			if Size(Intersection(facets[i],facets[j])) = s-1 then
				Add(neighbors[i],j);
			fi;
		od;
	od;
	minl := [];
	for i in [1..n] do
		for perm in PermutationsList(facets[i]) do
			# for each "canonical labeling seed" calculate signature
			l := [];
			labeling := perm;
			queue := [i];
			done := [1];
			ctr := 0;
			ctr2 := 0;
			ctr3 := 0;
			next := false;
			while ctr2 < n-1 do
				ctr := ctr+1;
				current := queue[ctr];
				for j in labeling do
					if not j in facets[current] then continue; fi;
					face := ShallowCopy(facets[current]);
					Remove(face,Position(face,j));
					Sort(face);
					for nn in neighbors[current] do
						if nn in queue then continue; fi;
						if IsSubset(facets[nn],face) then
							Add(queue,nn);
							Add(done,0);
							break;
						fi;
					od;
					for k in neighbors[current] do
						if IsSubset(facets[k],face) then
							ctr3 := ctr3 + 1;
							if done[Position(queue,k)] = 1 then
								Add(l,0);
								continue;
							fi;
							d := Difference(facets[k],face)[1];
							if not d in labeling then
								Add(labeling,d);
								Add(l,Size(labeling));
								ctr2:=ctr2+1;
							else
								Add(l,Position(labeling,d));
								ctr2:=ctr2+1;
							fi;
							done[Position(queue,k)] := 1;
							if minl <> [] and l[ctr3] > minl[ctr3] then
								next:=true;
								break;
							elif minl <> [] and l[ctr3] < minl[ctr3] then
								minl := [];
							fi;
						fi;
					od;
					if next then
						break;
					fi;
				od;
				if next then
					break;
				fi;
			od;
			if not next and (minl = [] or l < minl) then
				minl := l;
			fi;
		od;
	od;
	isosig:="";
	# store dimension
	Append(isosig,addNextValue(s));
	# for first d facets skip is always zero: omit these zeros
	for i in [1..s] do
		Append(isosig,addNextValue(minl[i]));
	od;
	# store rest of minl
	ctr2 := 0;
	for i in [s+1..Size(minl)] do
		if minl[i] = 0 then 
			# if skip, count number of skips
			ctr2 := ctr2+1;
		else
			# add skip and next value to isosig
			Append(isosig,addNextValue(ctr2));
			Append(isosig,addNextValue(minl[i]));
			ctr2 := 0;
		fi;
	od;
	return isosig;
end);


################################################################################
##<#GAPDoc Label="SCExportToString">
## <ManSection>
## <Func Name="SCExportToString" Arg="c"/>
## <Returns>string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes one string representation of a closed and strongly connected weak 
## pseudomanifold. Compare <Ref Func="SCExportIsoSig" />, which returns the
## lexicographically minimal string representation.
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(3,9);;
## gap> s:=SCExportToString(c); time;
## gap> s:=SCExportIsoSig(c); time;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportToString,
function(c)
	local i, j, k, n, nn, d, neighbors, facets, perm, l, queue, ctr, 
		ctr2, labeling, current, face, s, isosig, done,  
		addNextValue;

	if not SCIsSimplicialComplex(c) then
		Info(InfoSimpcomp,1,"SCExportToString: argument must be of type SCIsSimplicialComplex.");
		return fail;
	fi;

	if HasSCExportIsoSig(c) then
		return SCExportIsoSig(c);
	fi;

	if SCIsEmpty(c) then
		return ".";
	fi;

	if SCHasBoundary(c) or not SCIsStronglyConnected(c) or not SCIsPseudoManifold(c) then
		Info(InfoSimpcomp,1,"SCExportIsoSig: argument must be a strongly connected closed pseudomanifold.");
		return fail;
	fi;

	addNextValue:=function(val)
		local lut,str,ctr,prefix;
		lut := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ)!@#$%^&*(+.";
		str:="";
		if val = 0 then
			Add(str,lut[64]);
			return str;
		elif val > 0 and val < 64 then
			Add(str,lut[val]);
			return str;
		else
			ctr:=0;
			while val > 0 do
				ctr:=ctr+1;
				Add(str,lut[((val-1) mod 64)+1]);
				val := Int(val/64);
			od;
			prefix := ShallowCopy(String(ctr));
			str := Reversed(str);
			Append(prefix,str);
			return prefix;
		fi;
	end;

	facets := SCFacetsEx(c);
	if facets = fail then
		return fail;
	fi;
	n := Size(facets);
	s := Size(facets[1]);
	# build list of neighbors
	neighbors := [];
	for i in [1..n] do
		neighbors[i]:=[];
		for j in [1..n] do
			if i = j then continue; fi;
			if Size(Intersection(facets[i],facets[j])) = s-1 then
				Add(neighbors[i],j);
			fi;
		od;
	od;
	# calculate signature for standard labeling of first facet
	l := [];
	labeling := ShallowCopy(facets[1]);
	queue := [1];
	done := [1];
	ctr := 0;
	ctr2 := 0;
	while ctr2 < n-1 do
		ctr := ctr+1;
		current := queue[ctr];
		for j in labeling do
			if not j in facets[current] then continue; fi;
			face := ShallowCopy(facets[current]);
			Remove(face,Position(face,j));
			Sort(face);
			for nn in neighbors[current] do
				if nn in queue then continue; fi;
				if IsSubset(facets[nn],face) then
					Add(queue,nn);
					Add(done,0);
					break;
				fi;
			od;
			for k in neighbors[current] do
				if IsSubset(facets[k],face) then
					if done[Position(queue,k)] = 1 then
						Add(l,0);
						continue;
					fi;
					d := Difference(facets[k],face)[1];
					if not d in labeling then
						Add(labeling,d);
						Add(l,Size(labeling));
						ctr2:=ctr2+1;
					else
						Add(l,Position(labeling,d));
						ctr2:=ctr2+1;
					fi;
					done[Position(queue,k)] := 1;
				fi;
			od;
		od;
	od;
	isosig:="";
	# store dimension
	Append(isosig,addNextValue(s));
	# for first d facets skip is always zero: omit these zeros
	for i in [1..s] do
		Append(isosig,addNextValue(l[i]));
	od;
	# store rest of minl
	ctr2 := 0;
	for i in [s+1..Size(l)] do
		if l[i] = 0 then 
			# if skip, count number of skips
			ctr2 := ctr2+1;
		else
			# add skip and next value to isosig
			Append(isosig,addNextValue(ctr2));
			Append(isosig,addNextValue(l[i]));
			ctr2 := 0;
		fi;
	od;
	return isosig;
end);


################################################################################
##<#GAPDoc Label="SCFromIsoSig">
## <ManSection>
## <Meth Name="SCFromIsoSig" Arg="str"/>
## <Returns>a SCSimplicialComplex object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a simplicial complex from its isomorphism signature. If a file with
## isomorphism signatures is provided a list of all complexes is returned.
## <Example><![CDATA[
## gap> s:="deeee";;
## gap> c:=SCFromIsoSig(s);;
## gap> SCIsIsomorphic(c,SCBdSimplex(4));
## ]]></Example>
## <Example><![CDATA[
## gap> s:="deeee";;
## gap> PrintTo("tmp.txt",s,"\n");;
## gap> cc:=SCFromIsoSig("tmp.txt");
## gap> cc[1].F;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFromIsoSig,
"for String",
[IsString],
function(str)
	local sig, i, size, ctr1, ctr2, done, new, facets, comb, skip, val, tmp,
		s, getNextValue, c, cc, l;

	if IsExistingFile(str) then
		s := InputTextFile(str);
		l := ReadLine(s);
		cc :=[];
		while l <> fail do
			if l{[Size(l)]} <> "\n" then
				Info(InfoSimpcomp,1,"SCFromIsoSig: cannot read file format, line ended without newline.\n");
				return fail;
			fi;
			l := l{[1..Size(l)-1]};
			Add(cc,SCFromIsoSig(l));
			l :=ReadLine(s);
		od;
		return cc;
	fi;

	getNextValue:=function(str,idx)
		local lut,val,ctr,power,tmp,pos;
		lut := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ)!@#$%^&*(+.";
		if Int(str{[idx]}) = fail then
			pos:=Position(lut,str[idx]);
			if pos = fail then
				Info(InfoSimpcomp,1,"SCFromIsoSig: invalid isomorphism signature provided.\n");
				return fail;
			fi;
			return [pos mod 64,idx+1];
		else
			val:=0;
			ctr := idx;
			while Int(str{[ctr]}) <> fail do
				ctr:=ctr+1;
			od;
			power:=Int(str{[idx..ctr-1]});
			for i in [1..power] do
				pos:=Position(lut,str[ctr]);
				if pos = fail then
					Info(InfoSimpcomp,1,"SCFromIsoSig: invalid isomorphism signature provided.\n");
					return fail;
				fi;
				val := val + (pos mod 64)*64^(power-i);
				ctr:=ctr+1;
			od;
			return [val,ctr];
		fi;
	end;

	if str = "" then
		Info(InfoSimpcomp,1,"SCFromIsoSig: isomorphism signature is empty.\n");
		return fail;
	fi;

	if str = "." then
		return SCEmpty();
	fi;

	sig:=[];
	tmp:=getNextValue(str,1);
	if tmp = fail then
		return fail;
	fi;
	size := tmp[1];
	ctr1 := tmp[2];
	facets:=[[1..size]];
	for i in [1..size] do
		Add(sig,0);
		tmp:=getNextValue(str,ctr1);
		if tmp = fail then
			return fail;
		fi;
		val := tmp[1];
		ctr1 := tmp[2];
		Add(sig,val);
	od;
	while ctr1 <= Size(str) do
		tmp:=getNextValue(str,ctr1);
		if tmp = fail then
			return fail;
		fi;
		val := tmp[1];
		ctr1 := tmp[2];
		Add(sig,val);
	od;
	ctr1:=1;
	ctr2:=1;
	done:=false;
	skip:=true;
	while not done do
		for comb in Reversed(Combinations(facets[ctr1],size-1)) do
			if skip then
				if ctr2 >= Size(sig) then
					done:=true;
					break;
				fi;
				if sig[ctr2] > 0 then
					sig[ctr2] := sig[ctr2]-1;
					continue;
				else
					ctr2 := ctr2+1;
					skip := false;
				fi;
			fi;
			if not skip then
				new:=Concatenation(comb,[sig[ctr2]]);
        Sort(new);
				Add(facets,new);
				ctr2:=ctr2+1;
				skip := true;
				if ctr2 > Size(sig) then
					done:=true;
					break;
				fi;
			fi;
		od;
		if not done then ctr1:=ctr1+1; fi;
	od;

	c := SCFromFacets(facets);

  if c = fail then
    Print(facets,"\n");    
  fi;

	SetSCExportIsoSig(c,str);

	return c;
end);

